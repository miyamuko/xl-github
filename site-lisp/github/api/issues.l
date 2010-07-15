; -*- mode: lisp; package: github -*-

;;; github/api/issues.l
;;
;; Copyright (c) 2010 MIYAMUKO Katsuyuki.
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
  (mc-require "github/api/base")
  )

(in-package :github)


;; ## Issues API ##

; The API for GitHub Issues.

;;; ### Search Issues ###

(defun github-issues-search (user repo state search-term &key nomsg)
  (github-get "issues/search/:user/:repo/:state/:search_term"
              :uri-params (list user repo state search-term)
              :nomsg nomsg))

; Where 'state' is either 'open' or 'closed'.

; For example, to search for 'test' in the open issues for defunkt/github-issues repo, you can do this:

;     $ curl http://github.com/api/v2/json/issues/search/defunkt/github-issues/open/test
;     {
;       "issues": [
;         {
;           "user": "kfl",
;           "gravatar_id": "ad670e0aee0491aaa0a2d201486064b2",
;           "updated_at": "2009\/04\/20 03:34:48 -0700",
;           "votes": 3,
;           "number": 102,
;           "position": 1.0,
;           "title": "Pressing question-mark does not show help",
;           "body": "Pressing the '?'-key does not open the help lightbox.\r\n\r\nHowever, at least the 'j', 'k', and 'c' works (the only ones I've tested).\r\n\r\n* **OS:** Linux, ubuntu 8.04.1\r\n* **Browser:** Firefox 3.08",
;           "state": "open",
;           "created_at": "2009\/04\/17 12:57:52 -0700"
;         }
;       ]
;     }


;;; ### List a Project's Issues ###

; To see a list of issues for a project,

(defun github-issues-list (user repo state &key nomsg)
  (github-get "issues/list/:user/:repo/:state"
              :uri-params (list user repo state)
              :nomsg nomsg))

; where :state is either 'open' or 'closed'.  You can also search with a label:

(defun github-issues-list-label (user repo label &key nomsg)
  (github-get "issues/list/:user/:repo/label/:label"
              :uri-params (list user repo label)
              :nomsg nomsg))

; For example, to see all the open issues I have on the schacon/simplegit project, we can run

;     $ curl http://github.com/api/v2/yaml/issues/list/schacon/simplegit/open
;     ---
;     issues:
;     - number: 1
;       votes: 0
;       created_at: 2009-04-17 14:55:33 -07:00
;       body: my sweet, sweet issue
;       title: new issue
;       updated_at: 2009-04-17 14:55:33 -07:00
;       user: schacon
;       gravatar_id: 9375a9529679f1b42b567a640d775e7d
;       position: 0.0
;       state: open
;     - number: 2
;       votes: 0
;       created_at: 2009-04-17 15:16:47 -07:00
;       body: the body of a second issue
;       title: another issue
;       updated_at: 2009-04-17 15:16:47 -07:00
;       user: schacon
;       gravatar_id: 9375a9529679f1b42b567a640d775e7d
;       position: 1.0
;       state: open

; Here's a sample query of all issues labeled "2.0" in defunkt/resque:

;     $ curl http://github.com/api/v2/yaml/issues/list/defunkt/resque/label/2.0
;     ---
;     issues:
;       - gravatar_id: b8dbb1987e8e5318584865f880036796
;         position: 4.0
;         number: 5
;         votes: 1
;         created_at: 2009-11-03 11:58:19 -08:00
;         comments: 2
;         body: You know you want it.
;         title: ERB => Mustache
;         updated_at: 2010-05-13 13:57:53 -07:00
;         closed_at:
;         user: defunkt
;         labels:
;         - "2.0"
;         - feature
;         state: open

;;; ### View an Issue ###

; To get data on an individual issue by number, run

(defun github-issues-show (user repo number &key nomsg)
  (github-get "issues/show/:user/:repo/:number"
              :uri-params (list user repo number)
              :nomsg nomsg))

; So to get all the data for a issue #1 in our repo, we can run something like this:

;     $ curl http://github.com/api/v2/yaml/issues/show/schacon/simplegit/1
;     ---
;     issue:
;       number: 1
;       position: 0.0
;       votes: 0
;       created_at: 2009-04-17 14:55:33 -07:00
;       body: my sweet, sweet issue
;       title: new issue
;       updated_at: 2009-04-17 14:55:33 -07:00
;       user: schacon
;       gravatar_id: 9375a9529679f1b42b567a640d775e7d
;       comments: 2
;       state: open


;;; ### List an Issue's Comments ###

; To get a list of comments made on an issue, run

(defun github-issues-comments (user repo number &key nomsg)
  (github-get "issues/comments/:user/:repo/:number"
              :uri-params (list user repo number)
              :nomsg nomsg))

; So to get all the comments for a issue #1 in our repo, we can run something like this:

