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
  )

(in-package :github)

;;; ## Repositories & Users API ##

;; 秘密鍵の情報
(defstruct github-public-key
  id key title)
(export-struct 'github-public-key)

;;; ## Repositories API ##

;; 検索結果のリポジトリ
(defstruct github-repos
  id name description
  username fork-p size language
  followers forks
  pushed-at created-at
  score type)
(export-struct 'github-repos)

;; base.l の json->struct 内で利用
(setf (get 'github-repos 'github-slot-mapping)
      '(:pushed :pushed-at
        :created :created-at
        :fork :fork-p))

;; 普通のリポジトリ
(defstruct github-repo
  name owner description
  homepage url
  has-downloads has-issues has-wiki
  fork-p private-p
  forks watchers open-issues pledgie
  pushed-at created-at)
(export-struct 'github-repo)

;; base.l の json->struct 内で利用
(setf (get 'github-repo 'github-slot-mapping)
      '(:fork :fork-p
        :private :private-p))

;;; ## Users API ##

;; ユーザのプラン
(defstruct github-plan
  name space collaborators private-repos)
(export-struct 'github-plan)

;; 検索結果のユーザ
(defstruct github-users
  id name username fullname
  location language type
  created pushed
  followers repos score)
(export-struct 'github-users)

;; 普通のユーザ
(defstruct github-user
  id login name
  email location blog company type
  created-at gravatar-id
  followers-count following-count
  public-gist-count public-repo-count)
(export-struct 'github-user)

;; 認証されたユーザ
(defstruct (github-auth-user (:include github-user))
  collaborators disk-usage
  owned-private-repo-count private-gist-count total-private-repo-count
  (plan nil :type github-plan))
(export-struct 'github-auth-user)


;;; ## Object API ##

(defstruct github-object-base
  name size sha mode mime-type)

(defstruct (github-object (:include github-object-base))
  type)
(export-struct 'github-object)

(defstruct (github-blob (:include github-object-base))
  data)
(export-struct 'github-object)


;;; ## Commits API ##

(defstruct github-modified
  diff filename)
(export-struct 'github-modified)

(defstruct github-contributor
  login name email
  location company
  blog gravatar-id
  contributions type)
(export-struct 'github-contributor)

(defstruct github-commit
  id url message tree
  parents
  committed-date authored-date
  (author nil :type github-contributor)
  (committer nil :type github-contributor)
  (modified nil :type github-modified))
(export-struct 'github-commit)

;; base.l の json->struct 内で利用
(setf (get 'github-commit-parents 'github-json-subkey) "id")
(setf (get 'github-commit-modified 'github-json-list) t)


;;; ## Issue API ##

;; Issue のコメント
(defstruct github-issue-comment
  id user gravatar-id
  created-at updated-at
  body)
(export-struct 'github-issue-comment)

;; Issue
(defstruct github-issue
  number user state labels title body
  gravatar-id position votes comments
  created-at updated-at closed-at)
(export-struct 'github-issue)


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
