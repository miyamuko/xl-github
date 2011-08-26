; -*- mode: lisp; package: github.v3 -*-

;;; github/api/v3/repos/watching.l
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
; title: Repo Watching API v3 | developer.github.com
; ---

; # Repo Watching API
(define-github-core :GET "/repos/:user/:repo/watchers" "
## List watchers

    GET /repos/:user/:repo/watchers

### Response

<%= headers 200, :pagination => true %>
<%= json(:user) { |h| [h] } %>

")

(define-github-core :GET "/users/:user/watched" "
## List repos being watched

List repos being watched by a user

    GET /users/:user/watched

List repos being watched by the authenticated user

    GET /user/watched

### Response

<%= headers 200, :pagination => true %>
<%= json(:repo) { |h| [h] } %>

")

(define-github-core :GET "/user/watched" "
## List repos being watched

List repos being watched by a user

    GET /users/:user/watched

List repos being watched by the authenticated user

    GET /user/watched

### Response

<%= headers 200, :pagination => true %>
<%= json(:repo) { |h| [h] } %>

")

(define-github-core :GET "/user/watched/:user/:repo" "
## Check if you are watching a repo

    GET /user/watched/:user/:repo

### Response if this repo is watched by you

<%= headers 204 %>

### Response if this repo is not watched by you

<%= headers 404 %>

")

(define-github-core :PUT "/user/watched/:user/:repo" "
## Watch a repo

    PUT /user/watched/:user/:repo

### Response

<%= headers 204 %>

")

(define-github-core :DELETE "/user/watched/:user/:repo" "
## Stop watching a repo

    DELETE /user/watched/:user/:repo

### Response

<%= headers 204 %>
")


(provide "github/api/v3/repos/watching")

;;; End
