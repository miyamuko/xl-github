; -*- mode: lisp; package: github.v3 -*-

;;; github/api/v3/repos/collaborators.l
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
; title: Repo Collaborators API v3 | developer.github.com
; ---

; # Repo Collaborators API
(define-github-core :GET "/repos/:user/:repo/collaborators" "
## List

    GET /repos/:user/:repo/collaborators

### Response

<%= headers 200 %>
<%= json(:user) { |h| [h] } %>

")

(define-github-core :GET "/repos/:user/:repo/collaborators/:user" "
## Get

    GET /repos/:user/:repo/collaborators/:user

### Reponse if user is a collaborator

<%= headers 204 %>

### Reponse if user is not a collaborator

<%= headers 404 %>

")

(define-github-core :PUT "/repos/:user/:repo/collaborators/:user" "
## Add collaborator

    PUT /repos/:user/:repo/collaborators/:user

### Response

<%= headers 204 %>

")

(define-github-core :DELETE "/repos/:user/:repo/collaborators/:user" "
## Remove collaborator

    DELETE /repos/:user/:repo/collaborators/:user

### Response

<%= headers 204 %>
")


(provide "github/api/v3/repos/collaborators")

;;; End
