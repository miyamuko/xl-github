; -*- mode: lisp; package: github.v3 -*-

;;; github/api/v3/orgs/teams.l
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
; title: Org Teams API v3 | developer.github.com
; ---

; # Org Teams API

; All actions against teams require at a minimum an authenticated user who
; is a member of the owner's team in the `:org` being managed. Api calls
; that require explicit permissions are noted.
(define-github-core :GET "/orgs/:org/teams" "
## List teams

    GET /orgs/:org/teams

### Response

<%= headers 200 %>
<%= json(:team) { |h| [h] } %>

")

(define-github-core :GET "/teams/:id" "
## Get team

    GET /teams/:id

### Response

<%= headers 200 %>
<%= json(:full_team) %>

")

(define-github-core :POST "/orgs/:org/teams" "
## Create team

In order to create a team, the authenticated user must be an owner of
`:org`.

    POST /orgs/:org/teams

### Input

name
: _Required_ **string**

repo\_names
: _Optional_ **array** of **strings**

permission
: _Optional_ **string**

  `pull` - team members can pull, but not push or administor this
  repositories. **Default**

  `push` - team members can pull and push, but not administor this
  repositores.

  `admin` - team members can pull, push and administor these
  repositories.

<%= json \
  :name => 'new team',
  :permission => 'push',
  :repo_names => ['github/dotfiles'] %>

### Response

<%= headers 201 %>
<%= json(:full_team) %>

")

(define-github-core :PATCH "/teams/:id" "
## Edit team

In order to edit a team, the authenticated user must be an owner of
the org that the team is associated with.

    PATCH /teams/:id

### Input

name
: _Required_ **string**

permission
: _Optional_ **string**

<%= json \
  :name => 'new team name',
  :permission => 'push' %>

### Response

<%= headers 201 %>
<%= json(:full_team) %>

")

(define-github-core :DELETE "/teams/:id" "
## Delete team

In order to delete a team, the authenticated user must be an owner of
the org that the team is associated with.

    DELETE /teams/:id

### Response

<%= headers 204 %>

")

(define-github-core :GET "/teams/:id/members" "
## List team members

In order to list members in a team, the authenticated user must be a
member of the team.

    GET /teams/:id/members

### Response

<%= headers 200 %>
<%= json(:user) { |h| [h] } %>

")

(define-github-core :GET "/teams/:id/members/:user" "
## Get team member

In order to get if a user is a member of a team, the authenticated user
must be a member of the team.

    GET /teams/:id/members/:user

### Reponse if user is a member

<%= headers 204 %>

### Reponse if user is not a member

<%= headers 404 %>

")

(define-github-core :PUT "/teams/:id/members/:user" "
## Add team member

In order to add a user to a team, the authenticated user must have
'admin' permissions to the team or be an owner of the org that the team
is associated with.

    PUT /teams/:id/members/:user

### Reponse

<%= headers 204 %>

")

(define-github-core :DELETE "/teams/:id/members/:user" "
## Remove team member

In order to remove a user from a team, the authenticated user must have
'admin' permissions to the team or be an owner of the org that the team
is associated with.
NOTE: This does not delete the user, it just remove them from the team.

    DELETE /teams/:id/members/:user

### Reponse

<%= headers 204 %>

")

(define-github-core :GET "/teams/:id/repos" "
## List team repos

    GET /teams/:id/repos

### Response

<%= headers 200 %>
<%= json(:repo) { |h| [h] } %>

")

(define-github-core :GET "/teams/:id/repos/:user/:repo" "
## Get team repo

    GET /teams/:id/repos/:user/:repo

### Reponse if repo is managed by this team

<%= headers 204 %>

### Reponse if repo is not managed by this team

<%= headers 404 %>

")

(define-github-core :PUT "/teams/:id/repos/:user/:repo" "
## Add team repo

In order to add a repo to a team, the authenticated user must be an
owner of the org that the team is associated with.

    PUT /teams/:id/repos/:user/:repo

### Reponse

<%= headers 204 %>

")

(define-github-core :DELETE "/teams/:id/repos/:user/:repo" "
## Remove team repo

In order to add a repo to a team, the authenticated user must be an
owner of the org that the team is associated with.
NOTE: This does not delete the repo, it just removes it from the team.

    DELETE /teams/:id/repos/:user/:repo

### Reponse

<%= headers 204 %>

")


(provide "github/api/v3/orgs/teams")

;;; End
