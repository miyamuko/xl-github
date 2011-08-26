; -*- mode: lisp; package: user -*-

;;; github/api/v3.l
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

(in-package :user)

(require "github/api/v3/gists")
(require "github/api/v3/gists/comments")
(require "github/api/v3/git")
(require "github/api/v3/git/blobs")
(require "github/api/v3/git/commits")
(require "github/api/v3/git/import")
(require "github/api/v3/git/refs")
(require "github/api/v3/git/tags")
(require "github/api/v3/git/trees")
(require "github/api/v3/issues")
(require "github/api/v3/issues/comments")
(require "github/api/v3/issues/events")
(require "github/api/v3/issues/labels")
(require "github/api/v3/issues/milestones")
(require "github/api/v3/orgs")
(require "github/api/v3/orgs/members")
(require "github/api/v3/orgs/teams")
(require "github/api/v3/pulls")
(require "github/api/v3/pulls/comments")
(require "github/api/v3/repos")
(require "github/api/v3/repos/collaborators")
(require "github/api/v3/repos/commits")
(require "github/api/v3/repos/downloads")
(require "github/api/v3/repos/forks")
(require "github/api/v3/repos/keys")
(require "github/api/v3/repos/watching")
(require "github/api/v3/users")
(require "github/api/v3/users/emails")
(require "github/api/v3/users/followers")
(require "github/api/v3/users/keys")

(provide "github/api/v3")

;;; End
