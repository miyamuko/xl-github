; -*- mode: lisp; package: github; encoding: utf-8 -*-

;;; github/utils/html.l
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
  (mc-require "github/utils/string")
  )

(in-package :github)

(defparameter *html-special-chars-alist*
  '(("&nbsp;" . " ")
    ("&lt;" . "<")
    ("&gt;" . ">")
    ("&quot;" . "\"")
    ("&#39;" . "'")
    ("&amp;" . "&")))

(defun html-remove-tag (html)
  (when html
    (substitute-string html "<[^<>]+>" "")))

(defun html-unescape (html)
  (when html
    (gsub (html "&[a-zA-Z0-9#]+;")
      (let ((m (string-downcase (match-string 0))))
        (or (cdr (assoc m *html-special-chars-alist* :test #'string=))
            (progn
              (warn "Unknown HTML escape sequence: ~S" m)
              m))))))


(provide "github/utils/html")

;;; End
