; -*- mode: lisp; package: github.v3 -*-

;;; github/api/v3/repos.l
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
; title: Repos API v3 | developer.github.com
; ---

; # Repos API
(define-github-core :GET "/user/repos" "
## List

List repositories for the authenticated user.

    GET /user/repos

### Parameters

type
: `all`, `public`, `private`, `member`. Default: `all`.

List public repositories for the specified user.

    GET /users/:user/repos

List repositories for the specified org.

    GET /orgs/:org/repos

### Parameters

type
: `all`, `public`, `private`. Default: `all`.

### Response

<%= headers 200, :pagination => true %>
<%= json(:repo) { |h| [h] } %>

")

(define-github-core :GET "/users/:user/repos" "
## List

List repositories for the authenticated user.

    GET /user/repos

### Parameters

type
: `all`, `public`, `private`, `member`. Default: `all`.

List public repositories for the specified user.

    GET /users/:user/repos

List repositories for the specified org.

    GET /orgs/:org/repos

### Parameters

type
: `all`, `public`, `private`. Default: `all`.

### Response

<%= headers 200, :pagination => true %>
<%= json(:repo) { |h| [h] } %>

")

(define-github-core :GET "/orgs/:org/repos" "
## List

List repositories for the authenticated user.

    GET /user/repos

### Parameters

type
: `all`, `public`, `private`, `member`. Default: `all`.

List public repositories for the specified user.

    GET /users/:user/repos

List repositories for the specified org.

    GET /orgs/:org/repos

### Parameters

type
: `all`, `public`, `private`. Default: `all`.

### Response

<%= headers 200, :pagination => true %>
<%= json(:repo) { |h| [h] } %>

")

(define-github-core :POST "/user/repos" "
## Create

Create a new repository for the authenticated user.

    POST /user/repos

Create a new repository in this organization. The authenticated user must
be a member of `:org`.

    POST /orgs/:org/repos

### Input

name
: _Required_ **string**

description
: _Optional_ **string**

homepage
: _Optional_ **string**

public
: _Optional_ **boolean** - `true` to create a public repository, `false`
to create a private one. Creating private repositories requires a paid
GitHub account.

has\_issues
: _Optional_ **boolean** - `true` to enable issues for this repository,
`false` to disable them. Default is `true`.

has\_wiki
: _Optional_ **boolean** - `true` to enable the wiki for this
repository, `false` to disable it. Default is `true`.

has\_downloads
: _Optional_ **boolean** - `true` to enable downloads for this
repository, `false` to disable them. Default is `true`.

<%= json \
  :name          => \"Hello-World\",
  :description   => \"This is your first repo\",
  :homepage      => \"https://github.com\",
  :public        => true,
  :has_issues    => true,
  :has_wiki      => true,
  :has_downloads => true,
%>

### Response

<%= headers 201,
      :Location =>
'https://api.github.com/repos/octocat/Hello-World' %>
<%= json :repo %>

")

(define-github-core :POST "/orgs/:org/repos" "
## Create

Create a new repository for the authenticated user.

    POST /user/repos

Create a new repository in this organization. The authenticated user must
be a member of `:org`.

    POST /orgs/:org/repos

### Input

name
: _Required_ **string**

description
: _Optional_ **string**

homepage
: _Optional_ **string**

public
: _Optional_ **boolean** - `true` to create a public repository, `false`
to create a private one. Creating private repositories requires a paid
GitHub account.

has\_issues
: _Optional_ **boolean** - `true` to enable issues for this repository,
`false` to disable them. Default is `true`.

has\_wiki
: _Optional_ **boolean** - `true` to enable the wiki for this
repository, `false` to disable it. Default is `true`.

has\_downloads
: _Optional_ **boolean** - `true` to enable downloads for this
repository, `false` to disable them. Default is `true`.

<%= json \
  :name          => \"Hello-World\",
  :description   => \"This is your first repo\",
  :homepage      => \"https://github.com\",
  :public        => true,
  :has_issues    => true,
  :has_wiki      => true,
  :has_downloads => true,
%>

### Response

<%= headers 201,
      :Location =>
'https://api.github.com/repos/octocat/Hello-World' %>
<%= json :repo %>

")

(define-github-core :GET "/repos/:user/:repo" "
## Get

    GET /repos/:user/:repo

### Response

<%= headers 200 %>
<%= json :full_repo %>

")

(define-github-core :PATCH "/repos/:user/:repo" "
## Edit

    PATCH /repos/:user/:repo

### Input

name
: _Required_ **string**

description
: _Optional_ **string**

homepage
: _Optional_ **string**

public
: _Optional_ **boolean** - `true` to create a public repository, `false`
to create a private one. Creating private repositories requires a paid
GitHub account.

has\_issues
: _Optional_ **boolean** - `true` to enable issues for this repository,
`false` to disable them. Default is `true`.

has\_wiki
: _Optional_ **boolean** - `true` to enable the wiki for this
repository, `false` to disable it. Default is `true`.

has\_downloads
: _Optional_ **boolean** - `true` to enable downloads for this
repository, `false` to disable them. Default is `true`.

<%= json \
  :name          => \"Hello-World\",
  :description   => \"This is your first repo\",
  :homepage      => \"https://github.com\",
  :public        => true,
  :has_issues    => true,
  :has_wiki      => true,
  :has_downloads => true,
%>

### Response

<%= headers 200 %>
<%= json :full_repo %>

")

(define-github-core :GET "/repos/:user/:repo/contributors" "
## List contributors

    GET /repos/:user/:repo/contributors

### Parameters

anon
: Optional flag. Set to `1` or `true` to include anonymous contributors
in results.

### Response

<%= headers 200 %>
<%= json(:user) { |h| [h] } %>

")

(define-github-core :GET "/repos/:user/:repo/languages" "
## List languages

    GET /repos/:user/:repo/languages

### Response

<%= headers 200 %>
<%= json \
  \"C\"      => \"78769\",
  \"Python\" => \"7769\",
%>

")

(define-github-core :GET "/repos/:user/:repo/teams" "
## List Teams

    GET /repos/:user/:repo/teams

### Response

<%= headers 200 %>
<%= json(:team) { |h| [h] } %>

")

(define-github-core :GET "/repos/:user/:repo/tags" "
## List Tags

    GET /repos/:user/:repo/tags

### Response

<%= headers 200 %>
<%= json(:tag) { |h| [h] } %>

")

(define-github-core :GET "/repos/:user/:repo/branches" "
## List Branches

    GET /repos/:user/:repo/branches

### Response

<%= headers 200 %>
<%= json(:branch) { |h| [h] }%>
")


(provide "github/api/v3/repos")

;;; End
