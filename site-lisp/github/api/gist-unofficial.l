; -*- mode: lisp; package: github; encoding: utf-8 -*-

;;; github/api/gist-unofficial.l
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
  (mc-require "github/api/gist")
  (mc-require "github/api/gist-filetype")
  )

(in-package :github)

(export '(list-all-gists
          list-starred-gists
          list-my-gists
          create-gist
          create-gist-files
          update-gist
          update-gist-files
          delete-gist
          add-gist-comment
          list-gist-revisions
          update-gist-description
          gist-star-p
          star-gist
          unstar-gist
          fork-gist
          gist-fork-p
          get-gist-parent
          list-gist-forks
          ))


;;; ### My Public & Private Gist ###

(defun list-all-gists (&key page callback nomsg)
  (check-nullable-type page integer)
  (list-gists "gists"
              :has-page-link nil :page page :all nil
              :callback callback :nomsg nomsg))

(defun list-starred-gists (&key page all callback nomsg)
  ;; owner は取得できない
  (check-nullable-type page integer)
  (list-gists "starred"
              :has-page-link t :page page :all all
              :callback callback :nomsg nomsg))

(defun list-my-gists (&key page all callback nomsg)
  (check-nullable-type page integer)
  (list-gists "mine"
              :has-page-link t
              :page page :all all
              :key #'(lambda (gists next)
                       (dolist (gist gists)
                         (setf (gist-owner gist) (copy-seq (get-credential-login))))
                       (values gists next))
              :callback callback
              :nomsg nomsg))

(defun list-gists (path &key has-page-link page all key callback nomsg)
  (check-nullable-type page integer)
  (labels ((list-gist1 (page acc)
             (get-gist-list-page path :page page
                                 :key #'(lambda (html)
                                          (scan-gist-list html page has-page-link))
                                 :callback #'(lambda (r next)
                                               (let ((acc (append acc r)))
                                                 (if (and all next)
                                                     (list-gist1 next acc)
                                                   (funcall (compose callback key) acc next))))
                                 :async (not (null callback))
                                 :nomsg nomsg)))
    (list-gist1 (or page 1) nil)))


;;; ### Gist Edit ###

(defun create-gist (contents &key name lang private callback nomsg)
  (check-type contents string)
  (check-nullable-type name string)
  (check-nullable-type lang (or string symbol))
  (create-gist-files (make-gist-file :contents contents :name name :lang lang)
                     :private private :callback callback :nomsg nomsg))

(defun update-gist (id contents &key name lang private callback nomsg)
  (check-type contents string)
  (check-nullable-type name string)
  (check-nullable-type lang (or string symbol))
  (update-gist-files id (make-gist-file :contents contents :name name :lang lang)
                     :private private :callback callback :nomsg nomsg))

