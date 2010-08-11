; -*- mode: lisp; package: github -*-

;;; github/api/users.l
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

(export '(github-users-search
          github-user-search-by-email
          github-user-show
          github-user-set
          github-user-show-following
          github-user-show-followers
          github-user-follow
          github-user-unfollow
          github-repos-watched
          github-user-keys
          github-user-key-add
          github-user-key-remove
          github-user-emails
          github-user-email-add
          github-user-email-remove
          ))


;;; ## Users API ##

; API for accessing and modifying user information.

;;; ### Searching for Users ###

; The route for user searching is:

(defun github-users-search (query &key nomsg)
  (github-get "user/search/:query"
              :uri-params (list query)
              :return-type '(:root "users" :list t :object t :type github-users)
              :nomsg nomsg))

(defun github-user-search-by-email (query &key nomsg)
  (github-get "user/email/:query"
              :uri-params (list query)
              :return-type '(:root "user" :list nil :object t :type github-user)
              :nomsg nomsg))

; For instance, you would search for users with 'chacon' in their name like this:

; 	$ curl -i http://github.com/api/v2/xml/user/search/chacon

; You can also search by email address.  This only matches against the email address
; the user has listed on their public profile, and is opt-in for everyone.

;   $ curl -i http://github.com/api/v2/xml/user/email/user@email.com

;;; ### Getting User Information ###

; You can then get extended information on users by their username.  The url format is:

