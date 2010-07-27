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
  (mc-require "github/api/types")
  )

(in-package :github)

(defvar *github-domain* "github.com")
(defvar *github-api-endpoint* "github.com/api/v2/json")

(defvar *github-use-tls/ssl* nil)

(defvar *github-login* nil)

(defvar *github-token* nil)


(defun github-credential-alist ()
  (unless (and *github-login* *github-token*)
    (init-github-credential))
  (list (cons :login *github-login*)
        (cons :token *github-token*)))

(defun init-github-credential ()
  (multiple-value-bind (login token)
      (github-credential)
    (unless (and login token)
      (plain-error "github.user と github.token を git config で設定してください"))
    (setf *github-login* login
          *github-token* token)))

(defun github-get (path-template &key uri-params query-params send-login-token raw nomsg)
  (let ((uri (build-uri path-template uri-params)))
    (when send-login-token
      (setf query-params (append (github-credential-alist) query-params)))
    (let ((text (do-get uri
                        :query (remove-if-not #'cdr query-params)
                        :nomsg nomsg)))
      (if raw
          text
        (json-decode text)))))

(defun github-post (path-template &key uri-params data nomsg)
  (let ((uri (build-uri path-template uri-params)))
    (setf data (append (github-credential-alist) data))
    (json-decode (do-post uri data :nomsg nomsg))))

(defun build-uri (path-template uri-params)
  (bind-params (format nil "~A://~A/~A"
                       (if *github-use-tls/ssl* "https" "http")
                       *github-api-endpoint*
                       path-template)
               uri-params))


(provide "github/api/base")

;;; End
