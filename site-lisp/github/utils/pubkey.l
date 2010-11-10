; -*- mode: lisp; package: github; encoding: shift_jis -*-

;;; github/utils/pubkey.l
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
  (require "github/package")
  (require "github/utils/file")
  )

(in-package :github)

(defun read-public-key (filename)
  (let ((lines (split-string (read-file-contents (normalize-filename filename)) #\LFD)))
    (cond ((and (= 1 (length lines))
                (string-match "^ssh-\\(rsa\\|dss\\) " (car lines)))
           (car lines))
          ((and (<= 3 (length lines))
                (string= "---- BEGIN SSH2 PUBLIC KEY ----" (car lines))
                (string= "---- END SSH2 PUBLIC KEY ----" (car (last lines))))
           (convert-rfc4716->openssh lines))
          (t
           (plain-error "サポートしていない公開鍵のフォーマットです")))))

;; The Secure Shell (SSH) Public Key File Format
;; http://www.ietf.org/rfc/rfc4716.txt
(defun convert-rfc4716->openssh (lines)
  (let (header body continue-line in-body)
    (dolist (line (cdr (nbutlast lines)))
      (cond ((and (not in-body)
                  (or (string-matchp "^[a-z-]+:" line)
                      continue-line))
             (push line header)
             (setf continue-line nil)
             (when (string-matchp "\\\\$" line)
               (setf continue-line t)))
            (t
             (setf in-body t)
             (push line body))))
    (format nil "~:[ssh-dss~;ssh-rsa~] ~{~A~}"
            (string-matchp "RSA" (format nil "~{~A~}" header))
            (nreverse body))))


(provide "github/utils/pubkey")

;;; End
