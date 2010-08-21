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
          *gist-filetype-alist*
          ))

(defvar *gist-default-filetype* ".txt")

(defvar *gist-filetype-alist*
  '((".txt" . "Plain Text")
    (".as" . "ActionScript")
    (".c" . "C")
    (".cs" . "C#")
    (".cpp" . "C++")
    (".css" . "CSS")
    (".cl" . "Common Lisp")
    (".diff" . "Diff")
    (".hrl" . "Erlang")
    (".html" . "HTML")
    (".hs" . "Haskell")
    (".java" . "Java")
    (".js" . "JavaScript")
    (".lua" . "Lua")
    (".m" . "Objective-C")
    (".php" . "PHP")
    (".pl" . "Perl")
    (".py" . "Python")
    (".rb" . "Ruby")
    (".sql" . "SQL")
    (".scala" . "Scala")
    (".sls" . "Scheme")
    (".tex" . "TeX")
    (".xml" . "XML")
    (".ascx" . "ASP")
    (".scpt" . "AppleScript")
    (".arc" . "Arc")
    (".asm" . "Assembly")
    (".bat" . "Batchfile")
    (".befunge" . "Befunge")
    (".boo" . "Boo")
    (".b" . "Brainfuck")
    (".c-objdump" . "C-ObjDump")
    (".clj" . "Clojure")
    (".coffee" . "CoffeeScript")
    (".cfm" . "ColdFusion")
    (".cppobjdump" . "Cpp-ObjDump")
    (".feature" . "Cucumber")
    (".d" . "D")
    (".d  -objdump" . "D-ObjDump")
    (".darcspatch" . "Darcs Patch")
    (".pas" . "Delphi")
    (".dylan" . "Dylan")
    (".e" . "Eiffel")
    (".fs" . "F#")
    (".f" . "FORTRAN")
    (".s" . "GAS")
    (".kid" . "Genshi")
    (".po" . "Gettext Catalog")
    (".go" . "Go")
    (".man" . "Groff")
    (".groovy" . "Groovy")
    (".mustache" . "HTML+Django")
    (".erb" . "HTML+ERB")
    (".phtml" . "HTML+PHP")
    (".hx" . "HaXe")
    (".haml" . "Haml")
    (".ini" . "INI")
    (".weechatlog" . "IRC log")
    (".io" . "Io")
    (".jsp" . "Java Server Pages")
    (".ll" . "LLVM")
    (".lhs" . "Literate Haskell")
    (".mak" . "Makefile")
    (".mao" . "Mako")
    (".mkd" . "Markdown")
    (".matlab" . "Matlab")
    (".mxt" . "Max/MSP")
    (".md" . "MiniD")
    (".moo" . "Moocode")
    (".myt" . "Myghty")
    (".numpy" . "NumPy")
    (".objdump" . "ObjDump")
    (".j" . "Objective-J")
    (".pir" . "Parrot Internal Representation")
    (".pd" . "Pure Data")
    (".pytb" . "Python traceback")
    (".r" . "R")
    (".rhtml" . "RHTML")
    (".rkt" . "Racket")
    (".raw" . "Raw token data")
    (".rebol" . "Rebol")
    (".cw" . "Redcode")
    (".sass" . "Sass")
    (".self" . "Self")
    (".sh" . "Shell")
    (".st" . "Smalltalk")
    (".tpl" . "Smarty")
    (".sc" . "SuperCollider")
    (".tcl" . "Tcl")
    (".tcsh" . "Tcsh")
    (".txt" . "Text")
    (".textile" . "Textile")
    (".vhdl" . "VHDL")
    (".vala" . "Vala")
    (".v" . "Verilog")
    (".vim" . "VimL")
    (".bas" . "Visual Basic")
    (".yml" . "YAML")
    (".mu" . "mupad")
    (".ooc" . "ooc")
    (".rst" . "reStructuredText")))

(defun get-gist-filetype-by-name (name)
  (let ((ext (pathname-type name)))
    (when ext
      (get-gist-filetype-by (format nil ".~A" ext) name))))

(defun get-gist-filetype-by-lang (lang)
  (get-gist-filetype-by lang lang))

(defun get-gist-filetype-by (lang-or-ext arg)
  (when lang-or-ext
    (multiple-value-bind (filetype candidates)
        (find-gist-filetype lang-or-ext)
      (cond (filetype
             (car filetype))
            ((= 1 (length candidates))
             ;; あいまいマッチの結果候補が 1 つならそれを返す
             (caar candidates))
            (candidates
             (error "ファイルタイプがあいまいです: ~A~%~{~S~%~}" arg candidates))
            (t
             (warn "ファイルタイプが不明なため txt として扱います: ~A" arg))))))

(defun find-gist-filetype (lang-or-ext)
  (let* ((name (string lang-or-ext))
         (.name (format nil ".~A" lang-or-ext))
         (/name/ (regexp-quote name))
         exact candidates)
    (dolist (type *gist-filetype-alist*)
      (cond ((or (string-equal (car type) name)
                 (string-equal (cdr type) name)
                 (string-equal (car type) .name))
             ;; 正確なマッチ
             (setf exact type))
            ((or (string-matchp /name/ (cdr type))
                 (string-matchp /name/ (cdr type)))
             ;; あいまいマッチ
             (push type candidates))))
    (values exact candidates)))


(provide "github/api/gist-filetype")

;;; End
