; -*- mode: lisp; package: github -*-

;;; github/api/base.l
;;
;; Copyright (c) 2010 MIYAMUKO Katsuyuki.
;;
;; Permission is hereby granted, free of charge, to any person obtaining
;; a copy of this software and associated documentation files (the
;; "Software"), to deal in the Software without restriction, including
;; without limitation the rights to use, copy, modify, merge, publish,
;; distribute, sublicense, and/or sell copies of the Software, and to
;; permit persons to whom the Software is furnished to do so, subject to
;; the following conditions:
;;
;; The above copyright notice and this permission notice shall be
;; included in all copies or substantial portions of the Software.
;;
;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
;; EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
;; MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
;; NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
;; LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
;; OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
;; WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

;;; Code:

(eval-when (:compile-toplevel :load-toplevel :execute)
  (mc-require "github/package")
  (mc-require "github/http")
  (mc-require "github/git-config")
  (mc-require "github/utils/struct")
  (mc-require "github/utils/function")
  (mc-require "github/utils/srfi-26")
  (mc-require "github/utils/pubkey")
  (mc-require "github/api/types")
  )

(in-package :github)

(export '(get-credential-login
          refresh-credential
          ))

(defvar *github-domain* "github.com")
(defvar *github-api-endpoint* "github.com/api/v2/json")

(defvar *github-return-type* :struct)

(defvar *github-use-tls/ssl* nil)

(defvar *github-login* nil)

(defvar *github-token* nil)


(defun get-credential-login ()
  (init-credential)
  *github-login*)

(defun refresh-credential ()
  (setf *github-login* nil
        *github-token* nil)
  (not (null (init-credential))))


(defun get-credential-alist ()
  (init-credential)
  (list (cons :login *github-login*)
        (cons :token *github-token*)))

(defun init-credential ()
  (when (and *github-login* *github-token*)
    (return-from init-credential))
  (multiple-value-bind (login token)
      (get-credential)
    (unless (and login token)
      (plain-error "github.user と github.token を git config で設定してください"))
    (setf *github-login* login
          *github-token* token)))

(defun github-get (path-template &key uri-params query-params return-type send-login-token
                                 key callback (async (not (null callback)))
                                 raw nomsg)
  (let ((uri (build-uri path-template uri-params)))
    (when send-login-token
      (setf query-params (append (get-credential-alist) query-params)))
    (do-get uri
            :query (remove-if-not #'cdr query-params)
            :async async
            :oncomplete (compose callback key (cut process-response <> raw return-type))
            :nomsg nomsg)))

(defun github-post (path-template &key uri-params data return-type
                                  key callback (async (not (null callback)))
                                  raw nomsg)
  (let ((uri (build-uri path-template uri-params)))
    (setf data (append (get-credential-alist) data))
    (do-post uri data
             :async async
             :oncomplete (compose callback key (cut process-response <> raw return-type))
             :nomsg nomsg)))

(defun process-response (r raw return-type)
  (let ((type (getf return-type :type))
        (root (getf return-type :root))
        (list (getf return-type :list))
        (object (getf return-type :object)))
    ;; 生テキスト
    (when (or raw (eql *github-return-type* :raw))
      (return-from process-response r))
    ;; json
    (setf r (if (and r (string/= "" r))
                (json-decode r)
              nil))
    (when (eql *github-return-type* :json-with-root)
      (return-from process-response r))
    ;; root キーの値 (たぶん alist)
    (when root
      (setf r (json-value r root)))
    (when (not object)
      (return-from process-response r))
    ;; root キーの値 (alist)
    (when (eql *github-return-type* :json-keys)
      (return-from process-response (json-object-keys (if list (car r) r))))
    (when (eql *github-return-type* :plist)
      (return-from process-response (apply-converter 'alist->plist r list)))
    (when (eql *github-return-type* :alist)
      (return-from process-response r))
    (when (not type)
      (return-from process-response r))
    ;; type が関数なら関数を実行して type を決定
    (when (functionp type)
      (setf type (funcall type r)))
    ;; json を構造体に変換する
    (apply-converter #'(lambda (e) (json->struct type e)) r list)))

(defun apply-converter (converter json list)
  (if list
      (mapcar #'(lambda (e)
                  (funcall converter e))
              json)
    (funcall converter json)))

(defun build-uri (path-template uri-params)
  (bind-params (format nil "~A://~A/~A"
                       (if *github-use-tls/ssl* "https" "http")
                       *github-api-endpoint*
                       path-template)
               uri-params))

(defun to-bool (v)
  (if v "true" "false"))

(defun to-one-or-zero (v)
  (if v "1" "0"))

(defun alist->plist (alist)
  (loop for (k . v) in alist
    nconc (list (intern k :keyword) v)))

(defun json->struct (name json)
  (let ((struct (make-struct name))
        (def (struct-definition name))
        (mapping (get name 'github-slot-mapping)))
    (dolist (key (json-object-keys json))
      (let* ((slot-name (keyword (substitute-string key "_" "-")))
             (slot-name (or (getf mapping slot-name)
                            slot-name))
             (slot-type (struct-slot-type def slot-name))
             (accessor (struct-slot-accessor name slot-name))
             (list (get accessor 'github-json-list))
             (obj (json-value json key :test #'string=))
             (converter (or (get accessor 'github-filter)
                            (if (struct-name-p slot-type)
                                #'(lambda (e) (json->struct slot-type e)))
                            'identity)))
        (setf (struct-slot-value struct slot-name)
              (apply-converter #'(lambda (e)
                                   (funcall converter e))
                               obj list))))
    struct))


(provide "github/api/base")

;;; End
