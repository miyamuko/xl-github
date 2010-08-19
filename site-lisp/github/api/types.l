; -*- mode: lisp; package: github -*-

;;; github/api/types.l
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
  (mc-require "github/package")
  (mc-require "github/utils/struct")
  )

(in-package :github)

(export '(repo-public-clone-url
          repo-private-clone-url
          repo-public-clone-url-http
          repo-private-clone-url-https
          ))

;;; ## Repositories & Users API ##

;; 秘密鍵の情報
(defstruct public-key
  id key title)
(export-struct 'public-key)

;;; ## Repositories API ##

;; 検索結果のリポジトリ
(defstruct searched-repo
  name owner description
  pushed-at created-at
  forks fork-p
  size language followers
  score type id)
(export-struct 'searched-repo)

;; base.l の json->struct 内で利用
(setf (get 'searched-repo 'github-slot-mapping)
      '(:username :owner
        :pushed :pushed-at
        :created :created-at
        :fork :fork-p))

;; 普通のリポジトリ
(defstruct repo
  name owner description
  pushed-at created-at
  forks fork-p
  homepage url
  watchers open-issues pledgie
  has-downloads has-issues has-wiki private-p)
(export-struct 'repo)

;; base.l の json->struct 内で利用
(setf (get 'repo 'github-slot-mapping)
      '(:fork :fork-p
        :private :private-p))

(defun repo-public-clone-url (repo)
  (bind-plist "git://github.com/:owner/:name.git"
              `(owner ,(repo-owner repo) name ,(repo-name repo))))

(defun repo-private-clone-url (repo)
  (bind-plist "git@github.com::owner/:name.git"
              `(owner ,(repo-owner repo) name ,(repo-name repo))))

(defun repo-public-clone-url-http (repo)
  (bind-plist "http://github.com/:owner/:name.git"
              `(owner ,(repo-owner repo) name ,(repo-name repo))))

(defun repo-private-clone-url-https (repo)
  (bind-plist "https://:owner@github.com/:owner/:name.git"
              `(owner ,(repo-owner repo) name ,(repo-name repo))))


;;; ## Users API ##

;; ユーザのプラン
(defstruct plan
  name space collaborators private-repos)
(export-struct 'plan)

;; 検索結果のユーザ
(defstruct searched-user
  id login name location
  followers-count public-repo-count
  language score type username
  created-at pushed-at)
(setf (get 'searched-user 'github-slot-mapping)
      '(:name :login
        :fullname :name
        :created :created-at
        :pushed :pushed-at
        :followers :followers-count
        :repos :public-repo-count
        ))
(setf (get 'searched-user-id 'github-filter)
      (lambda (id)
        (if (string-match "user-\\([0-9]+\\)" id)
            (parse-integer (match-string 1))
          id)))
(export-struct 'searched-user)

;; 普通のユーザ
(defstruct user
  id login name location
  email blog company
  followers-count following-count
  public-repo-count public-gist-count
  gravatar-id type created-at)
(export-struct 'user)

;; 認証されたユーザ
(defstruct (auth-user (:include user))
  collaborators disk-usage
  owned-private-repo-count private-gist-count total-private-repo-count
  (plan nil :type plan))
(export-struct 'auth-user)


;;; ## Object API ##

(defstruct object-base
  name size sha mode mime-type)

(defstruct (object (:include object-base))
  type)
(export-struct 'object)

(defstruct (blob (:include object-base))
  data)
(export-struct 'object)


;;; ## Commits API ##

(defstruct modified
  diff filename)
(export-struct 'modified)

(defstruct contributor
  login name location
  email company blog
  gravatar-id
  contributions type)
(export-struct 'contributor)

(defstruct commit
  id url message tree
  parents
  committed-date authored-date
  (author nil :type contributor)
  (committer nil :type contributor)
  (modified nil :type modified))
(export-struct 'commit)

;; base.l の json->struct 内で利用
(setf (get 'commit-parents 'github-filter) (lambda (json) (json-value json "id"))
      (get 'commit-parents 'github-json-list) t)
(setf (get 'commit-modified 'github-json-list) t)


;;; ## Issue API ##

;; Issue のコメント
(defstruct issue-comment
  id user gravatar-id
  created-at updated-at
  body)
(export-struct 'issue-comment)

;; Issue
(defstruct issue
  number user state labels title body
  gravatar-id position votes comments
  created-at updated-at closed-at)
(export-struct 'issue)


;;; ## Network API ##

(defstruct network-blocks
  name count start)
(export-struct 'network-blocks)

(defstruct network-users
  repo name heads)
(export-struct 'network-users)
(setf (get 'network-users-heads 'github-json-list) t
      (get 'network-users-heads 'github-filter)
      ;; list-repo-branches の結果と合わせる
      (lambda (json)
        (cons (json-value json "name")
              (json-value json "id"))))

(defstruct network
  nethash focus spacemap dates
  (blocks nil :type network-blocks)
  (users nil :type network-users))
(export-struct 'network)
(setf (get 'network-blocks 'github-json-list) t
      (get 'network-users 'github-json-list) t)


;;; ## Gist API ##

;; Gist
(defstruct gist
  id owner description public-p files created-at)
(export-struct 'gist)
(setf (get 'gist 'github-slot-mapping)
      '(:repo :id
        :public :public-p))


(provide "github/api/types")

;;; End
