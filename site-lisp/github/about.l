; -*- mode: lisp; package: github -*-

;;; github/version.l
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
  )

(in-package :github)

(export '(xl-github-version
          ))

(defconstant +xl-github-version+ "0.0.1")
(defconstant +xl-github-uri+ "http://miyamuko.s56.xrea.com/xyzzy/xl-github/intro.htm")

(defun xl-github-version ()
  +xl-github-version+)

(defun xl-github-uri ()
  +xl-github-uri+)

(defun xl-github-product ()
  (format nil "~A/~A" "xl-github" +xl-github-version+))

(defun xl-github-platform ()
  (format nil "~A ~A" (software-type) (software-version)))

(defun xl-github-useragent ()
  (format nil "~A (~A; ~A)"
          (xl-github-product)
          (xl-github-platform)
          +xl-github-uri+
          ))


(provide "github/version")

;;; End
