; -*- mode: lisp; package: github -*-

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
  )

(in-package :github)

;; URI template

(defparameter *rfc3986-literal-chars "0-9A-Za-z---._~")
(defparameter *uri-param-pattern* "[:*]\\([a-zA-Z0-9_]+\\)")

(defun bind-params (uri-template params &key
                                (encoding *encoding-utf8n*)
                                (literal-chars *rfc3986-literal-chars))
  (let ((names (param-names uri-template)))
    (unless (= (length names) (length params))
      (plain-error "wrong number of parameter (~D ~S for ~D ~S)"
                   (length params) params (length names) names)))
  (dolist (param params)
    (let ((v (url-encode (string param) encoding literal-chars)))
      (setf uri-template (substitute-string uri-template *uri-param-pattern* v :count 1))))
  uri-template)

(defun param-names (uri-template)
  (let ((r nil)
        (start 0))
    (while (string-match *uri-param-pattern* uri-template start)
      (push (intern (match-string 1)) r)
      (setf start (match-end 0)))
    (nreverse r)))

(defun url-encode (str encoding literal-chars)
  (si:www-url-encode (if encoding
                         (convert-encoding-from-internal encoding str)
                       str)
                     nil literal-chars))

;; HTTP Request

(defparameter *http-get-driver* 'do-get-xhr)
(defparameter *http-post-driver* 'do-post-xhr)

(defun do-get-json (uri &key query since nomsg)
  (json-decode
   (funcall *http-get-driver* uri :query query :since since :nomsg nomsg)))

(defun do-post-json (uri data &key nomsg)
  (json-decode
   (funcall *http-post-driver* uri data :nomsg nomsg)))


(defun http-headers ()
  `(:User-Agent ,(github-user-agent)))

(defun do-get-xhr (uri &key query since nomsg)
  (xhr-get uri
           :key 'get-response-text/check-status
           :encoding *encoding-utf8n*
           :query query
           :nomsg nomsg :since (or since :epoch)
           :headers (http-headers)))

(defun do-post-xhr (uri data &key nomsg)
  (xhr-post uri data
           :key 'get-response-text/check-status
           :encoding *encoding-utf8n*
           :nomsg nomsg
           :headers (http-headers)))

(defun get-response-text/check-status (xhr)
  (unless (<= 200 (xhr-status xhr) 299)
    (error 'network-error
           :datum (format nil "~D ~A~@[ (~A)~]"
                          (xhr-status xhr)
                          (xhr-status-text xhr)
                          (try-parse-error-message xhr))))
  (xhr-response-text xhr))

(defun try-parse-error-message (xhr)
  (let ((text (xhr-response-text xhr)))
    (when text
      (ignore-errors
       ($ (json-decode text) "error")))))


(provide "github/http")

;;; End
