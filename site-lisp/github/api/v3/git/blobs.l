; -*- mode: lisp; package: github.v3 -*-

;;; github/api/v3/git/blobs.l
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
; title: Git DB Blobs API v3 | developer.github.com
; ---

; # Blobs API

; Since blobs can be any arbitrary binary data, the input and responses
; for the blob api takes an encoding parameter that can be either `utf-8`
; or `base64`.  If your data cannot be losslessly sent as a UTF-8 string,
; you can base64 encode it.

; Blobs leverage [these](#custom-mime-types) custom mime types. You can
; read more about the use of mimes types in the API [here](/v3/mimes/).
(define-github-core :GET "/repos/:user/:repo/git/blobs/:sha" "
## Get a Blob

    GET /repos/:user/:repo/git/blobs/:sha

### Response

<%= headers 200 %>
<%= json :content => \"Content of the blob\", :encoding => \"utf-8\" %>

")

(define-github-core :POST "/repos/:user/:repo/git/blobs" "
## Create a Blob

    POST /repos/:user/:repo/git/blobs

### Input

<%= json :content => \"Content of the blob\", :encoding => \"utf-8\" %>

### Response

<%= headers 201,
      :Location => \"https://api.github.com/git/:user/:repo/blob/:sha\" %>
<%= json :sha => \"3a0f86fb8db8eea7ccbb9a95f325ddbedfb25e15\" %>

")

; Custom Mime Types

; These are the support mime types for blobs. You can read more about the
; use of mimes types in the API [here](/v3/mimes/).

;     application/json
;     application/vnd.github-blob.raw

(provide "github/api/v3/git/blobs")

;;; End
