; -*- mode: lisp; package: github; encoding: shift_jis -*-

;;; github/utils/string.l
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
  (require "github/package")
  )

(in-package :github)

(defmacro gsub ((str re) &body body)
  `(call-gsub ,str ,re #'(lambda () ,@body)))
(setf (get 'gsub 'ed:lisp-indent-hook) 1)

(defun call-gsub (str re fn)
  (when (and re str)
    (let ((result)
          (start 0))
      (while (string-match re str start)
        (let ((b (match-beginning 0))
              (e (match-end 0)))
          (push (substring str start b) result)
          (push (funcall fn) result)
          (setf start e)))
      (push (substring str start) result)
      (format nil "~{~A~}" (reverse result)))))


(provide "github/utils/string")

;;; End
