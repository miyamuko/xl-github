; -*- mode: lisp; package: github; encoding: utf-8 -*-

;;; github/utils/file.l
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

(defun read-file-contents (filename)
  (setf filename (normalize-filename filename))
  (let ((buf (get-buffer-create " *github:read-file-contents*")))
    (unwind-protect
        (with-selected-buffer buf
          (erase-buffer buf)
          (insert-file-contents filename)
          (buffer-substring (point-min) (point-max)))
      (when (and buf (bufferp buf) (not (deleted-buffer-p buf)))
        (delete-buffer buf)))))

(defun normalize-filename (filename)
  (when (or (not filename)
            (string= filename ""))
    (error "ファイル名が空です: ~S" filename))
  (setf filename (namestring filename))
  (when (file-exist-p filename)
    (setf filename (truename filename)))
  (when (special-file-p filename)
    (error "~Aはデバイスファイルです" filename))
  (when (file-directory-p filename)
    (error "~Aはディレクトリです" filename))
  (unless (valid-path-p filename)
    (error "~A\nファイルまたはディレクトリが見つかりません" filename))
  filename)

(defun add-leading-dot (ext)
  (when ext
    (if (char= (char ext 0) #\.)
        ext
      (format nil ".~A" ext))))

(defun pathname-ext (pathname)
  (when pathname
    (add-leading-dot (pathname-type pathname))))


(provide "github/utils/file")

;;; End
