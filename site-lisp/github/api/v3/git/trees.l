; -*- mode: lisp; package: github.v3 -*-

;;; github/api/v3/git/trees.l
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
; title: Git DB Trees API v3 | developer.github.com
; ---

; # Trees API
(define-github-core :GET "/repos/:user/:repo/git/trees/:sha" "
## Get a Tree

    GET /repos/:user/:repo/git/trees/:sha

### Response

<%= headers 200 %>
<%= json :tree %>

")

(define-github-core :GET "/repos/:user/:repo/git/trees/:sha?recursive=1" "
## Get a Tree Recursively

    GET /repos/:user/:repo/git/trees/:sha?recursive=1

### Response

<%= headers 200 %>
<%= json :tree_extra %>

")

(define-github-core :POST "/repos/:user/:repo/git/trees" "
## Create a Tree

The tree creation API will take nested entries as well. If both a
tree and a nested path modifying that tree are specified, it will
overwrite the contents of that tree with the new path contents and write
a new tree out.

    POST /repos/:user/:repo/git/trees

### Parameters

base_tree
: optional _String_ of the SHA1 of the tree you want to update with new data

tree
: _Array_ of _Hash_ objects (of `path`, `mode`, `type` and `sha`) specifying a tree structure

tree.path
: _String_ of the file referenced in the tree

tree.mode
: _String_ of the file mode - one of `100644` for file (blob), `100755` for executable (blob), `040000` for subdirectory (tree), `160000` for submodule (commit) or `120000` for a blob that specifies the path of a symlink

tree.type
: _String_ of `blob`, `tree`, `commit`

tree.sha
: _String_ of SHA1 checksum ID of the object in the tree

tree.content
: _String_ of content you want this file to have - GitHub will write this blob out and use that SHA for this entry.  Use either this or `tree.sha`

### Input

<%= json \"tree\"=> \
  [{\"path\"=>\"file.rb\", \
    \"mode\"=>\"100644\", \
    \"type\"=>\"blob\", \
    \"sha\"=>\"44b4fc6d56897b048c772eb4087f854f46256132\"}] %>

### Response

<%= headers 201,
      :Location => \"https://api.github.com/repos/:user/:repo/git/trees/:sha\" %>
<%= json :tree_new %>

")


(provide "github/api/v3/git/trees")

;;; End
