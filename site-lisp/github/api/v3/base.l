; -*- mode: lisp; package: github.core; encoding: shift_jis -*-

;;; github/api/v3/base.l
;;
;; Copyright (c) 2011 MIYAMUKO Katsuyuki.
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
  (require "github/package")
  )

(in-package :github.v3)

(eval-when (:compile-toplevel :load-toplevel :execute)
  (defun make-api-symbol (verb url-template)
    (let ((path (substitute-string url-template ":" "$")))
      (intern (format nil "~A~A" verb path))))

  (defun make-api-params (url-template)
    (mapcan #'(lambda (path)
                (and (string-match "^[:*]\\([a-zA-Z0-9]+\\)" path)
                     (list (intern (match-string 1)))))
            (split-string url-template #\/)))
  )

(defmacro define-github-core (verb url-template desc)
  (let ((api (make-api-symbol verb url-template))
        (params (make-api-params url-template)))
    `(defun ,api (,@params &key callback params data)
       ,desc
       (do-request verb url-template
                   (list ,@(mapcar #'(lambda (param)
                                       `(cons ,(intern (string param) :keyword)
                                              ,param))
                                   params))
                   params data callback
                   ))))

(defun do-request (method uri data &key query async oncomplete nomsg)
  (let ((args (list method uri data
                    :key (if async
                             'get-response-text-with-warn
                           'get-response-text-with-error)
                    :encoding *encoding-utf8n*
                    :oncomplete oncomplete
                    :query query
                    :nomsg nomsg
                    :progid :winhttp
                    :headers (http-headers))))
    (if async
        (apply 'xhr-request-async args)
      (funcall oncomplete (apply 'xhr-request args)))))


(provide "github/api/v3/base")

;;; End
