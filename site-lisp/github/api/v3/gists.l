; -*- mode: lisp; package: github.v3 -*-

;;; github/api/v3/gists.l
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
; title: Gists API v3 | developer.github.com
; ---

; # Gists API
(define-github-core :GET "/users/:user/gists" "
## List gists

List a user's gists:

    GET /users/:user/gists

List the authenticated user's gists or if called anonymously, this will
returns all public gists:

    GET /gists

List all public gists:

    GET /gists/public

List the authenticated user's starred gists:

    GET /gists/starred

### Response

<%= headers 200, :pagination => true %>
<%= json(:gist) { |h| [h] } %>

")

(define-github-core :GET "/gists" "
## List gists

List a user's gists:

    GET /users/:user/gists

List the authenticated user's gists or if called anonymously, this will
returns all public gists:

    GET /gists

List all public gists:

    GET /gists/public

List the authenticated user's starred gists:

    GET /gists/starred

### Response

<%= headers 200, :pagination => true %>
<%= json(:gist) { |h| [h] } %>

")

(define-github-core :GET "/gists/public" "
## List gists

List a user's gists:

    GET /users/:user/gists

List the authenticated user's gists or if called anonymously, this will
returns all public gists:

    GET /gists

List all public gists:

    GET /gists/public

List the authenticated user's starred gists:

    GET /gists/starred

### Response

<%= headers 200, :pagination => true %>
<%= json(:gist) { |h| [h] } %>

")

(define-github-core :GET "/gists/starred" "
## List gists

List a user's gists:

    GET /users/:user/gists

List the authenticated user's gists or if called anonymously, this will
returns all public gists:

    GET /gists

List all public gists:

    GET /gists/public

List the authenticated user's starred gists:

    GET /gists/starred

### Response

<%= headers 200, :pagination => true %>
<%= json(:gist) { |h| [h] } %>

")

(define-github-core :GET "/gists/:id" "
## Get a single gist

    GET /gists/:id

### Response

<%= headers 200 %>
<%= json :full_gist %>

")

(define-github-core :POST "/gists" "
## Create a gist

    POST /gists

### Input

description
: _Optional_ **string**

public
: _Required_ **boolean**

files
: _Required_ **hash** - Files that make up this gist. The key of which
should be a _required_ **string** filename and the value another
_required_ **hash** with parameters:

  content
  : _Required_ **string** - File contents.

<%= json \
  :description => \"the description for this gist\",
  :public      => true,
  :files       => {
    \"file1.txt\" => {\"content\" => \"String file contents\"}
  }
%>

### Response

<%= headers 201, :Location => \"https://api.github.com/gists/1\" %>
<%= json :full_gist %>

")

(define-github-core :PATCH "/gists/:id" "
## Edit a gist

    PATCH /gists/:id

### Input

description
: _Optional_ **string**

files
: _Optional_ **hash** - Files that make up this gist. The key of which
should be an _optional_ **string** filename and the value another
_optional_ **hash** with parameters:

  content
  : _Optional_ **string** - Updated file contents.

  filename
  : _Optional_ **string** - New name for this file.

NOTE: All files from the previous version of the gist are carried over by
default if not included in the hash. Deletes can be performed by
including the filename with a null hash.

<%= json \
  :description => \"the description for this gist\",
  :files => {
    \"file1.txt\"    => {\"content\"  => \"updated file contents\"},
    \"old_name.txt\" => {\"filename\" => \"new_name.txt\", \"content\" => \"modified contents\"},
    \"new_file.txt\" => {\"content\"  => \"a new file\"},
    \"delete_this_file.txt\" => nil,
  } %>

### Response

<%= headers 200 %>
<%= json :full_gist %>

")

(define-github-core :PUT "/gists/:id/star" "
## Star a gist

    PUT /gists/:id/star

### Response

<%= headers 204 %>

")

(define-github-core :DELETE "/gists/:id/star" "
## Unstar a gist

    DELETE /gists/:id/star

### Response

<%= headers 204 %>

")

(define-github-core :GET "/gists/:id/star" "
## Check if a gist is starred

    GET /gists/:id/star

### Response if gist is starred

<%= headers 204 %>

### Response if gist is not starred

<%= headers 404 %>

")

(define-github-core :POST "/gists/:id/fork" "
## Fork a gist

    POST /gists/:id/fork

### Response

<%= headers 201, :Location => \"https://api.github.com/gists/2\" %>
<%= json(:gist) %>

")

(define-github-core :DELETE "/gists/:id" "
## Delete a gist

    DELETE /gists/:id

### Response

<%= headers 204 %>
")


(provide "github/api/v3/gists")

;;; End
