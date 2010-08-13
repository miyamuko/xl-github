; -*- mode: lisp; package: github -*-

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
  )

(in-package :github)

(export '(list-my-gists
          list-my-gists1
          create-gist
          update-gist
          delete-gist
          add-gist-comment
          list-gist-revisions
          update-gist-description
          star-gist-p
          star-gist
          unstar-gist
          ))


;;; ### My Public & Private Gist ###

(defun list-my-gists (&key nomsg)
  (let ((page 1) r)
    (loop
      (multiple-value-bind (id-list next-page)
          (list-my-gists1 :page page :nomsg nomsg)
        (push id-list r)
        (unless next-page
          (return))
        (setf page next-page)))
    (apply 'append (nreverse r))))

(defun list-my-gists1 (&key page nomsg)
  (let ((*github-api-endpoint* *gist-domain*))
    (scan-id-list
     (github-get "mine"
                 :query-params `((:page ,(or page 1)))
                 :send-login-token t
                 :raw t :nomsg nomsg))))

;;; ### Gist Edit ###

(defun create-gist (filename contents &key private nomsg)
  (multiple-value-bind (name ext)
      (parse-filename filename)
    (let ((*github-api-endpoint* *gist-domain*))
      (form-value-bind (data)
          (progn
            (form "action_button" "private" private)
            (form "file_name[gistfile1]" name t)
            (form "file_ext[gistfile1]" ext t)
            (form "file_contents[gistfile1]" contents t))
        (scan-id
         (github-post "gists"
                      :data data
                      :raw t :nomsg nomsg))))))

(defun update-gist (id filename contents &key nomsg)
  (multiple-value-bind (name ext)
      (parse-filename filename)
    (let ((*github-api-endpoint* *gist-domain*))
      (form-value-bind (data)
          (progn
            (form "_method" "put" t)
            (form (format nil "file_name[~A]" filename) name t)
            (form (format nil "file_ext[~A]" filename) ext t)
            (form (format nil "file_contents[~A]" filename) contents t))
        (scan-revisions
         (github-post "gists/:id"
                      :uri-params (list id)
                      :data data
                      :raw t :nomsg nomsg))))))

(defun delete-gist (id &key nomsg)
  (let ((*github-api-endpoint* *gist-domain*))
    (form-value-bind (data)
        (form "_method" "delete" t)
      (github-post "delete/:id"
                   :uri-params (list id)
                   :data data
                   :raw t :nomsg nomsg)
      nil)))

(defun add-gist-comment (id comment &key nomsg)
  (let ((*github-api-endpoint* *gist-domain*))
    (form-value-bind (data)
        (form "comment[body]" comment t)
      (github-post ":id/comment"
                   :uri-params (list id)
                   :data data
                   :raw t :nomsg nomsg)
      nil)))

(defun list-gist-revisions (id &key nomsg)
  (scan-revisions (get-html id)))

(defun update-gist-description (id description &key nomsg)
  (let ((*github-api-endpoint* *gist-domain*))
    (form-value-bind (data)
        (form "description" description t)
      (github-post "gists/:id/update_description"
                   :uri-params (list id)
                   :data data
                   :raw t :nomsg nomsg))))

(defun star-gist-p (id &key nomsg)
  (string= "unstar" (scan-star (get-html id :nomsg nomsg))))

(defun star-gist (id &key nomsg)
  (set-star id t nomsg))

(defun unstar-gist (id &key nomsg)
  (set-star id nil nomsg))

(defun set-star (id star nomsg)
  (let ((*github-api-endpoint* *gist-domain*))
    (github-post ":method/:id"
                 :uri-params (list (if star "star" "unstar") id)
                 :raw t :nomsg nomsg)
    nil))


;;; ### Utilities ###

(defun get-html (id &key nomsg)
  (let ((*github-api-endpoint* *gist-domain*))
    (github-get ":id"
                :uri-params (list id)
                :send-login-token t
                :raw t :nomsg nomsg)))

(defparameter *gist-list-id-regexp* "<span><a href=\"/\\([0-9a-f]+\\)\">gist: [0-9a-f]+</a></span>")
(defparameter *gist-list-next-page-regexp* "<a href=\"/mine\\?.*?page=\\([0-9]+\\).*?\" hotkey=\"l\">")
(defun scan-id-list (html)
  (values (scan-all html *gist-list-id-regexp* 1)
          (let ((next (scan1 html *gist-list-next-page-regexp* 1)))
            (when next
              (parse-integer next)))))

(defparameter *gist-title-regexp* "<title>gist: +\\([a-f0-9]+\\).*?</title>")
(defun scan-id (html)
  (scan1 html *gist-title-regexp* 1))

(defparameter *gist-revision-regexp* "<a +href=\"http://gist.github.com/[0-9a-f]+/\\([0-9a-f]+\\)\" +class=\"id\">")
(defun scan-revisions (html)
  (scan-all html *gist-revision-regexp* 1))

(defparameter *gist-star-regexp* "<a href=\"/\\(\\(?:un\\)?star\\)/[0-9a-f]+\">")
(defun scan-star (html)
  (scan1 html *gist-star-regexp* 1))


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

(defun parse-filename (filename)
  (let ((name (pathname-name filename))
        (ext (pathname-type filename)))
    (values name (if ext (format nil ".~A" ext) ""))))


(provide "github/api/gist-unofficial")

;;; End
