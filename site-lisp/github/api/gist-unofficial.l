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

(export '(gist-new
          gist-edit
          gist-delete
          gist-comment-add
          gist-update-description
          gist-star
          gist-unstar
          ))

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
