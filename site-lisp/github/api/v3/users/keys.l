; -*- mode: lisp; package: github.v3 -*-

;;; github/api/v3/users/keys.l
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
; title: User Public Keys API v3 | developer.github.com
; ---

; # User Public Keys API

; Management of public keys via the API requires that you are
; authenticated.
(define-github-core :GET "/user/keys" "
## List public keys for a user

    GET /user/keys

### Response

<%= headers 200 %>
<%= json(:public_key) { |h| [h] } %>

")

(define-github-core :GET "/user/keys/:id" "
## Get a single public key

    GET /user/keys/:id

### Response

<%= headers 200 %>
<%= json :public_key %>

")

(define-github-core :POST "/user/keys" "
## Create a public key

    POST /user/keys

### Input

<%= json :title => \"octocat@octomac\", :key => \"ssh-rsa AAA...\" %>

### Response

<%= headers 201, :Location => \"https://api.github.com/user/keys/1\" %>
<%= json :public_key %>

")

(define-github-core :PATCH "/user/keys/:id" "
## Update a public key

    PATCH /user/keys/:id

### Input

<%= json :title => \"octocat@octomac\", :key => \"ssh-rsa AAA...\" %>

### Response

<%= headers 200 %>
<%= json :public_key %>

")

(define-github-core :DELETE "/user/keys/:id" "
## Delete a public key

    DELETE /user/keys/:id

### Response

<%= headers 204 %>
")


(provide "github/api/v3/users/keys")

;;; End