(defmacro form-files (files)
  `(let ((i 1))
     (dolist (file ,files)
       (form (format nil "file_name[gistfile~D]" i) (gist-file-name file) t)
       (form (format nil "file_ext[gistfile~D]" i) (get-gist-ext file) t)
       (form (format nil "file_contents[gistfile~D]" i) (gist-file-contents file) t)
       (incf i))))

(defun create-gist-files (files &key private callback nomsg)
  (setf files (normalize-gist-file files))
  (form-value-bind (data)
      (progn
        (form "action_button" "private" private)
        (form-files files))
    (gist-post "gists"
               :data data :key #'scan-id
               :callback callback :nomsg nomsg)))

(defun update-gist-files (id files &key callback nomsg)
  (setf id (coerce-gist-id id))
  (setf files (normalize-gist-file files))
  (form-value-bind (data)
      (progn
        (form "_method" "put" t)
        (form-files files))
    (gist-post "gists/:id" :uri-params (list id)
               :data data :key #'scan-revisions
               :callback callback :nomsg nomsg)))

(defun delete-gist (id &key callback nomsg)
  (setf id (coerce-gist-id id))
  (form-value-bind (data)
      (form "_method" "delete" t)
    (gist-post "delete/:id"
               :uri-params (list id)
               :data data
               :key #'nothing
               :callback callback :nomsg nomsg)))

(defun add-gist-comment (id comment &key callback nomsg)
  (setf id (coerce-gist-id id))
  (check-type comment string)
  (form-value-bind (data)
      (form "comment[body]" comment t)
    (gist-post ":id/comment"
               :uri-params (list id)
               :data data
               :key #'nothing
               :callback callback :nomsg nomsg)))

(defun list-gist-revisions (id &key callback nomsg)
  (setf id (coerce-gist-id id))
  (get-gist-page id :key #'scan-revisions :callback callback :nomsg nomsg))

(defun update-gist-description (id description &key callback nomsg)
  (setf id (coerce-gist-id id))
  (check-type description string)
  (form-value-bind (data)
      (form "description" description t)
    (gist-post "gists/:id/update_description"
               :uri-params (list id)
               :data data
               :callback callback :nomsg nomsg)))

(defun gist-star-p (id &key callback nomsg)
  (setf id (coerce-gist-id id))
  (get-gist-page id
                 :key (compose (cut string= "unstar" <>) 'scan-star)
                 :callback callback
                 :nomsg nomsg))

(defun star-gist (id &key callback nomsg)
  (set-star id t callback nomsg))

(defun unstar-gist (id &key callback nomsg)
  (set-star id nil callback nomsg))

(defun set-star (id star callback nomsg)
  (setf id (coerce-gist-id id))
  (gist-post ":method/:id"
             :uri-params (list (if star "star" "unstar") id)
             :key #'nothing
             :callback callback :nomsg nomsg))

(defun fork-gist (id &key callback nomsg)
  (setf id (coerce-gist-id id))
  (gist-post "fork/:id"
             :uri-params (list id)
             :key #'scan-id
             :callback callback :nomsg nomsg))

(defun gist-fork-p (id &key callback nomsg)
  (setf id (coerce-gist-id id))
  (get-gist-page id
                 :key (compose 'not 'null 'scan-parent)
                 :callback callback
                 :nomsg nomsg))

(defun get-gist-parent (id &key callback nomsg)
  (setf id (coerce-gist-id id))
  (get-gist-page id
                 :key #'scan-parent
                 :callback callback
                 :nomsg nomsg))

(defun list-gist-forks (id &key callback nomsg)
  (setf id (coerce-gist-id id))
  (get-gist-page id
                 :key #'scan-forks
                 :callback callback
                 :nomsg nomsg))


;;; ### Utilities ###

(defun get-gist-page (id &key key callback nomsg)
  (gist-get ":id" :uri-params (list id)
            :key key :callback callback :nomsg nomsg))

(defun get-gist-list-page (path &key page
                                key callback (async (not (null callback)))
                                nomsg)
  (gist-get path :query-params `((:page ,(or page 1)))
            :key key :callback callback :async async
            :nomsg nomsg))


(defun gist-get (path-template &key uri-params query-params
                               key callback (async (not (null callback)))
                               nomsg)
  (let ((*github-api-endpoint* *gist-domain*))
    (github-get path-template
                :uri-params uri-params
                :query-params query-params
                :send-login-token t
                :key key :callback callback :async async
                :raw t :nomsg nomsg)))

(defun gist-post (path-template &key data uri-params
                               key callback (async (not (null callback)))
                               nomsg)
  (let ((*github-api-endpoint* *gist-domain*))
    (github-post path-template
                 :uri-params uri-params
                 :data data
                 :key key :callback callback :async async
                 :raw t :nomsg nomsg)))

