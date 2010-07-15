; -*- mode: lisp; package: github -*-

;;; github/api/gist.l
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
  (mc-require "github/api/base")
  )

(in-package :github)


;; ## Gist API ##

; API for the [Gist](http://gist.github.com) code paste
; service. Gist's API is a bit different from GitHub proper's - the
; domain is always **gist.github.com** and we're still on **v1**.

;;; ### Get a Gist's Metadata ###

;     GET http://gist.github.com/api/v1/:format/:gist_id

; Example:

;     $ curl http://gist.github.com/api/v1/yaml/374130
;     ---
;     gists:
;     - :description: List what ports are in use on OS X
;       :repo: "374130"
;       :public: true
;       :created_at: 2010-04-21 10:24:32 -07:00
;       :files: ["ports.sh"]

;;; ### Get a Gist's Content ###

;     GET http://gist.github.com/raw/:gist_id/:filename

; Example:

;     $ curl http://gist.github.com/raw/374130/ports.sh
;     # List what ports are in use on OS X
;     sudo lsof -iTCP -sTCP:LISTEN -P

;;; ### Another User's Public Gists ###

;     GET http://gist.github.com/api/v1/:format/gists/:login

; Example:

;     $ curl http://gist.github.com/api/v1/yaml/gists/defunkt
;     ---
;     gists:
;     - :description: List what ports are in use on OS X
;       :repo: "374130"
;       :public: true
;       :created_at: 2010-04-21 10:24:32 -07:00
;     - :description: A list of Gist clients.
;       :repo: "370230"
;       :public: true
;       :created_at: 2010-04-18 07:09:27 -07:00
;     - :description: Awesome option parsing.
;       :repo: "359895"
;       :public: true
;       :created_at: 2010-04-08 01:09:29 -07:00

;;; ### My Public & Private Gists ###

; Coming soon

;;; ### Create a New Gist ###

; Coming soon.

;;; ### Fork a Gist ###

; Coming soon.

;;; ### Delete a Gist ###

; Coming soon.

;;; ### Edit a Gist ###

; Coming soon.


(provide "github/api/gist")

;;; End
