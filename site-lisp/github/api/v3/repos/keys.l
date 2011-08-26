; -*- mode: lisp; package: github.v3 -*-

;;; github/api/v3/repos/keys.l
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
; title: Repo Deploy Keys API v3 | developer.github.com
; ---

; # Repo Deploy Keys API
(define-github-core :GET "/repos/:user/:repo/keys" "
## List

    GET /repos/:user/:repo/keys

### Response

<%= headers 200 %>
<%= json(:public_key) { |h| [h] } %>

")

(define-github-core :GET "/repos/:user/:repo/keys/:id" "
## Get

    GET /repos/:user/:repo/keys/:id

### Response

<%= headers 200 %>
<%= json :public_key %>

")

(define-github-core :POST "/repos/:user/:repo/keys" "
## Create

    POST /repos/:user/:repo/keys

### Input

<%= json :title => \"octocat@octomac\", :key => \"ssh-rsa AAA...\" %>

### Response

<%= headers 201, :Location => \"https://api.github.com/user/repo/keys/1\" %>
<%= json :public_key %>

")

(define-github-core :PATCH "/repos/:user/:repo/keys/:id" "
## Edit

    PATCH /repos/:user/:repo/keys/:id

### Input

<%= json :title => \"octocat@octomac\", :key => \"ssh-rsa AAA...\" %>

### Response

<%= headers 200 %>
<%= json :public_key %>

")

(define-github-core :DELETE "/repos/:user/:repo/keys/:id" "
## Delete

    DELETE /repos/:user/:repo/keys/:id

### Response

<%= headers 204 %>
")


(provide "github/api/v3/repos/keys")

;;; End