(defparameter *gist-id-link-regexp* "<a href=\"/\\([0-9a-f]+\\)\">gist:")
(defparameter *gist-list-file-regexp-pair* '("<div class=\"file " "<div class=\"data "))
(defparameter *gist-list-span-regexp-pair* '("<span" "</span>"))
(defparameter *gist-list-desc-regexp* "<span>\\(.+?\\)</span>")
(defparameter *gist-list-visibility-regexp* "<div class=\"file \\([a-z]+\\)\">")
(defparameter *gist-list-owner-regexp* "by <a href=\"/\\(.+?\\)\">")
(defparameter *gist-list-created-at-regexp* "<abbr class=\"relatize\" title=\"\\(.+?\\)\">")
(defparameter *gist-list-next-page-regexp* "<a href=\"/[a-z]+\\?.*?page=\\([0-9]+\\).*?\" hotkey=\"l\">")
(defun scan-gist-list (html page has-page-link)
  (let ((gists (mapcar #'(lambda (file)
                           (let* ((spans (scan-between file *gist-list-span-regexp-pair*))
                                  (id (scan1 (car spans) *gist-id-link-regexp* 1))
                                  (desc (scan1 (cadr spans) *gist-list-desc-regexp* 1))
                                  (visibility (scan1 file *gist-list-visibility-regexp* 1))
                                  (owner (scan1 file *gist-list-owner-regexp* 1))
                                  (created-at (scan1 file *gist-list-created-at-regexp* 1)))
                             (make-gist :id id :description desc :owner owner :created-at created-at
                                        :public-p (string= visibility "public"))))
                       (scan-between html *gist-list-file-regexp-pair* :include-end nil)))
        (next (scan1 html *gist-list-next-page-regexp* 1)))
    (values gists
            (cond (has-page-link
                   ;; My Gists または Starred Gists の場合
                   (when next
                     (parse-integer next)))
                  (t
                   ;; All Gists の場合、次のページ番号が取れないので
                   ;; 最後の Gist (id=1) が出るまでは次のページはあるはず
                   (when (and gists
                              (string/= (gist-id (car (last gists))) "1"))
                     (incf page)))))))

(defparameter *gist-title-regexp* "<title>gist: +\\([a-f0-9]+\\).*?</title>")
(defun scan-id (html)
  (scan1 html *gist-title-regexp* 1))

(defparameter *gist-revision-regexp* "<a +href=\"http://gist.github.com/[0-9a-f]+/\\([0-9a-f]+\\)\" +class=\"id\">")
(defun scan-revisions (html)
  (scan-all html *gist-revision-regexp* 1))

(defparameter *gist-star-regexp* "<a href=\"/\\(\\(?:un\\)?star\\)/[0-9a-f]+\">")
(defun scan-star (html)
  (scan1 html *gist-star-regexp* 1))

(defparameter *gist-parent-regexp-pair* '("<div id=\"gist-parent\">" "</div>"))
(defun scan-parent (html)
  (let ((div (scan-between html *gist-parent-regexp-pair*)))
    (when div
      (scan1 (car div) *gist-id-link-regexp* 1))))

(defparameter *gist-forks-regexp-pair* '("<div class=\"fork-info\" id=\"forks\">" "</div>"))
(defun scan-forks (html)
  (let ((div (scan-between html *gist-forks-regexp-pair*)))
    (when div
      (scan-all (car div) *gist-id-link-regexp* 1))))


(defun scan-between (html pair &key (include-end t))
  (let ((split-start 0)
        (search-start 0)
        (result nil)
        (begin (car pair))
        (end (cadr pair)))
    ;; begin で分割
    (while (string-matchp begin html search-start)
      (let ((beg (match-beginning 0))
            (end (match-end 0)))
        (push (substring html split-start beg) result)
        (setf split-start beg
              search-start end)))
    (push (substring html split-start) result)
    ;; 最初の要素は begin を含んでいない
    (setf result (cdr (nreverse result)))
    ;; end 以降を削除
    (if end
        (mapcar #'(lambda (fragment)
                    (if (string-matchp end fragment)
                        (substring fragment 0 (if include-end (match-end 0) (match-beginning 0)))
                      fragment))
                result)
      result)))

(defun scan-all (html regexp group)
  (let ((start 0)
        (result nil))
    (while (string-matchp regexp html start)
      (push (if (atom group)
                (match-string group)
              (mapcar #'match-string group))
            result)
      (setf start (match-end 0)))
    (nreverse result)))

(defun scan1 (html regexp group &key must-match)
  (if (string-matchp regexp html)
      (if (atom group)
          (match-string group)
        (mapcar #'match-string group))
    (when must-match
      (plain-error "Failed to scrape html: ~S" regexp))))


(provide "github/api/gist-unofficial")

;;; End
