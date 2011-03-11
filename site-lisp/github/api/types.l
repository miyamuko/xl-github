; -*- mode: lisp; package: github; encoding: shift_jis -*-

;;; github/api/types.l
;;
;; Copyright (c) 2010-2011 MIYAMUKO Katsuyuki.
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
  (require "github/package")
  (require "github/utils/struct")
  (require "github/utils/file")
  )

(in-package :github)

(export '(repo-public-clone-url
          repo-private-clone-url
          repo-public-clone-url-http
          repo-private-clone-url-https

          repo-github-source-url
          repo-github-source-branches-url
          repo-github-commits-url
          repo-github-comments-url
          repo-github-contributors-url
          repo-github-network-graphs-url
          repo-github-network-members-url
          repo-github-network-pull-requests-url
          repo-github-forkqueue-url
          repo-github-issues-url
          repo-github-downloads-url
          repo-github-wiki-url
          repo-github-graphs-languages-url
          repo-github-graphs-impact-url
          repo-github-graphs-punchcard-url
          repo-github-graphs-traffic-url

          user-github-home-url

          gist-private-p
          gist-home-url
          gist-edit-url
          gist-download-url
          gist-public-clone-url
          gist-private-clone-url
          gist-embed-js-url

          make-gist-file-from-pathname
          ))

;;; ## Repositories & Users API ##

;; 秘密鍵の情報
(defstruct public-key
  id title body)
(setf (get 'public-key 'github-slot-mapping)
      '(:key :body))
(export-struct 'public-key)

;; Public Key ID への変換
(defun coerce-public-key-id (key-id)
  (check-type key-id (or integer public-key))
  (if (public-key-p key-id)
      (public-key-id key-id)
    key-id))


;;; ## Repositories API ##

(defstruct searched-repo-record
  id name description
  owner-id parent-id source-id primary-language-name-id organization-id plan-owner-id
  homepage
  master-branch integrate-branch
  watcher-count public-fork-count
  has-downloads has-issues has-wiki
  sandbox pledgie public-push pull-request-auto-response
  public-p deleted-p locked-p
  created-at updated-at pushed-at
  disk-usage cfg-wiki deploy-key
  postreceive-urls)
(setf (get 'searched-repo-record 'github-slot-mapping)
      '(:public :public-p
        :deleted :deleted-p
        :locked :locked-p
        ))

;; 検索結果のリポジトリ
(defstruct searched-repo
  owner name description
  pushed-at created-at
  forks fork-p
  size language followers
  score type id
  (record nil :type searched-repo-record))
(setf (get 'searched-repo 'github-slot-mapping)
      '(:username :owner
        :pushed :pushed-at
        :created :created-at
        :fork :fork-p
        :repo-id :id   ;; repo-id  は数値。id スロットとして扱う。
        ))
(setf (get 'searched-repo 'github-slot-ignore)
      '(:id            ;; id は "repo-(数値)" という形式。repo-id を id とするので無視する。
        ))
(export-struct 'searched-repo)

;; 普通のリポジトリ
(defstruct repo
  owner name description
  pushed-at created-at
  forks fork-p source parent
  homepage url organization size language
  watchers open-issues pledgie
  has-downloads has-issues has-wiki private-p)
(setf (get 'repo 'github-slot-mapping)
      '(:fork :fork-p
        :private :private-p
        ))
