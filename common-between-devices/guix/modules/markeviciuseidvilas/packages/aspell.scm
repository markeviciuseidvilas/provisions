;;; SPDX-License-Identifier: GPL-3.0-or-later
;;; Copyright © 2025 Eidvilas Markevičius <markeviciuseidvilas@gmail.com>

(define-module (markeviciuseidvilas packages aspell)
  #:use-module (guix download)
  #:use-module (guix packages))

(define aspell-dictionary
  (@@ (gnu packages aspell) aspell-dictionary))

(define-public aspell-dict-lt-1.2.1-0
  (aspell-dictionary "lt" "Lithuanian"
    #:version "1.2.1-0"
    #:prefix "aspell6-"
    #:sha256 (base32 "1asjck911l96q26zj36lmz0jp4b6pivvrf3h38zgc8lc85p3pxgn")))

(define-public aspell-dict-lt-1.3.2
  (let ((dict-name "lt")
        (full-name "Lithuanian")
        (version "1.3.2")
        (prefix "aspell6-")
        (sha256
         (base32 "0px5w2x78mwl1qjh8y8kj69lrmb1nr2v4pzxfspmi6w2q8m2w0vh")))
    (package
      (inherit (aspell-dictionary dict-name full-name
                 #:version version
                 #:prefix prefix
                 #:sha256 sha256))
      (source
        (origin
          (method url-fetch)
          (uri (string-append "https://github.com/ispell-lt/ispell-lt/"
                              "releases/download/rel-" version "/"
                              prefix dict-name "-" version ".tar.bz2"))
          (hash (content-hash sha256)))))))
