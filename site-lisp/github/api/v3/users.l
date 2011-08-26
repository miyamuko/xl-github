; -*- mode: lisp; package: github.v3 -*-

;;; github/api/v3/users.l
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
; title: Users API v3 | developer.github.com
; ---

; # Users API

; Many of the resources on the users API provide a shortcut for getting
; information about the currently authenticated user. If a request URL
; does not include a `:user` parameter than the response will be for the
; logged in user (and you must pass [authentication
; information](/v3/#authentication) with your request).
(define-github-core :GET "/users/:user" "
## Get a single user

    GET /users/:user

### Response

<%= headers 200 %>
<%= json :full_user %>

")

(define-github-core :GET "/user" "
## Get the authenticated user

    GET /user

### Response

<%= headers 200 %>
<%= json :private_user %>

")

(define-github-core :PATCH "/user" "
## Update the authenticated user

    PATCH /user

### Input

name
: _Optional_ **string**

email
: _Optional_ **string** - Publically visible email address.

blog
: _Optional_ **string**

company
: _Optional_ **string**

location
: _Optional_ **string**

hireable
: _Optional_ **boolean**

bio
: _Optional_ **string**

<%= json \
    :name     => \"monalisa octocat\",
    :email    => \"octocat@github.com\",
    :blog     => \"https://github.com/blog\",
    :company  => \"GitHub\",
    :location => \"San Francisco\",
    :hireable => true,
    :bio      => \"There once...\"
%>

### Response

<%= headers 200 %>
<%= json :private_user %>

")


(provide "github/api/v3/users")

;;; End
