; -*- mode: lisp; package: github.v3 -*-

;;; github/api/v3/users/followers.l
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
; title: User Followers API v3 | developer.github.com
; ---

; # User Followers API
(define-github-core :GET "/users/:user/followers" "
## List followers of a user

List a user's followers:

    GET /users/:user/followers

List the authenticated user's followers:

    GET /user/followers

### Response

<%= headers 200, :pagination => true %>
<%= json(:user) { |h| [h] } %>

")

(define-github-core :GET "/user/followers" "
## List followers of a user

List a user's followers:

    GET /users/:user/followers

List the authenticated user's followers:

    GET /user/followers

### Response

<%= headers 200, :pagination => true %>
<%= json(:user) { |h| [h] } %>

")

(define-github-core :GET "/users/:user/following" "
## List users following another user

List who a user is following:

    GET /users/:user/following

List who the authenicated user is following:

    GET /user/following

### Response

<%= headers 200, :pagination => true %>
<%= json(:user) { |h| [h] } %>

")

(define-github-core :GET "/user/following" "
## List users following another user

List who a user is following:

    GET /users/:user/following

List who the authenicated user is following:

    GET /user/following

### Response

<%= headers 200, :pagination => true %>
<%= json(:user) { |h| [h] } %>

")

(define-github-core :GET "/user/following/:user" "
## Check if you are following a user

    GET /user/following/:user

### Response if you are following this user

<%= headers 204 %>

### Response if you are not following this user

<%= headers 404 %>

")

(define-github-core :PUT "/user/following/:user" "
## Follow a user

    PUT /user/following/:user

### Response

<%= headers 204 %>

")

(define-github-core :DELETE "/user/following/:user" "
## Unfollow a user

    DELETE /user/following/:user

### Response

<%= headers 204 %>
")


(provide "github/api/v3/users/followers")

;;; End
