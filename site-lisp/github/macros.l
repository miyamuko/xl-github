; -*- mode: lisp; package: github; encoding: shift_jis -*-

;;; github/macros.l
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
  )

(in-package :github)

(defmacro with-gensyms (syms &body body)
  `(let ,(mapcar #'(lambda (sym)
                     `(,sym (gensym)))
                 syms)
     ,@body))
#+xyzzy
(setf (get 'with-gensyms 'ed:lisp-indent-hook) 'let)

(defmacro with-selected-buffer (buffer &body body)
  (with-gensyms (org)
    `(if (eq ,buffer (selected-buffer))
         (progn ,@body)
       (let ((,org (selected-buffer)))
         (unwind-protect
             (with-set-buffer
               (set-buffer ,buffer)
               (progn ,@body))
           (set-buffer ,org))))))
#+xyzzy
(setf (get 'with-selected-buffer 'ed::lisp-indent-hook) 'with-selected-window)

(defmacro form-value-bind ((var) value-form &body forms)
  `(let (,var)
     (macrolet ((form (key value predicate)
                  `(when ,predicate
                     (push (cons ,key ,value) ,',var)))
                (form2 (key value predicate struct slot &optional (fn 'identity))
                  `(if (and (si:*structurep ,struct) (not ,predicate))
                       (form ,key (,fn (struct-slot-value ,struct ,slot)) t)
                     (form ,key (,fn ,value) ,predicate))))
         ,value-form)
     (setf ,var (nreverse ,var))
     ,@forms))
#+xyzzy
(setf (get 'form-value-bind 'ed:lisp-indent-hook) 2)

(defmacro check-nullable-type (place typespec)
  `(when ,place
     (check-type ,place ,typespec)))


(provide "github/macros")

;;; End
