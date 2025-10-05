;;; SPDX-License-Identifier: GPL-3.0-or-later
;;; Copyright © 2025 Eidvilas Markevičius <markeviciuseidvilas@gmail.com>

(define-module (markeviciuseidvilas packages python-xyz)
  #:use-module (gnu packages base)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages python)
  #:use-module (guix download)
  #:use-module (guix packages)
  #:use-module (guix utils)
  #:use-module (nonguix build-system binary))

(define-public python-adblock
  (package
    (name "python-adblock")
    (version "0.6.0")
    (source
      (origin
        (method url-fetch)
        (uri (string-append
               "https://github.com/ArniDagur/python-adblock/releases/download/"
               version
               "/adblock-"
               version
               "-cp37-abi3-manylinux_2_12_x86_64.manylinux2010_x86_64.whl"))
        (sha256 (base32 "1sg76v5kj4gng4c2qc64mk6hcl4v29gqfllvhih72xr5393fbvhp"))))
    (native-inputs (list unzip))
    (inputs (list (list gcc "lib") glibc))
    (build-system binary-build-system)
    (arguments
      `(#:phases
        (modify-phases %standard-phases
          (replace 'unpack
            (lambda* (#:key source #:allow-other-keys)
              (invoke "unzip" source))))
        #:patchelf-plan
        '(("adblock/adblock.abi3.so" ("gcc" "glibc")))
        #:install-plan
        (let ((python-site-packages-directory-path
                (string-append
                  "lib/python"
                  ,(version-major+minor
                     (package-version python))
                  "/site-packages/")))
          `(("adblock" ,python-site-packages-directory-path)
            ("adblock-0.6.0.dist-info" ,python-site-packages-directory-path)))))
    (supported-systems '("x86_64-linux"))
    (home-page #f)
    (synopsis #f)
    (description #f)
    (license #f)))
