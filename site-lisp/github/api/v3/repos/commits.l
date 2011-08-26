; -*- mode: lisp; package: github.v3 -*-

;;; github/api/v3/repos/commits.l
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
; title: Repo Commits API v3 | developer.github.com
; ---

; # Repo Commits API
(define-github-core :GET "/repos/:user/:repo/commits" "
## List commits on a repository

    GET /repos/:user/:repo/commits

### Parameters

sha
: _Optional_ **string** - Sha or branch to start listing commits from.

path
: _Optional_ **string** - Only commits containing this file path
will be returned.

### Response

<%= headers 200 %>
<%= json(:commit) { |h| [h] } %>

")

(define-github-core :GET "/repos/:user/:repo/commits/:sha" "
## Get a single commit

    GET /repos/:user/:repo/commits/:sha

### Response

<%= headers 200 %>
<%= json(:full_commit) %>

")

(define-github-core :GET "/repos/:user/:repo/comments" "
## List commit comments for a repository

Commit Comments leverage [these](#custom-mime-types) custom mime types. You can
read more about the use of mimes types in the API [here](/v3/mimes/).

    GET /repos/:user/:repo/comments

### Response

<%= headers 200 %>
<%= json(:commit_comment) { |h| [h] } %>

")

(define-github-core :GET "/repos/:user/:repo/commits/:sha/comments" "
## List comments for a single commit

    GET /repos/:user/:repo/commits/:sha/comments

### Response

<%= headers 200 %>
<%= json(:commit_comment) %>

")

(define-github-core :POST "/repos/:user/:repo/commits/:sha/comments" "
## Create a commit comment

    POST /repos/:user/:repo/commits/:sha/comments

### Input

body
: _Required_ **string**

commit_id
: _Required_ **string** - Sha of the commit to comment on.

line
: _Required_ **number** - Line number in the file to comment on.

path
: _Required_ **string** - Relative path of the file to comment on.

position
: _Required_ **number** - Line index in the diff to comment on.

#### Example

<%= json \
  :body      => 'Nice change',
  :commit_id => '6dcb09b5b57875f334f61aebed695e2e4193db5e',
  :line      => 1,
  :path      => 'file1.txt',
  :position  => 4,
%>

### Response

<%= headers 201, :Location => \"https://api.github.com/user/repo/comments/1\" %>
<%= json :commit_comment %>

")

(define-github-core :GET "/repos/:user/:repo/comments/:id" "
## Get a single commit comment

    GET /repos/:user/:repo/comments/:id

### Response

<%= headers 200 %>
<%= json :commit_comment %>

")

(define-github-core :PATCH "/repos/:user/:repo/comments/:id" "
## Update a commit comment

    PATCH /repos/:user/:repo/comments/:id

### Input

body
: _Required_ **string**

#### Example

<%= json \
  :body => 'Nice change'
%>

### Response

<%= headers 200 %>
<%= json :commit_comment %>

")

(define-github-core :DELETE "/repos/:user/:repo/comments/:id" "
## Delete a commit comment

    DELETE /repos/:user/:repo/comments/:id

### Response

<%= headers 204 %>

")

; Custom Mime Types

; These are the support mime types for commit comments. You can read more
; about the use of mimes types in the API [here](/v3/mimes/).

;     application/vnd.github-commitcomment.raw+json
;     application/vnd.github-commitcomment.text+json
;     application/vnd.github-commitcomment.html+json
;     application/vnd.github-commitcomment.full+json

(provide "github/api/v3/repos/commits")

;;; End