;     $ curl http://github.com/api/v2/yaml/issues/comments/schacon/simplegit/open
;     ---
;     comments:
;     - created_at: 2010-02-08 12:54:54 -08:00
;       body: this is a really great idea
;       updated_at: 2010-02-08 12:54:54 -08:00
;       id: 1
;       user: defunkt
;       gravatar_id: b8dbb1987e8e5318584865f880036796
;     - created_at: 2010-02-08 12:55:05 -08:00
;       body: is it?
;       updated_at: 2010-02-08 12:55:05 -08:00
;       id: 2
;       user: schacon
;       gravatar_id: 9375a9529679f1b42b567a640d775e7d


;;; ### Open and Close Issues ###

; To open a new issue on a project, make a authorized POST to

(defun github-issues-open (user repo &key nomsg)
  (github-get "issues/open/:user/:repo"
              :uri-params (list user repo)
              :nomsg nomsg))

; Where you can provide POST variables:

;     title
;     body

; It will return the data for the newly created ticket if it is successful.  You need to provide your username and token so the system knows who you are and can assign you as the opener of the issue.

; For example, I could open a new issue on my simplegit project like this:

;     $ curl -F 'login=schacon' -F 'token=XXX' -F 'title=new' -F 'body=my ticket' \
;       http://github.com/api/v2/yaml/issues/open/schacon/simplegit
;     ---
;     issue:
;       user: schacon
;       gravatar_id: 9375a9529679f1b42b567a640d775e7d
;       body: my ticket
;       title: new
;       number: 1
;       votes: 0
;       state: open

; To close or reopen an issue, you just need to supply the issue number

(defun github-issues-close (user repo number &key nomsg)
  (github-get "issues/close/:user/:repo/:number"
              :uri-params (list user repo number)
              :nomsg nomsg))

(defun github-issues-reopen (user repo number &key nomsg)
  (github-get "issues/reopen/:user/:repo/:number"
              :uri-params (list user repo number)
              :nomsg nomsg))

; You need to be logged in via token as well.  Here is how I would close the ticket I opened earlier:

;     $ curl -F 'login=schacon' -F 'token=XXX' \
;       http://github.com/api/v2/yaml/issues/close/schacon/simplegit/1
;     ---
;     issue:
;       user: schacon
;       gravatar_id: 9375a9529679f1b42b567a640d775e7d
;       body:
;       title: new
;       number: 1
;       votes: 0
;       state: closed

;;; ### Edit Existing Issues ###

; For the final three calls (edit, label add and label delete) you have to be authorized a collaborator on the project.

; To edit an existing issue, you can POST to

(defun github-issues-edit (user repo number &key nomsg)
  (github-get "issues/edit/:user/:repo/:number"
              :uri-params (list user repo number)
              :nomsg nomsg))

; Where you can provide POST variables:

;     title
;     body

; This will overwrite the title or body of the issue, if you are authorized member of the project.

;;; ### Listing Labels ###

; You can list available labels for a projects issues with

(defun github-issues-labels (user repo &key nomsg)
  (github-get "issues/labels/:user/:repo"
              :uri-params (list user repo)
              :nomsg nomsg))

; For example,

;     $ curl -F 'login=schacon' -F 'token=XXX' https://github.com/api/v2/yaml/issues/labels/schacon/simplegit
;     ---
;     labels:
;     - label1
;     - label2

;;; ### Add and Remove Labels ###

; To add a label, run

(defun github-issues-label-add (user repo label number &key nomsg)
  (github-get "issues/label/add/:user/:repo/:label/:number"
              :uri-params (list user repo label number)
              :nomsg nomsg))

; This will return a list of the labels currently on that issue, your new one included. If the label is not yet in the system, it will be created.

; Here is how I would add the label 'testing' to my first ticket in my simplegit project:

;     $ curl -F 'login=schacon' -F 'token=XXX' https://github.com/api/v2/yaml/issues/label/add/schacon/simplegit/testing/1
;     ---
;     labels:
;     - testing
;     - test_label


; To remove a label, run:

(defun github-issues-label-remove (user repo label number &key nomsg)
  (github-get "issues/label/remove/:user/:repo/:label/:number"
              :uri-params (list user repo label number)
              :nomsg nomsg))

; Again, it will return a list of the labels currently on the issue.

; You can also add and remove labels generally by leaving off the Issue number.
; That will add a label to the system but not attach it to an issue, or remove
; an issue from all labels.

;;; ### Comment on Issues ###

; You can comment on issues at

(defun github-issues-comment (user repo id &key nomsg)
  (github-get "issues/comment/:user/:repo/:id"
              :uri-params (list user repo id)
              :nomsg nomsg))

; Simply send it a 'comment' POST variable with the comment you'd like to make.  It will attribute the comment to the user that is authenticated.  Here is an example:

;     $ curl -F 'login=schacon' -F 'token=XXX' -F 'comment=this is amazing' \
;     https://github.com/api/v2/json/issues/comment/defunkt/dunder-mifflin/1
;     {"comment": {"gravatar_id": "9375a9529679f1b42b567a640d775e7d",
;     "user": "schacon", "body": "this is amazing", id: 17,
;     created_at: TIMESTAMP, updated_at: TIMESTAMP}


(provide "github/api/issues")

;;; End
