; -*- mode: lisp; package: github; encoding: utf-8 -*-

;;; github/http.l
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
  (mc-require "github/about")
  (mc-require "github/utils/symbol")
  )

(in-package :github)

;; URI template

(defparameter *rfc3986-literal-chars "0-9A-Za-z---._~")
(defparameter *uri-param-pattern* ":\\([a-zA-Z0-9_]+\\)")

(defun bind-params (uri-template params &key
                                 (encoding *encoding-utf8n*)
                                 (literal-chars *rfc3986-literal-chars))
  (let ((names (param-names uri-template)))
    (unless (= (length names) (length params))
      (plain-error "wrong number of parameter (~S for ~S)" params names))
    (bind-plist1 uri-template names (mapcan #'list names params)
                 :encoding encoding :literal-chars literal-chars)))

(defun bind-plist (uri-template plist &key
                                (encoding *encoding-utf8n*)
                                (literal-chars *rfc3986-literal-chars))
  (let ((names (param-names uri-template)))
    (unless (= (* 2 (length names)) (length plist))
      (plain-error "wrong number of parameter (~S for ~S)" plist names))
    (bind-plist1 uri-template names plist
                 :encoding encoding :literal-chars literal-chars)))

(defun bind-plist1 (uri-template names plist &key
                                 (encoding *encoding-utf8n*)
                                 (literal-chars *rfc3986-literal-chars))
  (dolist (k names)
    (let ((v (or (getf plist k)
                 (plain-error "undefined parameter: ~S" k))))
      (setf uri-template
            (substitute-string uri-template
                               (format nil ":~A" k)
                               (url-encode (format nil "~A" v) encoding literal-chars)))))
  uri-template)

(defun param-names (uri-template)
  (let ((r nil)
        (start 0))
    (while (string-match *uri-param-pattern* uri-template start)
      (push (keyword (match-string 1)) r)
      (setf start (match-end 0)))
    (remove-duplicates (nreverse r))))

(defun url-encode (str encoding literal-chars)
  (si:www-url-encode (if encoding
                         (convert-encoding-from-internal encoding str)
                       str)
                     nil literal-chars))

;; HTTP Request

(defparameter *http-get-driver* 'do-get-xhr)
(defparameter *http-post-driver* 'do-post-xhr)

(defun do-get (uri &key query async oncomplete nomsg)
  (funcall *http-get-driver* uri :query query :async async :oncomplete oncomplete :nomsg nomsg))

(defun do-post (uri data &key async oncomplete nomsg)
  (funcall *http-post-driver* uri data :async async :oncomplete oncomplete :nomsg nomsg))

(defun http-headers ()
  `(:User-Agent ,(xl-github-useragent)))

(defun do-get-xhr (uri &key query async oncomplete nomsg)
  (let ((args (list uri
                    :key (if async
                             'get-response-text-with-warn
                           'get-response-text-with-error)
                    :oncomplete oncomplete
                    :encoding *encoding-utf8n*
                    :query query
                    :nomsg nomsg
                    :since :epoch
                    :progid :winhttp
                    :headers (http-headers))))
    (if async
        (apply 'xhr-get-async args)
      (funcall oncomplete (apply 'xhr-get args)))))

(defun do-post-xhr (uri data &key async oncomplete nomsg)
  (let ((args (list uri data
                    :key (if async
                             'get-response-text-with-warn
                           'get-response-text-with-error)
                    :encoding *encoding-utf8n*
                    :oncomplete oncomplete
                    :nomsg nomsg
                    :progid :winhttp
                    :headers (http-headers))))
    (if async
        (apply 'xhr-post-async args)
      (funcall oncomplete (apply 'xhr-post args)))))

(defun get-response-text-with-error (xhr)
  (get-response-text xhr t))

(defun get-response-text-with-warn (xhr)
  (get-response-text xhr nil))

(defun get-response-text (xhr error)
  (if (<= 200 (xhr-status xhr) 299)
      (xhr-response-text xhr)
    (let ((msg (format nil "~D ~A~@[ (~A)~]"
                       (xhr-status xhr)
                       (xhr-status-text xhr)
                       (try-parse-error-message xhr))))
      (if error
          (error 'network-error :datum msg)
        (warn msg))
      nil)))

(defun try-parse-error-message (xhr)
  (let ((text (xhr-response-text xhr)))
    (when text
      (ignore-errors
       (json-value (json-decode text) "error")))))


(provide "github/http")

;;; End
