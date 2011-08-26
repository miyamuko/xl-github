; -*- mode: lisp; package: github.v3 -*-

;;; github/api/v3/issues.l
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
; title: Issues API v3 | developer.github.com
; ---

; # Issues API

; Issues leverage [these](#custom-mime-types) custom mime types. You can
; read more about the use of mimes types in the API [here](/v3/mimes/).
(define-github-core :GET "/issues" "
## List your issues

    GET /issues

### Parameters

filter
: * `assigned`: Issues assigned to you (default)
  * `created`: Issues created by you
  * `mentioned`: Issues mentioning you
  * `subscribed`: Issues you're subscribed to updates for

state
: `open`, `closed`, default: `open`

labels
: _String_ list of comma separated Label names.  Example:
`bug,ui,@high`

sort
: `created`, `updated`, `comments`, default: `created`

direction
: `asc` or `desc`, default: `desc`.

since
: _Optional_ **string** of a timestamp in ISO 8601 format: YYYY-MM-DDTHH:MM:SSZ

### Response

<%= headers 200, :pagination => true %>
<%= json(:issue) { |h| [h] } %>

")

(define-github-core :GET "/repos/:user/:repo/issues" "
## List issues for a repository

    GET /repos/:user/:repo/issues

### Parameters

milestone
: * _Integer_ Milestone number
  * `none` for Issues with no Milestone.
  * `*` for Issues with any Milestone.

state
: `open`, `closed`, default: `open`

assignee
: * _String_ User login
  * `none` for Issues with no assigned User.
  * `*` for Issues with any assigned User.

mentioned
: _String_ User login.

labels
: _String_ list of comma separated Label names.  Example:
`bug,ui,@high`

sort
: `created`, `updated`, `comments`, default: `created`

direction
: `asc` or `desc`, default: `desc`.

since
: _Optional_ **string** of a timestamp in ISO 8601 format: YYYY-MM-DDTHH:MM:SSZ

### Response

<%= headers 200, :pagination => true %>
<%= json(:issue) { |h| [h] } %>

")

(define-github-core :GET "/repos/:user/:repo/issues/:id" "
## Get a single issue

    GET /repos/:user/:repo/issues/:id

### Response

<%= headers 200 %>
<%= json :issue %>

")

(define-github-core :POST "/repos/:user/:repo/issues" "
## Create an issue

    POST /repos/:user/:repo/issues

### Input

title
: _Required_ **string**

body
: _Optional_ **string**

assignee
: _Optional_ **string** - Login for the user that this issue should be
assigned to.

milestone
: _Optional_ **number** - Milestone to associate this issue with.

labels
: _Optional_ **array** of **strings** - Labels to associate with this
issue.

<%= json \
  :title     => \"Found a bug\",
  :body      => \"I'm having a problem with this.\",
  :assignee  => \"octocat\",
  :milestone => 1,
  :labels    => %w(Label1 Label2)
%>

### Response

<%= headers 201,
      :Location =>
'https://api.github.com/repos/user/repo/issues/1' %>
<%= json :issue %>

")

(define-github-core :PATCH "/repos/:user/:repo/issues/:id" "
## Edit an issue

    PATCH /repos/:user/:repo/issues/:id

### Input

title
: _Required_ **string**

body
: _Optional_ **string**

assignee
: _Optional_ **string** - Login for the user that this issue should be
assigned to.

state
: _Optional_ **string** - State of the issue: `open` or `closed`.

milestone
: _Optional_ **number** - Milestone to associate this issue with.

labels
: _Optional_ **array** of **strings** - Labels to associate with this
issue. Pass one or more Labels to _replace_ the set of Labels on this
Issue. Send an empty array (`[]`) to clear all Labels from the Issue.

<%= json \
  :title     => \"Found a bug\",
  :body      => \"I'm having a problem with this.\",
  :assignee  => \"octocat\",
  :milestone => 1,
  :state     => \"open\",
  :labels    => %w(Label1 Label2)
%>

### Response

<%= headers 200 %>
<%= json :issue %>

")

; Custom Mime Types

; These are the support mime types for issues. You can read more about the
; use of mimes types in the API [here](/v3/mimes/).

;     application/vnd.github-issue.raw+json
;     application/vnd.github-issue.text+json
;     application/vnd.github-issue.html+json
;     application/vnd.github-issue.full+json

(provide "github/api/v3/issues")

;;; End
