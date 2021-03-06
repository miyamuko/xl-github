; -*- mode: lisp; package: github; encoding: shift_jis -*-

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
  (require "github/api/base")
  )

(in-package :github)

(export '(search-issues
          list-issues
          show-issue
          list-issue-comments
          open-issue
          close-issue
          reopen-issue
          update-issue
          list-issue-labels
          add-issue-label
          delete-issue-label
          add-issue-comment
          ))

;;; ## Issues API ##

; The API for GitHub Issues.

(defun validate-state (state)
  (unless (member (format nil "~A" state) '("open" "closed") :test #'string=)
    (plain-error "Invalid state: `~S' (valid values are :open or :closed)" state)))


;;; ### Search Issues ###

(defun search-issues (owner/repo state query &key callback nomsg)
  (multiple-value-bind (user repo)
      (coerce-owner-and-repo owner/repo)
    (validate-state state)
    (check-type query string)
    (github-get "issues/search/:user/:repo/:state/:query"
                :uri-params (list user repo state query)
                :return-type '(:root "issues" :list t :object t :type issue)
                :callback callback :nomsg nomsg)))

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

(defun list-issues (owner/repo state-or-label &key label callback nomsg)
  (funcall (if label
               'list-issues-by-label
             'list-issues-by-state)
           owner/repo state-or-label :callback callback :nomsg nomsg))

(defun list-issues-by-state (owner/repo state &key callback nomsg)
  (multiple-value-bind (user repo)
      (coerce-owner-and-repo owner/repo)
    (validate-state state)
    (github-get "issues/list/:user/:repo/:state"
                :uri-params (list user repo state)
                :return-type '(:root "issues" :list t :object t :type issue)
                :callback callback :nomsg nomsg)))

; where :state is either 'open' or 'closed'.  You can also search with a label:

(defun list-issues-by-label (owner/repo label &key callback nomsg)
  (multiple-value-bind (user repo)
      (coerce-owner-and-repo owner/repo)
    (check-type label string)
    (github-get "issues/list/:user/:repo/label/:label"
                :uri-params (list user repo label)
                :return-type '(:root "issues" :list t :object t :type issue)
                :callback callback :nomsg nomsg)))

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

(defun show-issue (owner/repo issue &key callback nomsg)
  (multiple-value-bind (user repo)
      (coerce-owner-and-repo owner/repo)
    (setf issue (coerce-issue-number issue))
    (github-get "issues/show/:user/:repo/:issue"
                :uri-params (list user repo issue)
                :return-type '(:root "issue" :list nil :object t :type issue)
                :callback callback :nomsg nomsg)))

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

(defun list-issue-comments (owner/repo issue &key callback nomsg)
  (multiple-value-bind (user repo)
      (coerce-owner-and-repo owner/repo)
    (setf issue (coerce-issue-number issue))
    (github-get "issues/comments/:user/:repo/:issue"
                :uri-params (list user repo issue)
                :return-type '(:root "comments" :list t :object t :type issue-comment)
                :callback callback :nomsg nomsg)))

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

(defun open-issue (owner/repo title body &key callback nomsg)
  (multiple-value-bind (user repo)
      (coerce-owner-and-repo owner/repo)
    (check-type title string)
    (check-type body string)
    (form-value-bind (data)
        (progn
          (form "title" title t)
          (form "body" body t))
      (github-post "issues/open/:user/:repo"
                   :uri-params (list user repo)
                   :return-type '(:root "issue" :list nil :object t :type issue)
                   :data data
                   :callback callback :nomsg nomsg))))

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

(defun close-issue (owner/repo issue &key callback nomsg)
  (multiple-value-bind (user repo)
      (coerce-owner-and-repo owner/repo)
    (setf issue (coerce-issue-number issue))
    (github-get "issues/close/:user/:repo/:issue"
                :uri-params (list user repo issue)
                :return-type '(:root "issue" :list nil :object t :type issue)
                :send-login-token t
                :callback callback :nomsg nomsg)))

(defun reopen-issue (owner/repo issue &key callback nomsg)
  (multiple-value-bind (user repo)
      (coerce-owner-and-repo owner/repo)
    (setf issue (coerce-issue-number issue))
    (github-get "issues/reopen/:user/:repo/:issue"
                :uri-params (list user repo issue)
                :return-type '(:root "issue" :list nil :object t :type issue)
                :send-login-token t
                :callback callback :nomsg nomsg)))

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

(defun update-issue (owner/repo issue &key
                               (title nil title-supplied-p)
                               (body nil body-supplied-p)
                               callback nomsg)
  (multiple-value-bind (user repo)
      (coerce-owner-and-repo owner/repo)
    (check-nullable-type title string)
    (check-nullable-type body string)
    (form-value-bind (data)
        (progn
          (form2 "title" title title-supplied-p issue :title)
          (form2 "body" body body-supplied-p issue :body))
      (setf issue (coerce-issue-number issue))
      (github-post "issues/edit/:user/:repo/:issue"
                   :uri-params (list user repo issue)
                   :return-type '(:root "issue" :list nil :object t :type issue)
                   :data data
                   :callback callback :nomsg nomsg))))

; Where you can provide POST variables:

;     title
;     body

; This will overwrite the title or body of the issue, if you are authorized member of the project.

;;; ### Listing Labels ###

; You can list available labels for a projects issues with

(defun list-issue-labels (owner/repo &key callback nomsg)
  (multiple-value-bind (user repo)
      (coerce-owner-and-repo owner/repo)
    (github-get "issues/labels/:user/:repo"
                :uri-params (list user repo)
                :return-type '(:root "labels" :list t :object nil)
                :callback callback :nomsg nomsg)))

; For example,

;     $ curl -F 'login=schacon' -F 'token=XXX' https://github.com/api/v2/yaml/issues/labels/schacon/simplegit
;     ---
;     labels:
;     - label1
;     - label2

;;; ### Add and Remove Labels ###

; To add a label, run

(defun add-issue-label (owner/repo issue label &key callback nomsg)
  (multiple-value-bind (user repo)
      (coerce-owner-and-repo owner/repo)
    (setf issue (coerce-issue-number issue))
    (check-type label string)
    (github-get "issues/label/add/:user/:repo/:label/:issue"
                :uri-params (list user repo label issue)
                :return-type '(:root "labels" :list t :object nil)
                :send-login-token t
                :callback callback :nomsg nomsg)))

; This will return a list of the labels currently on that issue, your new one included. If the label is not yet in the system, it will be created.

; Here is how I would add the label 'testing' to my first ticket in my simplegit project:

;     $ curl -F 'login=schacon' -F 'token=XXX' https://github.com/api/v2/yaml/issues/label/add/schacon/simplegit/testing/1
;     ---
;     labels:
;     - testing
;     - test_label


; To remove a label, run:

(defun delete-issue-label (owner/repo issue label &key callback nomsg)
  (multiple-value-bind (user repo)
      (coerce-owner-and-repo owner/repo)
    (setf issue (coerce-issue-number issue))
    (check-type label string)
    (github-get "issues/label/remove/:user/:repo/:label/:issue"
                :uri-params (list user repo label issue)
                :return-type '(:root "labels" :list t :object nil)
                :send-login-token t
                :callback callback :nomsg nomsg)))

; Again, it will return a list of the labels currently on the issue.

; You can also add and remove labels generally by leaving off the Issue number.
; That will add a label to the system but not attach it to an issue, or remove
; an issue from all labels.

;;; ### Comment on Issues ###

; You can comment on issues at

(defun add-issue-comment (owner/repo issue comment &key callback nomsg)
  (multiple-value-bind (user repo)
      (coerce-owner-and-repo owner/repo)
    (setf issue (coerce-issue-number issue))
    (check-type comment string)
    (form-value-bind (data)
        (form "comment" comment t)
      (github-post "issues/comment/:user/:repo/:issue"
                   :uri-params (list user repo issue)
                   :return-type '(:root "labels" :list t :object nil :type issue-comment)
                   :data data
                   :callback callback :nomsg nomsg))))

; Simply send it a 'comment' POST variable with the comment you'd like to make.  It will attribute the comment to the user that is authenticated.  Here is an example:

;     $ curl -F 'login=schacon' -F 'token=XXX' -F 'comment=this is amazing' \
;     https://github.com/api/v2/json/issues/comment/defunkt/dunder-mifflin/1
;     {"comment": {"gravatar_id": "9375a9529679f1b42b567a640d775e7d",
;     "user": "schacon", "body": "this is amazing", id: 17,
;     created_at: TIMESTAMP, updated_at: TIMESTAMP}


(provide "github/api/issues")

;;; End
