; -*- mode: lisp; package: github -*-

;;; github/api/network.l
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

(export '(get-network-meta
          get-network-data
          ))

;; ## Secret Network API ##

; This API is sort of an outlier.  It is only available in JSON and does not follow the rest of the routing rules.  It is the API used by our Network Graph and provides a lot of useful information that may be useful.

;;; ### Network Meta ###

(defun get-network-meta (owner/repo &key callback nomsg)
  (let ((*github-api-endpoint* *github-domain*))
    (multiple-value-bind (user repo)
        (coerce-owner-and-repo owner/repo)
      (github-get ":user/:repo/network_meta"
                  :uri-params (list user repo)
                  :return-type '(:root nil :object t :list nil :type network)
                  :callback callback :nomsg nomsg))))

; 	$ curl http://github.com/schacon/simplegit/network_meta | jsonpretty
; 	{
; 	  "focus": 78,
; 	  "nethash": "fa8fe264b926cdebaab36420b6501bd74402a6ff",
; 	  "dates": [
; 	    "2008-03-15",
; 	    "2008-03-15",
; 	    "2008-03-17",
; 	    "2008-03-17",
; 	    ...
; 	    "2009-02-15",
; 	    "2009-02-15",
; 	    "2009-03-19"
; 	  ],
; 	  "users": [
; 	    {
; 	      "name": "schacon",
; 	      "repo": "simplegit",
; 	      "heads": [ { "name": "master",
; 	       "id": "96476742093b8a53947564b16a691349dad846e5" } ]
; 	    },
; 	    {
; 	      "name": "tamtam",
; 	      "repo": "tam_repo",
; 	      "heads": [ { "name": "master",
; 	 	  "id": "8bf4aeae935422e7bdbb30660b4f3642728a1397" } ]
; 	    }
; 	  ],
; 	  "blocks": [
; 	    { "name": "schacon", "start": 0, "count": 3 },
; 	    { "name": "tamtam", "start": 3,  "count": 1 },
; 	  ]
; 	}

;;; ### Network Data ###

(defun get-network-data (owner/repo nethash &key start end callback nomsg)
  (let ((*github-api-endpoint* *github-domain*))
    (multiple-value-bind (user repo)
        (coerce-owner-and-repo owner/repo)
      (check-type nethash string)
      (github-get ":user/:repo/network_data_chunk"
                  :uri-params (list user repo)
                  :query-params `((:nethash . ,nethash)
                                  (:start . ,start)
                                  (:end . ,end))
                  :callback callback :nomsg nomsg))))

; To get network data, you'll need to provide the 'nethash' parameter that you get from the network\_meta call so the data is always consistent.  To get network data, call the network\_data\_chunk URI with the given nethash to get the first 100 commits by branch.

; 	$ curl http://github.com/schacon/simplegit/network_data_chunk?nethash=fa8fe264b926cdebaab36420b6501bd74402a6ff
; 	{"commits"=>
; 	  [{"message"=>"first commit",
; 	    "time"=>0,
; 	    "parents"=>[],
; 	    "date"=>"2008-03-15 10:31:28",
; 	    "author"=>"Scott Chacon",
; 	    "id"=>"a11bef06a3f659402fe7563abf99ad00de2209e6",
; 	    "space"=>1,
; 	    "gravatar"=>"9375a9529679f1b42b567a640d775e7d",
; 	    "login"=>"schacon"},
; 	   {"message"=>"my second commit, which is better than the first",
; 	    "time"=>1,
; 	    "parents"=>[["a11bef06a3f659402fe7563abf99ad00de2209e6", 0, 1]],
; 	    "date"=>"2008-03-15 16:40:33",
; 	    "author"=>"Scott Chacon",
; 	    "id"=>"0576fac355dd17e39fd2671b010e36299f713b4d",
; 	    "space"=>1,
; 	    "gravatar"=>"9375a9529679f1b42b567a640d775e7d",
; 	    "login"=>"schacon"},
; 		.. (bunch more) ..

; You can also give it a start and end range, based on the position of the dates in the network\_meta output.  This is how the network graph operates, requesting the chunks that you want to view at a time rather than all the data.  If you need more than the last 100, you'll need to request ranges of more data.

; 		$ curl 'http://github.com/schacon/simplegit/network_data_chunk?
; 			nethash=fa8fe264b926cdebaab36420b6501bd74402a6ff&start=1&end=2'
; 		{
; 		  "commits": [
; 		    {
; 		      "message": "my second commit, which is better than the first",
; 		      "time": 1,
; 		      "parents": [
; 		        [
; 		          "a11bef06a3f659402fe7563abf99ad00de2209e6",
; 		          0,
; 		          1
; 		        ]
; 		      ],
; 		      "date": "2008-03-15 16:40:33",
; 		      "author": "Scott Chacon",
; 		      "id": "0576fac355dd17e39fd2671b010e36299f713b4d",
; 		      "space": 1,
; 		      "gravatar": "9375a9529679f1b42b567a640d775e7d",
; 		      "login": "schacon"
; 		    },
; 		    {
; 		      "message": "changed the verison number",
; 		      "time": 2,
; 		      "parents": [
; 		        [
; 		          "0576fac355dd17e39fd2671b010e36299f713b4d",
; 		          1,
; 		          1
; 		        ]
; 		      ],
; 		      "date": "2008-03-17 21:52:11",
; 		      "author": "Scott Chacon",
; 		      "id": "0c8a9ec46029a4e92a428cb98c9693f09f69a3ff",
; 		      "space": 1,
; 		      "gravatar": "9375a9529679f1b42b567a640d775e7d",
; 		      "login": "schacon"
; 		    }
; 		  ]
; 		}



(provide "github/api/network")

;;; End