(defun github-user-show (username &key nomsg)
  (github-get (if username "user/show/:username" "user/show")
              :uri-params (if username (list username) nil)
              :return-type `(:root "user" :list nil :object t
                             :type ,(lambda (json)
                                      (if (json-key-p json "plan") 'github-auth-user 'github-user)))
              :send-login-token t
              :nomsg nomsg))

; so the following command

; 	$ curl -i http://github.com/api/v2/yaml/user/show/defunkt

; will return the something like this:

; 	user:
; 	  id: 23
; 	  login: defunkt
; 	  name: Kristopher Walken Wanstrath
; 	  company: LA
; 	  location: SF
; 	  email: me@email.com
; 	  blog: http://myblog.com
; 	  following_count: 13
; 	  followers_count: 63
; 	  public_gist_count: 0
; 	  public_repo_count: 2

; If you authenticated as that user, you will also get this information:

; 	  total_private_repo_count: 1
; 	  collaborators: 3
; 	  disk_usage: 50384
; 	  owned_private_repo_count: 1
; 	  private_gist_count: 0
; 	  plan:
; 	    name: mega
; 	    collaborators: 60
; 	    space: 20971520
; 	    private_repos: 125

; If you authenticate, you can also get your own information by leaving your username out.

; (defun github-user-show (&key nomsg)
;   (github-get "user/show" :nomsg nomsg))

; You can use the following command to get your information:

;     $ curl http://github.com/api/v2/yaml/user/show?login=defunkt&token=XXX

; `curl -F` issues a POST request, which won't work.

;;; ### Authenticated User Management ###

; If you are authenticated, you can update your users information by
; POSTing to it in a few different ways.

(defun github-user-set (username &key
                                 (name nil name-supplied-p)
                                 (email nil email-supplied-p)
                                 (blog nil blog-supplied-p)
                                 (company nil company-supplied-p)
                                 (location nil location-supplied-p)
                                 nomsg)
  (form-value-bind (data)
      (progn
        (form "values[name]" name name-supplied-p)
        (form "values[email]" email email-supplied-p)
        (form "values[blog]" blog blog-supplied-p)
        (form "values[company]" company company-supplied-p)
        (form "values[location]" location location-supplied-p))
    (github-post "user/show/:username"
                 :uri-params (list username)
                 :return-type '(:root "user" :list nil :object t :type github-user)
                 :data data :nomsg nomsg)))

; 	      :values[key] = value

; Where the POST values are of:

; 	name
; 	email
; 	blog
; 	company
; 	location

; So, you could do this to update your email address:

; 	$ curl -F 'login=schacon' -F 'token=XXX' https://github.com/api/v2/json/user/show/schacon -F 'values[email]=scott@geemail.com'
; 	{
; 	  "user": {
; 	    "company": "Logical Awesome",
; 	    "name": "Scott Chacon",
; 	    "blog": "http:\/\/jointheconversation.org",
; 	    "disk_usage": 89352,
; 	    "collaborators": 3,
; 	    ...
; 	    "email": "scott@geemail.com",
; 	    "location": "Redwood City, CA"
; 	    "created_at": "2008\/01\/27 09:19:28 -0800",
; 	  }
; 	}


;;; ### Following Network ###

; If you want to look at the following network on GitHub, you can request the users that a specific user is following with:

(defun github-user-show-following (user &key nomsg)
  (github-get "user/show/:user/following"
              :uri-params (list user)
              :return-type '(:root "users" :list nil :object nil)
              :nomsg nomsg))

; or the users following a specific user with:


(defun github-user-show-followers (user &key nomsg)
  (github-get "user/show/:user/followers"
              :uri-params (list user)
              :return-type '(:root "users" :list nil :object nil)
              :nomsg nomsg))

; For example, if you want to see which users are following 'defunkt', you can run this:

; 	$ curl -i http://github.com/api/v2/yaml/user/show/defunkt/followers

; If you are authenticated as a user, you can also follow or unfollow users with:

(defun github-user-follow (user &key nomsg)
  (github-post "user/follow/:user"
               :uri-params (list user)
               :return-type '(:root "users" :list nil :object nil)
               :nomsg nomsg))

(defun github-user-unfollow (user &key nomsg)
  (github-post "user/unfollow/:user"
               :uri-params (list user)
               :return-type '(:root "users" :list nil :object nil)
               :nomsg nomsg))


;;; ### Watched Repos ###

; To see which repositories a user is watching, you can call:

(defun github-repos-watched (user &key nomsg)
  (github-get "repos/watched/:user"
              :uri-params (list user)
              :return-type '(:root "repositories" :list t :object t :type github-repo)
              :nomsg nomsg))

; For example,

; 	$ curl http://github.com/api/v2/yaml/repos/watched/schacon
; 	repositories:
; 	- :watchers: 42
; 	  :owner: ddollar
; 	  :name: git-db
; 	  :description: CouchDB-based git server
; 	  :private: false
; 	  :url: http://github.com/ddollar/git-db
; 	  :open_issues: 0
; 	  :fork: false
; 	  :homepage: http://github.com/ddollar/git-db
; 	  :forks: 2
; 	- :watchers: 2
; 	  :owner: schacon
; 	  :name: git-db
; 	  :description: CouchDB-based git server
; 	  :private: false
; 	  :url: http://github.com/schacon/git-db
; 	  :open_issues: 0
; 	  :fork: true
; 	  :homepage: http://github.com/ddollar/git-db
; 	  :forks: 0

;;;; #### Public Key Management ####

(defun github-user-keys (&key nomsg)
  (github-get "user/keys"
              :send-login-token t
              :return-type '(:root "public_keys" :list t :object t :type github-public-key)
              :nomsg nomsg))

(defun github-user-key-add (title key &key nomsg)
  (form-value-bind (data)
      (progn
        (form "title" title t)
        (form "key" key t))
    (github-post "user/key/add" :data data
                 :return-type '(:root "public_keys" :list t :object t :type github-public-key)
                 :nomsg nomsg)))
; 	      :title
; 	      :key

(defun github-user-key-remove (key-id &key nomsg)
  (form-value-bind (data)
      (form "id" key-id t)
    (github-post "user/key/remove"
                 :data data
                 :return-type '(:root "public_keys" :list t :object t :type github-public-key)
                 :nomsg nomsg)))
; 	      :id

;;;; #### Email Address Management ####

(defun github-user-emails (&key nomsg)
  (github-get "user/emails"
              :return-type '(:root "emails" :list t)
              :send-login-token t :nomsg nomsg))

(defun github-user-email-add (email &key nomsg)
  (form-value-bind (data)
      (form "email" email t)
    (github-post "user/email/add"
                 :data data
                 :return-type '(:root "emails" :list t)
                 :nomsg nomsg)))

(defun github-user-email-remove (email &key nomsg)
  (form-value-bind (data)
      (form "email" email t)
    (github-post "user/email/remove"
                 :data data
                 :return-type '(:root "emails" :list t)
                 :nomsg nomsg)))


(provide "github/api/users")

;;; End
