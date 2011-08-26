; -*- mode: lisp; package: github.v3 -*-

;;; github/api/v3/users/emails.l
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
; title: User Emails API v3 | developer.github.com
; ---

; # User Emails API

; Mangement of email addresses via the API requires that you are
; authenticated.
(define-github-core :GET "/user/emails" "
## List email addresses for a user

    GET /user/emails

### Response

<%= headers 200 %>
<%= json [\"octocat@github.com\", \"support@github.com\"] %>

")

(define-github-core :POST "/user/emails" "
## Add email address(es)

    POST /user/emails

### Input

You can post a single email address or an array of addresses:

<%= json [\"octocat@github.com\", \"support@github.com\"] %>

### Response

<%= headers 201 %>
<%= json [\"octocat@github.com\", \"support@github.com\"] %>

")

(define-github-core :DELETE "/user/emails" "
## Delete email address(es)

    DELETE /user/emails

### Input

You can include a single email address or an array of addresses:

<%= json [\"octocat@github.com\", \"support@github.com\"] %>

### Response

<%= headers 204 %>

")


(provide "github/api/v3/users/emails")

;;; End
