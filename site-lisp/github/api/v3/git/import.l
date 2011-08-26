; -*- mode: lisp; package: github.v3 -*-

;;; github/api/v3/git/import.l
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
  (require "github/api/v3/base")
  )

(in-package :github.v3)

; ---
; title: Git DB Import API v3 | developer.github.com
; ---

; # Import API

; `git fast-import` input parser

; Would this be cool?

; See the [Pro Git book](http://progit.org/book/ch8-2.html#a_custom_importer) or the
; [fast-import man page](http://www.kernel.org/pub/software/scm/git/docs/git-fast-import.html)
; for more information about the fast-import syntax.

; It would be awesome if there was some way to open up a streaming
; listener and just stream this data to it in order to:

; * import directly into github from the fast-export scripts that exist
;   for multiple VCS systems

; * be able to easily import multiple objects - for instance a series of
;   commits without having to make multiple git calls

; even without streaming capability, this might be pretty interesting
; functionality.

(provide "github/api/v3/git/import")

;;; End
