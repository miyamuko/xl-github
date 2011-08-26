; -*- mode: lisp; package: github.v3 -*-

;;; github/api/v3/issues/comments.l
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
; title: Issue Comments API v3 | developer.github.com
; ---

; # Issue Comments API

; Issue Comments leverage [these](#custom-mime-types) custom mime types.
; You can read more about the use of mimes types in the API
; [here](/v3/mimes/).
(define-github-core :GET "/repos/:user/:repo/issues/:id/comments" "
## List comments on an issue

    GET /repos/:user/:repo/issues/:id/comments

### Response

<%= headers 200, :pagination => true %>
<%= json(:issue_comment) { |h| [h] } %>

")

(define-github-core :GET "/repos/:user/:repo/issues/comments/:id" "
## Get a single comment

    GET /repos/:user/:repo/issues/comments/:id

### Response

<%= headers 200 %>
<%= json :issue_comment %>

")

(define-github-core :POST "/repos/:user/:repo/issues/:id/comments" "
## Create a comment

    POST /repos/:user/:repo/issues/:id/comments

### Input

body
: _Required_ **string**

<%= json :body => \"a new comment\" %>

### Response

<%= headers 201,
      :Location =>
\"https://api.github.com/repos/user/repo/issues/comments/1\" %>
<%= json :issue_comment %>

")

(define-github-core :PATCH "/repos/:user/:repo/issues/comments/:id" "
## Edit a comment

    PATCH /repos/:user/:repo/issues/comments/:id

### Input

body
: _Required_ **string**

<%= json :body => \"String\" %>

### Response

<%= headers 200 %>
<%= json :issue_comment %>

")

(define-github-core :DELETE "/repos/:user/:repo/issues/comments/:id" "
## Delete a comment

    DELETE /repos/:user/:repo/issues/comments/:id

### Response

<%= headers 204 %>

")

; Custom Mime Types

; These are the support mime types for isissue comments. You can read more
; about the use of mimes types in the API [here](/v3/mimes/).

;     application/vnd.github-issuecomment.raw+json
;     application/vnd.github-issuecomment.text+json
;     application/vnd.github-issuecomment.html+json
;     application/vnd.github-issuecomment.full+json

(provide "github/api/v3/issues/comments")

;;; End
