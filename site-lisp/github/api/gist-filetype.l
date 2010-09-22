; -*- mode: lisp; package: github -*-

;;; github/api/gist-filetype.l
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

(export '(*gist-default-filetype*

          gist-filetype-names
          gist-filetype-exts
          guess-gist-filetype
          ))

(defvar *gist-default-filetype* ".txt")

;; ("拡張子" "言語" [xyzzyのモード...])
(defvar *gist-filetype-list*
  '((".txt" "Plain Text" text-mode fundamental-mode)
    (".as" "ActionScript")
    (".c" "C" c-mode)
    (".cs" "C#" csharp-mode)
    (".cpp" "C++" c++-mode)
    (".css" "CSS" css-mode)
    (".cl" "Common Lisp" lisp-interaction-mode lisp-mode)
    (".diff" "Diff" diff-mode)
    (".hrl" "Erlang")
    (".html" "HTML" html-mode)
    (".hs" "Haskell")
    (".java" "Java" java-mode)
    (".js" "JavaScript")
    (".lua" "Lua")
    (".m" "Objective-C")
    (".php" "PHP")
    (".pl" "Perl" perl-mode)
    (".py" "Python")
    (".rb" "Ruby")
    (".sql" "SQL" sql-mode)
    (".scala" "Scala")
    (".sls" "Scheme")
    (".tex" "TeX" LaTeX-mode latex-mode)
    (".xml" "XML")
    (".ascx" "ASP")
    (".scpt" "AppleScript")
    (".arc" "Arc")
    (".asm" "Assembly")
    (".bat" "Batchfile")
    (".befunge" "Befunge")
    (".boo" "Boo")
    (".b" "Brainfuck")
    (".c-objdump" "C-ObjDump")
    (".clj" "Clojure")
    (".coffee" "CoffeeScript")
    (".cfm" "ColdFusion")
    (".cppobjdump" "Cpp-ObjDump")
    (".feature" "Cucumber")
    (".d" "D")
    (".d  -objdump" "D-ObjDump")
    (".darcspatch" "Darcs Patch")
    (".pas" "Delphi" pascal-mode)
    (".dylan" "Dylan")
    (".e" "Eiffel")
    (".fs" "F#")
    (".f" "FORTRAN")
    (".s" "GAS")
    (".kid" "Genshi")
    (".po" "Gettext Catalog")
    (".go" "Go")
    (".man" "Groff")
    (".groovy" "Groovy")
    (".mustache" "HTML+Django")
    (".erb" "HTML+ERB")
    (".phtml" "HTML+PHP")
    (".hx" "HaXe")
    (".haml" "Haml")
    (".ini" "INI")
    (".weechatlog" "IRC log")
    (".io" "Io")
    (".jsp" "Java Server Pages")
    (".ll" "LLVM")
    (".lhs" "Literate Haskell")
    (".mak" "Makefile")
    (".mao" "Mako")
    (".mkd" "Markdown")
    (".matlab" "Matlab")
    (".mxt" "Max/MSP")
    (".md" "MiniD")
    (".moo" "Moocode")
    (".myt" "Myghty")
    (".numpy" "NumPy")
    (".objdump" "ObjDump")
    (".j" "Objective-J")
    (".pir" "Parrot Internal Representation")
    (".pd" "Pure Data")
    (".pytb" "Python traceback")
    (".r" "R")
    (".rhtml" "RHTML")
    (".rkt" "Racket")
    (".raw" "Raw token data")
    (".rebol" "Rebol")
    (".cw" "Redcode")
    (".sass" "Sass")
    (".self" "Self")
    (".sh" "Shell" ed::shell-mode)
    (".st" "Smalltalk")
    (".tpl" "Smarty")
    (".sc" "SuperCollider")
    (".tcl" "Tcl")
    (".tcsh" "Tcsh")
    (".txt" "Text")
    (".textile" "Textile")
    (".vhdl" "VHDL")
    (".vala" "Vala")
    (".v" "Verilog")
    (".vim" "VimL")
    (".bas" "Visual Basic" basic-mode)
    (".yml" "YAML")
    (".mu" "mupad")
    (".ooc" "ooc")
    (".rst" "reStructuredText")))

(defun gist-filetype-exts ()
  (mapcar #'car *gist-filetype-list*))

(defun gist-filetype-names ()
  (mapcar #'cadr *gist-filetype-list*))

(defun guess-gist-filetype (buffer)
  (or (get-gist-filetype-by-mode (buffer-local-value buffer 'buffer-mode))
      (get-gist-filetype-by-name (get-buffer-file-name buffer))))

(defun get-gist-filetype-by-mode (mode)
  (when mode
    (check-type mode symbol)
    (let* ((name (string mode))
           (guess-lang (reduce #'(lambda (name noise)
                                   (when (atom noise)
                                     (setf noise (list noise "")))
                                   (substitute-string name (car noise) (cadr noise) :case-fold t))
                               '("inferior" "interaction" "mode" "minor"
                                 "^-+\\|-+$"
                                 ("\\([^\\+]\\)\\+$" "\\1") ;; html+-mode や css+-mode
                                 )
                               :initial-value name)))
      (or (get-gist-filetype-by name mode)
          (get-gist-filetype-by guess-lang mode)))))

(defun get-gist-filetype-by-name (name)
  (when name
    (check-type name string)
    (let ((ext (pathname-type name)))
      (when ext
        (get-gist-filetype-by (format nil ".~A" ext) name)))))

(defun get-gist-filetype-by-lang (lang)
  (when lang
    (get-gist-filetype-by lang lang)))

(defun get-gist-filetype-by (lang-or-ext arg)
  (when lang-or-ext
    (multiple-value-bind (filetype candidates)
        (find-gist-filetype lang-or-ext)
      (cond (filetype
             filetype)
            ((= 1 (length candidates))
             ;; あいまいマッチの結果候補が 1 つならそれを返す
             (car candidates))
            (candidates
             (error "ファイルタイプがあいまいです: ~A~%~{~S~%~}" arg candidates))
            (t
             nil)))))

(defun find-gist-filetype (lang-or-ext)
  (let* ((name (string lang-or-ext))
         (.name (format nil ".~A" lang-or-ext))
         (/name/ (regexp-quote name))
         exact candidates)
    (dolist (type *gist-filetype-list*)
      (cond ((or (string-equal (car type) .name)
                 (member name type :test #'string-equal :key #'string))
             ;; 正確なマッチ
             (setf exact type))
            ((member name type :test #'string-matchp :key #'string)
             ;; あいまいマッチ
             (push type candidates))))
    (values exact candidates)))


(provide "github/api/gist-filetype")

;;; End
