; -*- mode: lisp; package: github.v3 -*-

;;; github/api/v3/orgs/members.l
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
; title: Org Members API v3 | developer.github.com
; ---

; # Org Members API
(define-github-core :GET "/orgs/:org/members" "
## List members

List all users who are members of an organization. A member is a user
that belongs to at least 1 team in the organization. If the authenticated user is
also a member of this organization then both concealed and public
members will be returned. Otherwise only public members are returned.

    GET /orgs/:org/members

### Response

<%= headers 200 %>
<%= json(:user) { |h| [h] } %>

")

(define-github-core :GET "/orgs/:org/members/:user" "
## Get member

    GET /orgs/:org/members/:user

### Reponse if user is a member

<%= headers 204 %>

### Reponse if user is not a member

<%= headers 404 %>

")

; Add a member

; To add someone as a member to an org, you must add them to a
; [team](/v3/orgs/teams/#add-team-member).
(define-github-core :DELETE "/orgs/:org/members/:user" "
## Remove a member

Removing a user from this list will remove them from all teams and
they will no longer have any access to the organization's repositories.

    DELETE /orgs/:org/members/:user

### Response

<%= headers 204 %>

")

(define-github-core :GET "/orgs/:org/public_members" "
## List public members

Members of an organization can choose to have their membership
publicized or not.

    GET /orgs/:org/public_members

### Response

<%= headers 200 %>
<%= json(:user) { |h| [h] } %>

")

(define-github-core :GET "/orgs/:org/public_members/:user" "
## Get if a user is a public member

    GET /orgs/:org/public_members/:user

### Reponse if user is a public member

<%= headers 204 %>

### Reponse if user is not a public member

<%= headers 404 %>

")

(define-github-core :PUT "/orgs/:org/public_members/:user" "
## Publicize a user's membership

    PUT /orgs/:org/public_members/:user

### Response

<%= headers 204 %>

")

(define-github-core :DELETE "/orgs/:org/public_members/:user" "
## Conceal a user's membership

    DELETE /orgs/:org/public_members/:user

")

; Response

; <%= headers 204 %>

(provide "github/api/v3/orgs/members")

;;; End
