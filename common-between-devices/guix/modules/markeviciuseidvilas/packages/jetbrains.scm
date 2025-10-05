;;; SPDX-License-Identifier: GPL-3.0-or-later
;;; Copyright © 2025 Eidvilas Markevičius <markeviciuseidvilas@gmail.com>

(define-module (markeviciuseidvilas packages jetbrains)
  #:use-module (gnu packages java)
  #:use-module (guix build-system copy)
  #:use-module (guix download)
  #:use-module (guix packages))

(define-public intellij-idea-community
  (package
    (name "intellij-idea-community")
    (version "2023.2.2")
    (source
      (origin
        (method url-fetch)
        (uri "https://download.jetbrains.com/idea/ideaIC-2023.2.2.tar.gz")
        (sha256 (base32 "09mxfzy4hxm4hzj0d57aqr6xbkab5vf67r3j200v69sf74vp2r6g"))))
    (inputs (list (list openjdk "jdk")))
    (build-system copy-build-system)
    (arguments
      '(#:phases
        (modify-phases %standard-phases
          (add-after 'install 'install-wrapper
            (lambda* (#:key inputs outputs #:allow-other-keys)
              (let ((openjdk (assoc-ref inputs "openjdk"))
                    (out (assoc-ref outputs "out")))
                (mkdir-p (string-append out "/bin"))
                (call-with-output-file (string-append out "/bin/intellij-idea-community")
                  (lambda (port)
                    (display
                      (string-append
                        "#!/bin/sh\n\n"
                        "export IDEA_JDK=" openjdk "\n"
                        out "/opt/intellij-idea-community/bin/idea.sh \"$@\"\n")
                      port)))
                (chmod (string-append out "/bin/intellij-idea-community") #o555))))
            (add-after 'install-wrapper 'install-desktop-entry
              (lambda* (#:key outputs #:allow-other-keys)
                (let ((out (assoc-ref outputs "out")))
                  (make-desktop-entry-file
                    (string-append out "/share/applications/intellij-idea-community.desktop")
                    #:name "Intellij IDEA Community Edition"
                    #:icon (string-append out "/opt/intellij-idea-community/bin/idea.png")
                    #:exec (string-append out "/bin/intellij-idea-community")
                    #:categories '("Application" "Development" "IDE"))))))
        #:install-plan '(("." "opt/intellij-idea-community"))))
    (supported-systems '("x86_64-linux"))
    (home-page #f)
    (synopsis #f)
    (description #f)
    (license #f)))
