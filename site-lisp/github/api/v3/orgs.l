; -*- mode: lisp; package: github.v3 -*-

;;; github/api/v3/orgs.l
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
; title: Orgs API v3 | developer.github.com
; ---

; # Orgs API
(define-github-core :GET "/users/:user/orgs" "
## List

List all public organizations for a user.

    GET /users/:user/orgs

List public and private organizations for the authenticated user.

    GET /user/orgs

### Response

<%= headers 200, :pagination => true %>
<%= json(:org) { |h| [h] } %>

")

(define-github-core :GET "/user/orgs" "
## List

List all public organizations for a user.

    GET /users/:user/orgs

List public and private organizations for the authenticated user.

    GET /user/orgs

### Response

<%= headers 200, :pagination => true %>
<%= json(:org) { |h| [h] } %>

")

(define-github-core :GET "/orgs/:org" "
## Get

    GET /orgs/:org

### Response

<%= headers 200 %>
<%= json(:full_org) %>

")

(define-github-core :PATCH "/orgs/:org" "
## Edit

    PATCH /orgs/:org

### Input

billing_email
: _Optional_ **string** - Billing email address. This address is not
publicized.

company
: _Optional_ **string**

email
: _Optional_ **string** - Publically visible email address.

location
: _Optional_ **string**

name
: _Optional_ **string**

<%= json \
    :billing_email => \"support@github.com\",
    :blog     => \"https://github.com/blog\",
    :company  => \"GitHub\",
    :email    => \"support@github.com\",
    :location => \"San Francisco\",
    :name     => \"github\"
    %>

### Response

<%= headers 200 %>
<%= json(:private_org) %>
")


(provide "github/api/v3/orgs")

;;; End