(export-struct 'repo)


;; ユーザ名とリポジトリ名への変換
(defun coerce-owner-and-repo (owner/repo)
  (check-type owner/repo (or string list repo))
  (multiple-value-bind (owner repo)
      (parse-owner/repo owner/repo)
    (unless owner
      (error (format nil "ownerが指定されていません: ~S" owner/repo)))
    (unless repo
      (error (format nil "repoが指定されていません: ~S" owner/repo)))
    (check-type owner string)
    (check-type repo string)
    (values owner repo)))

;; リポジトリ名への変換
(defun coerce-repo-name (repo)
  (check-type repo (or string list repo))
  (multiple-value-bind (owner repo)
      (parse-owner/repo repo)
    ;; "owner/repo" の場合 owner="owner", repo="repo" になるので repo を返す
    ;; "repo" の場合は owner="repo", repo=nil になるので owner を返す
    (or repo owner)))

(defun parse-owner/repo (owner/repo)
  (cond ((repo-p owner/repo)
         (values (repo-owner owner/repo)
                 (repo-name owner/repo)))
        ((stringp owner/repo)
         (values-list (split-string owner/repo #\/ 2)))
        ((listp owner/repo)
         (values-list owner/repo))))

(defun bind-repo (url-template owner/repo)
  (multiple-value-bind (owner repo)
      (coerce-owner-and-repo owner/repo)
    (bind-plist url-template `(:owner ,owner
                               :name ,repo))))

(defun repo-public-clone-url (repo)
  (bind-repo "git://github.com/:owner/:name.git" repo))

(defun repo-private-clone-url (repo)
  (bind-repo "git@github.com::owner/:name.git" repo))

(defun repo-public-clone-url-http (repo)
  (bind-repo "http://github.com/:owner/:name.git" repo))

(defun repo-private-clone-url-https (repo)
  (bind-repo "https://:owner@github.com/:owner/:name.git" repo))


(defun repo-github-source-url (repo &optional branch-or-tag)
  (bind-repo (format nil "http://github.com/:owner/:name~@[/tree/~A~]"
                     (if (string= branch-or-tag "master") nil branch-or-tag))
             repo))

(defun repo-github-source-branches-url (repo)
  (bind-repo "http://github.com/:owner/:name/branches" repo))

(defun repo-github-commits-url (repo &optional branch-or-tag)
  (bind-repo (format nil "http://github.com/:owner/:name/commits/~A"
                     (or branch-or-tag "master"))
             repo))

(defun repo-github-comments-url (repo)
  (bind-repo "http://github.com/:owner/:name/comments" repo))

(defun repo-github-contributors-url (repo)
  (bind-repo "http://github.com/:owner/:name/contributors" repo))

(defun repo-github-network-graphs-url (repo)
  (bind-repo "http://github.com/:owner/:name/network" repo))

(defun repo-github-network-members-url (repo)
  (bind-repo "http://github.com/:owner/:name/network/members" repo))

(defun repo-github-network-pull-requests-url (repo)
  (bind-repo "http://github.com/:owner/:name/pulls" repo))

(defun repo-github-forkqueue-url (repo &key ignored)
  (bind-repo (format nil "http://github.com/:owner/:name/forkqueue~:[~;/ignored~]" ignored)
             repo))

(defun repo-github-issues-url (repo)
  (bind-repo "http://github.com/:owner/:name/issues" repo))

(defun repo-github-downloads-url (repo)
  (bind-repo "http://github.com/:owner/:name/downloads" repo))

(defun repo-github-wiki-url (repo)
  (bind-repo "http://wiki.github.com/:owner/:name/" repo))

(defun repo-github-graphs-languages-url (repo)
  (bind-repo "http://github.com/:owner/:name/graphs/languages" repo))

(defun repo-github-graphs-impact-url (repo)
  (bind-repo "http://github.com/:owner/:name/graphs/impact" repo))

(defun repo-github-graphs-punchcard-url (repo)
  (bind-repo "http://github.com/:owner/:name/graphs/punch_card" repo))

(defun repo-github-graphs-traffic-url (repo)
  (bind-repo "http://github.com/:owner/:name/graphs/traffic" repo))


;;; ## Users API ##

;; ユーザのプラン
(defstruct plan
  name space collaborators private-repos)
(export-struct 'plan)

;; 検索結果のユーザ
(defstruct searched-user
  id login fullname location
  followers-count public-repo-count
  language score type username
  created-at pushed-at
  record) ;; record の中身がよく分からないのでとりあえずそのまま
(setf (get 'searched-user 'github-slot-mapping)
      '(:name :login
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
  id login fullname location
  email blog company
  followers-count following-count
  public-repo-count public-gist-count
  gravatar-id type created-at permission)
(setf (get 'user 'github-slot-mapping)
      '(:name :fullname
        ))
(export-struct 'user)

;; 認証されたユーザ
(defstruct (auth-user (:include user))
  collaborators disk-usage
  owned-private-repo-count private-gist-count total-private-repo-count
  (plan nil :type plan))
(setf (get 'auth-user 'github-slot-mapping)
      '(:name :fullname
        ))
(export-struct 'auth-user)

;; ユーザ名への変換
(defun coerce-user-login (user)
  (check-type user (or string user))
  (if (user-p user)
      (user-login user)
    user))

(defun user-github-home-url (user)
  (bind-plist "http://github.com/:user" `(:user ,(coerce-user-login user))))


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
  parents added removed
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

;; Issue number への変換
(defun coerce-issue-number (issue)
  (check-type issue (or integer issue))
  (if (issue-p issue)
      (issue-number issue)
    issue))


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
  id owner description public-p created-at files lines)
(export-struct 'gist)
(setf (get 'gist 'github-slot-mapping)
      '(:repo :id
        :public :public-p))

;; 構造体のスロットを上書きして Gist ID も引数として受け付けるようにする
;; Private な Gist の ID は 20 byte の 16 進数になるので
;; ID にアルファベットが含まれるかどうかで判断する。
;; 偶然、数字のみで構成された Private ID があったら、あきらめて Public を返す
(defun gist-public-p (gist)
  (check-type gist (or integer string gist))
  (cond ((gist-p gist)
         (struct-slot-value gist :public-p))
        ((integerp gist)
         t)
        (t
         (not (null (string-matchp "^[0-9]+$" gist))))))

(defun gist-private-p (gist)
  (not (gist-public-p gist)))

(defun gist-home-url (gist &optional revision)
  (gist-build-url gist nil revision))

(defun gist-edit-url (gist)
  (gist-build-url gist "gists" "edit"))

(defun gist-download-url (gist)
  (gist-build-url gist "gists" "download"))

(defun gist-build-url (gist path1 path2)
  (bind-plist (format nil "~:[https~;http~]://gist.github.com~@[/~A~]/:id~@[/~A~]"
                      (gist-public-p gist)
                      path1 path2)
              `(:id ,(coerce-gist-id gist))))

(defun gist-public-clone-url (gist)
  (when (gist-public-p gist)
    (bind-plist "git://gist.github.com/:id.git"
                `(:id ,(coerce-gist-id gist)))))

(defun gist-private-clone-url (gist)
  (bind-plist "git@gist.github.com::id.git"
              `(:id ,(coerce-gist-id gist))))

(defun gist-embed-js-url (gist)
  (when (gist-public-p gist)
    (bind-plist "http://gist.github.com/:id.js"
                `(:id ,(coerce-gist-id gist)))))

;; Gist ID への変換
(defun coerce-gist-id (id)
  (check-type id (or integer string gist))
  (if (gist-p id)
      (gist-id id)
    id))


;; Gist の内容を表す構造体

(defstruct gist-file
  name lang contents)

(defun make-gist-file-from-pathname (pathname &key name lang)
  (let ((r (make-gist-file :contents (read-file-contents pathname))))
    (cond ((or name lang)
           (setf (gist-file-name r) name
                 (gist-file-lang r) lang))
          (t
           (setf (gist-file-name r) (file-namestring pathname))))
    r))

(defun normalize-gist-file (files)
  (unless files
    (error "filesがnilです"))
  (when (atom files)
    (setf files (list files)))
  (mapcar #'(lambda (file)
              (unless (typep file '(or string gist-file))
                (error "filesはファイル名またはgist-fileのリストを指定してください"))
              (if (stringp file)
                  (make-gist-file-from-pathname file)
                (let ((contents (gist-file-contents file)))
                  (check-type contents string)
                  file)))
          files))

;; Web から Gist を作成すると name が指定されていると Language 指定は無視されるので
;; その挙動に合わせる
(defun get-gist-ext (file)
  (add-leading-dot
   (or (cond ((gist-file-name file)
              (or (safe-car (get-gist-filetype-by-name (gist-file-name file)))
                  (progn
                    (warn "ファイルタイプが不明なため ~A として扱います (Gist name: ~A, lang: ~A)"
                          *gist-default-filetype* (gist-file-name file) (gist-file-lang file))
                    *gist-default-filetype*)))
              ((gist-file-lang file)
               (safe-car (get-gist-filetype-by-lang (gist-file-lang file)))))
       *gist-default-filetype*)))


(provide "github/api/types")

;;; End
