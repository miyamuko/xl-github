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
  (mc-require "github/package")
  (mc-require "github/api/gist")
  )

(in-package :github)

(export '(gist-id-list-all
          gist-id-list
          gist-new
          gist-edit
          gist-delete
          gist-comment-add
          gist-update-description
          gist-star
          gist-unstar
          ))


;;; ### Mine Public & Private Gist ###

(defun gist-id-list-all (&key nomsg)
  (let ((page 1) r)
    (loop
      (multiple-value-bind (id-list next-page)
          (gist-id-list :page page :nomsg nomsg)
        (push id-list r)
        (unless next-page
          (return))
        (setf page next-page)))
    (apply 'append (nreverse r))))

(defun gist-id-list (&key page nomsg)
  (let ((*github-api-endpoint* *gist-domain*))
    (parse-gist-list
     (github-get "mine"
                 :query-params `((:page ,(or page 1)))
                 :send-login-token t
                 :raw t :nomsg nomsg))))

(defparameter *gist-list-id-regexp* "<span><a href=\"/\\([0-9a-f]+\\)\">gist: [0-9a-f]+</a></span>")
(defparameter *gist-list-next-page-regexp* "<a href=\"/mine\\?.*?page=\\([0-9]+\\).*?\" hotkey=\"l\">")
(defun parse-gist-list (html)
  (let ((start 0) id-list next-page)
    (while (string-matchp *gist-list-id-regexp* html start)
      (push (match-string 1) id-list)
      (setf start (match-end 0)))
    (when (string-matchp *gist-list-next-page-regexp* html)
      (setf next-page (parse-integer (match-string 1))))
    (values (nreverse id-list) next-page)))


;;; ### Gist Edit ###

(defun gist-new (filename contents &key private nomsg)
  (multiple-value-bind (name ext)
      (parse-filename filename)
    (let ((*github-api-endpoint* *gist-domain*))
      (form-value-bind (data)
          (progn
            (form "action_button" "private" private)
            (form "file_name[gistfile1]" name t)
            (form "file_ext[gistfile1]" ext t)
            (form "file_contents[gistfile1]" contents t))
        (github-post "gists"
                     :data data
                     :raw t :nomsg nomsg)))))

(defun gist-edit (id filename contents &key nomsg)
  (multiple-value-bind (name ext)
      (parse-filename filename)
    (let ((*github-api-endpoint* *gist-domain*))
      (form-value-bind (data)
          (progn
            (form "_method" "put" t)
            (form (format nil "file_name[~A]" filename) name t)
            (form (format nil "file_ext[~A]" filename) ext t)
            (form (format nil "file_contents[~A]" filename) contents t))
        (github-post "gists/:id"
                     :uri-params (list id)
                     :data data
                     :raw t :nomsg nomsg)))))

(defun gist-delete (id &key nomsg)
  (let ((*github-api-endpoint* *gist-domain*))
    (form-value-bind (data)
        (form "_method" "delete" t)
      (github-post "delete/:id"
                   :uri-params (list id)
                   :data data
                   :raw t :nomsg nomsg))))

(defun gist-comment-add (id comment &key nomsg)
  (let ((*github-api-endpoint* *gist-domain*))
    (form-value-bind (data)
        (form "comment[body]" comment t)
      (github-post ":id/comment"
                   :uri-params (list id)
                   :data data
                   :raw t :nomsg nomsg))))

(defun gist-update-description (id description &key nomsg)
  (let ((*github-api-endpoint* *gist-domain*))
    (form-value-bind (data)
        (form "description" description t)
      (github-post "gists/:id/update_description"
                   :uri-params (list id)
                   :data data
                   :raw t :nomsg nomsg))))

(defun gist-star (id &key nomsg)
  (gist-set-star id t nomsg))

(defun gist-unstar (id &key nomsg)
  (gist-set-star id nil nomsg))

(defun gist-set-star (id star nomsg)
  (let ((*github-api-endpoint* *gist-domain*))
    (github-post ":method/:id"
                 :uri-params (list (if star "star" "unstar") id)
                 :raw t :nomsg nomsg)))


(defun parse-filename (filename)
  (let ((name (pathname-name filename))
        (ext (pathname-type filename)))
    (values name (if ext (format nil ".~A" ext) ""))))


(provide "github/api/gist-unofficial")

;;; End
