; -*- mode: lisp; package: github.v3 -*-

;;; github/api/v3/issues/events.l
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
; title: Issue Events API v3 | developer.github.com
; ---

; # Issue Events API

; Records various events that occur around an Issue or Pull Request. This is
; useful both for display on issue/pull request information pages and also to
; determine who should be notified of comments.

; ### Attributes

; actor
; : Always the User that generated the event.

; commit_id
; : The String SHA of a commit that referenced this Issue

; event
; : Identifies the actual type of Event that occurred.

; ### Events

; closed
; : The issue was closed by the actor. When the commit_id is present, it
;   identifies the commit that closed the issue using "closes / fixes #NN"
;   syntax.

; reopened
; : The issue was reopened by the actor.

; subscribed
; : The actor subscribed to receive notifications for an issue.

; merged
; : The issue was merged by the actor. The `commit_id` attribute is the SHA1 of
;   the HEAD commit that was merged.

; referenced
; : The issue was referenced from a commit message. The `commit_id` attribute is
;   the commit SHA1 of where that happened.

; mentioned
; : The actor was @mentioned in an issue body.

; assigned
; : The issue was assigned to the actor.
(define-github-core :GET "/repos/:user/:repo/issues/:issue_id/events" "
## List events for an issue

    GET /repos/:user/:repo/issues/:issue_id/events

### Response

<%= headers 200, :pagination => true %>
<%= json(:issue_event) { |h| [h] } %>

")

(define-github-core :GET "/repos/:user/:repo/issues/events" "
## List events for a repository

    GET /repos/:user/:repo/issues/events

### Response

<%= headers 200, :pagination => true %>
<%= json(:issue_event) { |h| [h] } %>

")

(define-github-core :GET "/repos/:user/:repo/issues/events/:id" "
## Get a single event

    GET /repos/:user/:repo/issues/events/:id

### Response

<%= headers 200 %>
<%= json :issue_event %>

")


(provide "github/api/v3/issues/events")

;;; End
