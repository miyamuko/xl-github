; -*- mode: lisp; package: github; encoding: utf-8 -*-

;;; github/utils/struct.l
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


;; This file based on site-lisp/cairo/util/struct.l

(eval-when (:compile-toplevel :load-toplevel :execute)
  (mc-require "github/package")
  (mc-require "github/utils/symbol")
  )

(in-package :github)

(defun make-struct (struct &rest rest)
  (apply (struct-constructor struct) rest))

(defun struct-name-p (struct-name)
  (get struct-name 'si::structure-definition))

(defun struct-definition (struct)
  (let ((def (cond ((si:*structure-definition-p struct)
                    struct)
                   ((si:*structurep struct)
                    (si:*structure-definition struct))
                   ((symbolp struct)
                    (get struct 'si::structure-definition)))))
    (unless def
      (error 'type-error
             :datum struct
             :expected-type 'struct))
    def))

(defun struct-name (struct)
  (si:*structure-definition-name
   (struct-definition struct)))

(defun struct-predicate (struct)
  ;; defstruct に指定した predicate は取得できないので決めうち
  (intern (format nil "~A-p" (struct-name struct))))

(defun struct-constructor (struct)
  (car (struct-constructors struct)))

(defun struct-constructors (struct)
  (si:*structure-definition-constructors
   (struct-definition struct)))

(defun struct-slot-descriptions (struct)
  (loop
    with def = (struct-definition struct)
    for i from 0 below (si:*structure-definition-nslots def)
    collect (multiple-value-list
             (struct-slot-description def i))))

(defun struct-slot-names (struct)
  (mapcar #'car (struct-slot-descriptions struct)))

(defun struct-slot-accessors (struct)
  (let* ((def (struct-definition struct))
         (name (struct-name def)))
    (mapcar #'(lambda (slot)
                (struct-slot-accessor name slot))
            (struct-slot-names def))))

(defun struct-slot-accessor (struct-name slot-name)
  (intern (format nil "~{~A~}" (list struct-name "-" slot-name))
          (symbol-package struct-name)))

(defun struct-slot-description (struct-definition index)
  (si:*structure-definition-slot-description struct-definition index))

(defun struct-slot-index (struct-definition slot-name)
  (si:*slot-index struct-definition (keyword slot-name)))

(defun struct-slot-type (struct-definition slot-name)
  (let ((i (struct-slot-index struct-definition slot-name)))
    (multiple-value-bind (_ _ type _)
        (struct-slot-description struct-definition i)
      type)))


(defun struct-slot-value (struct slot-name)
  (si:*slot-value struct (keyword slot-name)))

(defun struct-set-slot-value (struct slot-name value)
  (si:*set-slot-value struct (keyword slot-name) value))

(defsetf struct-slot-value struct-set-slot-value)


(defun export-struct (struct)
  (export-struct0 struct '(:name :predicate :accessors :constructors)))

(defun export-condition (condition)
  (export-struct0 condition '(:name :accessors)))

(defun export-struct0 (struct tags)
  (let ((desc (struct-description struct)))
    (dolist (tag tags)
      (let ((syms (cdr (assoc tag desc))))
        (when syms
          (export syms))))))

(defun struct-description (struct)
  (let ((def (struct-definition struct)))
    (list
     (cons :name (struct-name struct))
     (cons :predicate (struct-predicate struct))
     (cons :constructors (struct-constructors struct))
     (cons :accessors (struct-slot-accessors def)))))


(provide "github/utils/struct")

;;; End
