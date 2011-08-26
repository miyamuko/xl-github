; -*- mode: lisp; package: github.v3 -*-

;;; github/api/v3/git/commits.l
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
; title: Git DB Commits API v3 | developer.github.com
; ---

; # Commits API
(define-github-core :GET "/repos/:user/:repo/git/commits/:sha" "
## Get a Commit

    GET /repos/:user/:repo/git/commits/:sha

### Response

<%= headers 200 %>
<%= json :commit %>

")

(define-github-core :POST "/repos/:user/:repo/git/commits" "
## Create a Commit

    POST /repos/:user/:repo/git/commits

### Parameters

message
: _String_ of the commit message

tree
: _String_ of the SHA of the tree object this commit points to

parents
: _Array_ of the SHAs of the commits that were the parents of this
commit.  If omitted or empty, the commit will be written as a root
commit.  For a single parent, an array of one SHA should be provided,
for a merge commit, an array of more than one should be provided.

### Optional Parameters

The `committer` section is optional and will be filled with the `author`
data if omitted. If the `author` section is omitted, it will be filled
in with the authenticated users information and the current date.


author.name
: _String_ of the name of the author of the commit

author.email
: _String_ of the email of the author of the commit

author.date
: _Timestamp_ of when this commit was authored

committer.name
: _String_ of the name of the committer of the commit

committer.email
: _String_ of the email of the committer of the commit

committer.date
: _Timestamp_ of when this commit was committed

### Example Input

<%= json \"message\"=> \"my commit message\", \
    \"author\"=> \
    {\"name\" => \"Scott Chacon\", \"email\" => \"schacon@gmail.com\", \
    \"date\" => \"2008-07-09T16:13:30+12:00\"}, \
    \"parents\"=>[\"7d1b31e74ee336d15cbd21741bc88a537ed063a0\"], \
    \"tree\"=>\"827efc6d56897b048c772eb4087f854f46256132\" %>

### Response

<%= headers 201,
      :Location => \"https://api.github.com/git/:user/:repo/commit/:sha\" %>
<%= json :new_commit %>

")


(provide "github/api/v3/git/commits")

;;; End
