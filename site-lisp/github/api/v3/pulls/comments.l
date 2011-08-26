; -*- mode: lisp; package: github.v3 -*-

;;; github/api/v3/pulls/comments.l
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
; title: Pull Request Comments API v3 | developer.github.com
; ---

; # Pull Request Comments API

; Pull Request Comments leverage [these](#custom-mime-types) custom mime
; types. You can read more about the use of mimes types in the API
; [here](/v3/mimes/).
(define-github-core :GET "/repos/:user/:repo/pulls/:id/comments" "
## List comments on a pull request

    GET /repos/:user/:repo/pulls/:id/comments

### Response

<%= headers 200 %>
<%= json(:pull_comment) { |h| [h] } %>

")

(define-github-core :GET "/repos/:user/:repo/pulls/comments/:id" "
## Get a single comment

    GET /repos/:user/:repo/pulls/comments/:id

### Response

<%= headers 200 %>
<%= json :pull_comment %>

")

(define-github-core :POST "/repos/:user/:repo/pulls/:id/comments" "
## Create a comment

    POST /repos/:user/:repo/pulls/:id/comments

### Input

body
: _Required_ **string**

commit_id
: _Required_ **string** - Sha of the commit to comment on.

path
: _Required_ **string** - Relative path of the file to comment on.

position
: _Required_ **number** - Line index in the diff to comment on.

#### Example

<%= json \
  :body      => 'Nice change',
  :commit_id => '6dcb09b5b57875f334f61aebed695e2e4193db5e',
  :path      => 'file1.txt',
  :position  => 4,
%>

### Alternative Input

Instead of passing `commit_id`, `path`, and `position` you can reply to
an existing Pull Request Comment like this:

body
: _Required_ **string**

in_reply_to
: _Required_ **number** - Comment id to reply to.

#### Example

<%= json \
  :body        => 'Nice change',
  :in_reply_to => 4,
%>

### Response

<%= headers 201,
      :Location =>
\"https://api.github.com/repos/:user/:repo/pulls/comments/1\" %>
<%= json :pull_comment %>

")

(define-github-core :PATCH "/repos/:user/:repo/pulls/comments/:id" "
## Edit a comment

    PATCH /repos/:user/:repo/pulls/comments/:id

### Input

body
: _Required_ **string**

#### Example

<%= json \
  :body => 'Nice change'
%>

### Response

<%= headers 200 %>
<%= json :pull_comment %>

")

(define-github-core :DELETE "/repos/:user/:repo/pulls/comments/:id" "
## Delete a comment

    DELETE /repos/:user/:repo/pulls/comments/:id

### Response

<%= headers 204 %>

")

; Custom Mime Types

; These are the support mime types for pull request comments. You can read
; more about the use of mimes types in the API [here](/v3/mimes/).

;     application/vnd.github-pullcomment.raw+json
;     application/vnd.github-pullcomment.text+json
;     application/vnd.github-pullcomment.html+json
;     application/vnd.github-pullcomment.full+json

(provide "github/api/v3/pulls/comments")

;;; End
