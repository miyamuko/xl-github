; -*- mode: lisp; package: github.v3 -*-

;;; github/api/v3/issues/labels.l
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
; title: Issue Labels API v3 | developer.github.com
; ---

; # Labels API
(define-github-core :GET "/repos/:user/:repo/labels" "
## List all labels for this repository

    GET /repos/:user/:repo/labels

### Response

<%= headers 200 %>
<%= json(:label) { |h| [h] } %>

")

(define-github-core :GET "/repos/:user/:repo/labels/:id" "
## Get a single label

    GET /repos/:user/:repo/labels/:id

### Response

<%= headers 200 %>
<%= json :label %>

")

(define-github-core :POST "/repos/:user/:repo/labels" "
## Create a label

    POST /repos/:user/:repo/labels

### Input

name
: _Required_ **string**

color
: _Required_ **string** - 6 character hex code, without a leading `#`.

<%= json :name => \"API\", :color => \"FFFFFF\" %>

### Response

<%= headers 201,
      :Location =>
\"https://api.github.com/repos/user/repo/labels/foo\" %>
<%= json :label %>

")

(define-github-core :PATCH "/repos/:user/:repo/labels/:id" "
## Update a label

    PATCH /repos/:user/:repo/labels/:id

### Input

name
: _Required_ **string**

color
: _Required_ **string** - 6 character hex code, without a leading `#`.

<%= json :name => \"API\", :color => \"FFFFFF\" %>

### Response

<%= headers 200 %>
<%= json :label %>

")

(define-github-core :DELETE "/repos/:user/:repo/labels/:id" "
## Delete a label

    DELETE /repos/:user/:repo/labels/:id

### Response

<%= headers 204 %>

")

(define-github-core :GET "/repos/:user/:repo/issues/:id/labels" "
## List labels on an issue

    GET /repos/:user/:repo/issues/:id/labels

### Response

<%= headers 200 %>
<%= json(:label) { |h| [h] } %>

")

(define-github-core :POST "/repos/:user/:repo/issues/:id/labels" "
## Add labels to an issue

    POST /repos/:user/:repo/issues/:id/labels

### Input

<%= json({:array => %w(Label1 Label2)}) { |h| h['array'] } %>

### Response

<%= headers 200 %>
<%= json(:label) { |h| [h] } %>

")

(define-github-core :DELETE "/repos/:user/:repo/issues/:id/labels/:id" "
## Remove a label from an issue

    DELETE /repos/:user/:repo/issues/:id/labels/:id

### Response

<%= headers 200 %>
<%= json(:label) { |h| [h] } %>

")

(define-github-core :PUT "/repos/:user/:repo/issues/:id/labels" "
## Replace all labels for an issue

    PUT /repos/:user/:repo/issues/:id/labels

### Input

<%= json(:array => %w(Label1 Label2)) { |h| h['array'] } %>

Sending an empty array (`[]`) will remove all Labels from the Issue.

### Response

<%= headers 200 %>
<%= json(:label) { |h| [h] } %>

")

(define-github-core :DELETE "/repos/:user/:repo/issues/:id/labels" "
## Remove all labels from an issue

    DELETE /repos/:user/:repo/issues/:id/labels

### Response

<%= headers 204 %>

")

(define-github-core :GET "/repos/:user/:repo/milestones/:id/labels" "
## Get labels for every issue in a milestone

    GET /repos/:user/:repo/milestones/:id/labels

### Response

<%= headers 200 %>
<%= json(:label) { |h| [h] } %>
")


(provide "github/api/v3/issues/labels")

;;; End
