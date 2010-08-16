; -*- mode: lisp; package: github -*-

;;; github/utils/srfi-26.l
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

;; http://practical-scheme.net/gauche/man/gauche-refj_24.html

(eval-when (:compile-toplevel :load-toplevel :execute)
  (defun cut-parse-arg (args)
    (mapcar #'(lambda (arg)
                (case arg
                  (<>
                   (cons nil (list (gensym))))
                  (<...>
                   (cons nil (list '&rest (gensym))))
                  (t
                   (cons arg (list (gensym))))))
            args))

  (defun cut-lambda-args (vars)
    (apply #'append (mapcar #'cdr (remove-if #'car vars))))

  (defun cut-var-gensym (var)
    (car (last (cdr var))))

  (defun cut-var-form (var)
    (car var))

  (defun cut-placeholder-p (var)
    (not (car var)))

  (defmacro cut (fn &rest args)
    (let ((vars (cut-parse-arg args)))
      `(lambda (,@(cut-lambda-args vars))
         (,fn ,@(mapcar #'(lambda (e)
                            (if (cut-placeholder-p e)
                                (cut-var-gensym e)
                              (cut-var-form e)))
                        vars)))))

  (defmacro cute (fn &rest args)
    (let ((vars (cut-parse-arg args)))
      `(let (,@(mapcar #'(lambda (e)
                           `(,(cut-var-gensym e) ,(cut-var-form e)))
                       (remove-if #'cut-placeholder-p vars)))
         (lambda (,@(cut-lambda-args vars))
           (,fn ,@(mapcar #'cut-var-gensym vars)))))))


(provide "github/utils/srfi-26")

;;; End
