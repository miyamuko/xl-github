; -*- mode: lisp; package: github; encoding: shift_jis -*-

;;; github/git-config.l
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
  (require "github/utils/symbol")
  (require "github/utils/process")
  )

(in-package :github)

(defun get-credential ()
  (let ((config-list (git-config-list)))
    (values
     (git-config :github.user config-list)
     (git-config :github.token config-list))))

(defun git-config-list ()
  (mapcan #'(lambda (config)
              (let ((kv (split-string config #\= 2)))
                (cons (keyword (car kv))
                      (cdr kv))))
          (process-output->string-list "git config --global --list")))

(defun git-config (key config-list)
  (when (stringp key)
    (setf key (keyword key)))
  (getf config-list key))

(defun git-version ()
  (car (process-output->string-list "git --version")))


(provide "github/git-config")

;;; End
