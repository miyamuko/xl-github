; -*- mode: lisp; package: github.v3 -*-

;;; github/api/v3/git/tags.l
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
; title: Git DB Tags API v3 | developer.github.com
; ---

; # Tags API

; This tags api only deals with tag objects - so only annotated tags, not
; lightweight tags.
(define-github-core :GET "/repos/:user/:repo/git/tags/:sha" "
## Get a Tag

    GET /repos/:user/:repo/git/tags/:sha

### Response

<%= headers 200 %>
<%= json :gittag %>

")

(define-github-core :POST "/repos/:user/:repo/git/tags" "
## Create a Tag Object

Note that creating a tag object does not create the reference that
makes a tag in Git.  If you want to create an annotated tag in Git,
you have to do this call to create the tag object, and then create
the `refs/tags/[tag]` reference.  If you want to create a lightweight
tag, you simply have to create the reference - this call would be 
unnecessary.

    POST /repos/:user/:repo/git/tags

### Parameters

tag
: _String_ of the tag

message
: _String_ of the tag message

object
: _String_ of the SHA of the git object this is tagging

type
: _String_ of the type of the object we're tagging. Normally this is a
`commit` but it can also be a `tree` or a `blob`.

tagger.name
: _String_ of the name of the author of the tag

tagger.email
: _String_ of the email of the author of the tag

tagger.date
: _Timestamp_ of when this object was tagged

### Response

<%= headers 201,
      :Location => \"https://api.github.com/repos/:user/:repo/git/tags/:sha\" %>
<%= json :gittag %>

")


(provide "github/api/v3/git/tags")

;;; End
