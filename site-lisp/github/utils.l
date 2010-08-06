; -*- mode: lisp; package: github -*-

;;; github/utils.l
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
  (mc-require "github/macros")
  )

(in-package :github)

(defun process-output->string (command &optional environ directory)
  (let ((stdout (make-temp-file-name))
        (stderr (make-temp-file-name))
        (directory (or directory (default-directory))))
    (multiple-value-bind (cmdline dir)
        (ed::shell-command-line command directory)
      (unwind-protect
          (let ((exit-status (call-process cmdline
                                           :output stdout :error stderr
                                           :environ environ
                                           :exec-directory dir
                                           :show :hide :wait t)))
            (values
             (read-file-contents stdout)
             (read-file-contents stderr)
             exit-status))
        (progn
          (when (file-exist-p stdout)
            (delete-file stdout))
          (when (file-exist-p stderr)
            (delete-file stderr)))))))

(defun process-output->string-list (command &optional environ directory)
  (multiple-value-bind (stdout stderr exit-status)
      (process-output->string command environ directory)
    (values
     (split-string stdout #\LFD)
     (split-string stderr #\LFD)
     exit-status)))

(defun read-file-contents (filename)
  (let ((buf (get-buffer-create (format nil " *~A:read-file-contents*" *package*))))
    (unwind-protect
        (with-selected-buffer buf
          (erase-buffer buf)
          (insert-file-contents filename)
          (buffer-substring (point-min) (point-max)))
      (when (and buf (bufferp buf) (not (deleted-buffer-p buf)))
        (delete-buffer buf)))))


(provide "github/utils")

;;; End
