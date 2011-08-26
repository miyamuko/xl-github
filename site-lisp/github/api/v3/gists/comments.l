; -*- mode: lisp; package: github.v3 -*-

;;; github/api/v3/gists/comments.l
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
; title: Gist Comments API v3 | developer.github.com
; ---

; # Gist Comments API

; Gist Comments leverage [these](#custom-mime-types) custom mime types.
; You can read more about the use of mimes types in the API
; [here](/v3/mimes/).
(define-github-core :GET "/gists/:gist_id/comments" "
## List comments on a gist

    GET /gists/:gist_id/comments

### Response

<%= headers 200 %>
<%= json(:gist_comment) { |h| [h] } %>

")

(define-github-core :GET "/gists/comments/:id" "
## Get a single comment

    GET /gists/comments/:id

### Response

<%= headers 200 %>
<%= json :gist_comment %>

")

(define-github-core :POST "/gists/:gist_id/comments" "
## Create a comment

    POST /gists/:gist_id/comments

### Input

body
: _Required_ **string**

<%= json :body => 'Just commenting for the sake of commenting' %>

### Response

<%= headers 201,
      :Location => \"https://api.github.com/gists/comments/1\" %>
<%= json :gist_comment %>

")

(define-github-core :PATCH "/gists/comments/:id" "
## Edit a comment

    PATCH /gists/comments/:id

### Input

body
: _Required_ **string**

<%= json :body => 'Just commenting for the sake of commenting' %>

### Response

<%= headers 200 %>
<%= json :gist_comment %>

")

(define-github-core :DELETE "/gists/comments/:id" "
## Delete a comment

    DELETE /gists/comments/:id

### Response

<%= headers 204 %>

")

; Custom Mime Types

; These are the support mime types for gist comments. You can read more about the
; use of mimes types in the API [here](/v3/mimes/).

;     application/vnd.github-gistcomment.raw+json
;     application/vnd.github-gistcomment.text+json
;     application/vnd.github-gistcomment.html+json
;     application/vnd.github-gistcomment.full+json

(provide "github/api/v3/gists/comments")

;;; End
