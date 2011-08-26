; -*- mode: lisp; package: github.v3 -*-

;;; github/api/v3/git.l
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
; title: Git API v3 | developer.github.com
; ---

; # Git DB API

; The Git Database API gives you access to read and write raw Git objects
; to your Git database on GitHub and to list and update your references
; (branch heads and tags).

; This basically allows you to reimplement a lot of Git functionality over
; our API - by creating raw objects directly into the database and updating
; branch references you could technically do just about anything that Git
; can do without having Git installed.

; ![git db](http://progit.org/figures/ch9/18333fig0904-tn.png)

; For more information on the Git object database, please read the 
; <a href="http://progit.org/book/ch9-0.html">Git Internals</a> chapter of
; the Pro Git book.

; As an example, if you wanted to commit a change to a file in your
; repository, you would:

; * get the current commit object
; * retrieve the tree it points to
; * retrieve the content of the blob object that tree has for that particular file path
; * change the content somehow and post a new blob object with that new content, getting a blob SHA back
; * post a new tree object with that file path pointer replaced with your new blob SHA getting a tree SHA back
; * create a new commit object with the current commit SHA as the parent and the new tree SHA, getting a commit SHA back
; * update the reference of your branch to point to the new commit SHA

; It might seem complex, but it's actually pretty simple when you understand
; the model and it opens up a ton of things you could potentially do with the API.

(provide "github/api/v3/git")

;;; End
