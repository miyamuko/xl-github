; -*- mode: lisp; package: github.v3 -*-

;;; github/api/v3/git/refs.l
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
; title: Git DB Refs API v3 | developer.github.com
; ---

; # References API
(define-github-core :GET "/repos/:user/:repo/git/refs/:ref" "
## Get a Reference

    GET /repos/:user/:repo/git/refs/:ref

The `ref` in the URL must be formatted as `heads/branch`, not just `branch`. For example, the call to get the data for a branch named `sc/featureA` would be:

    GET /repos/:user/:repo/git/refs/heads/sc/featureA

### Response

<%= headers 200 %>
<%= json :ref %>

")

(define-github-core :GET "/repos/:user/:repo/git/refs/heads/sc/featureA" "
## Get a Reference

    GET /repos/:user/:repo/git/refs/:ref

The `ref` in the URL must be formatted as `heads/branch`, not just `branch`. For example, the call to get the data for a branch named `sc/featureA` would be:

    GET /repos/:user/:repo/git/refs/heads/sc/featureA

### Response

<%= headers 200 %>
<%= json :ref %>

")

(define-github-core :GET "/repos/:user/:repo/git/refs" "
## Get all References

    GET /repos/:user/:repo/git/refs

This will return an array of all the references on the system, including
things like notes and stashes if they exist on the server.  Anything in
the namespace, not just `heads` and `tags`, though that would be the
most common.

You can also request a sub-namespace. For example, to get all the tag
references, you can call:

    GET /repos/:user/:repo/git/refs/tags

For a full refs listing, you'll get something that looks like:

<%= headers 200 %>
<%= json :refs %>


")

(define-github-core :GET "/repos/:user/:repo/git/refs/tags" "
## Get all References

    GET /repos/:user/:repo/git/refs

This will return an array of all the references on the system, including
things like notes and stashes if they exist on the server.  Anything in
the namespace, not just `heads` and `tags`, though that would be the
most common.

You can also request a sub-namespace. For example, to get all the tag
references, you can call:

    GET /repos/:user/:repo/git/refs/tags

For a full refs listing, you'll get something that looks like:

<%= headers 200 %>
<%= json :refs %>


")

(define-github-core :POST "/repos/:user/:repo/git/refs" "
## Create a Reference

    POST /repos/:user/:repo/git/refs

### Paramaters

ref
: _String_ of the name of the fully qualified reference (ie: `refs/heads/master`).
  If it doesn't start with 'refs' and have at least two slashes, it will be rejected.

sha
: _String_ of the SHA1 value to set this reference to

### Input

<%= json \"ref\"=>\"refs/heads/master\",\
         \"sha\"=>\"827efc6d56897b048c772eb4087f854f46256132\" %>

")

(define-github-core :PATCH "/repos/:user/:repo/git/refs/:ref" "
## Update a Reference

    PATCH /repos/:user/:repo/git/refs/:ref

### Paramaters

sha
: _String_ of the SHA1 value to set this reference to

force
: _Boolean_ indicating whether to force the update or to make sure the
update is a fast-forward update. The default is `false`, so leaving this
out or setting it to `false` will make sure you're not overwriting work.

### Input

<%= json \"sha\"=>\"aa218f56b14c9653891f9e74264a383fa43fefbd\",\
         \"force\"=>true %>

### Response

<%= headers 200, \
      :Location => \"https://api.github.com/git/:user/:repo/commit/:sha\" %>
<%= json :ref %>


")


(provide "github/api/v3/git/refs")

;;; End
