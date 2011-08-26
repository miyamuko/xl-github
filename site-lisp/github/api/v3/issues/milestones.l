; -*- mode: lisp; package: github.v3 -*-

;;; github/api/v3/issues/milestones.l
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
; title: Issue Milestones API v3 | developer.github.com
; ---

; # Milestones API
(define-github-core :GET "/repos/:user/:repo/milestones" "
## List milestones for a repository

    GET /repos/:user/:repo/milestones

state
: `open`, `closed`, default: `open`

sort
: `due_date`, `completeness`, default: `due_date`

direction
: `asc` or `desc`, default: `desc`.

### Response

<%= headers 200, :pagination => true %>
<%= json(:milestone) { |h| [h] } %>

")

(define-github-core :GET "/repos/:user/:repo/milestones/:id" "
## Get a single milestone

    GET /repos/:user/:repo/milestones/:id

### Response

<%= headers 200 %>
<%= json :milestone %>

")

(define-github-core :POST "/repos/:user/:repo/milestones" "
## Create a milestone

    POST /repos/:user/:repo/milestones

### Input

title
: _Required_ **string**

state
: _Optional_ **string** - `open` or `closed`. Default is `open`.

description
: _Optional_ **string**

due\_on
: _Optional_ **string** - ISO 8601 time.

<%= json \
  :title => \"String\",
  :state => \"open or closed\",
  :description => \"String\",
  :due_on => \"Time\"
%>

### Response

<%= headers 201,
      :Location =>
\"https://api.github.com/repos/user/repo/milestones/1\" %>
<%= json :milestone %>

")

(define-github-core :PATCH "/repos/:user/:repo/milestones/:id" "
## Update a milestone

    PATCH /repos/:user/:repo/milestones/:id

### Input

title
: _Required_ **string**

state
: _Optional_ **string** - `open` or `closed`. Default is `open`.

description
: _Optional_ **string**

due\_on
: _Optional_ **string** - ISO 8601 time.

<%= json \
  :title => \"String\",
  :state => \"open or closed\",
  :description => \"String\",
  :due_on => \"Time\"
%>

### Response

<%= headers 200 %>
<%= json :milestone %>

")

(define-github-core :DELETE "/repos/:user/:repo/milestones/:id" "
## Delete a milestone

    DELETE /repos/:user/:repo/milestones/:id

### Response

<%= headers 204 %>

")


(provide "github/api/v3/issues/milestones")

;;; End
