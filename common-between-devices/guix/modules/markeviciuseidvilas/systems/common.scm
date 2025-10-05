;;; SPDX-License-Identifier: GPL-3.0-or-later
;;; Copyright © 2025 Eidvilas Markevičius <markeviciuseidvilas@gmail.com>

(define-module (markeviciuseidvilas systems common)
  #:use-module (gnu bootloader)
  #:use-module (gnu bootloader grub)
  #:use-module (gnu packages)
  #:use-module (gnu services)
  #:use-module (gnu services base)
  #:use-module (gnu services desktop)
  #:use-module (gnu services dns)
  #:use-module (gnu services networking)
  #:use-module (gnu system)
  #:use-module (gnu system file-systems)
  #:use-module (gnu system keyboard)
  #:use-module (gnu system locale)
  #:use-module (gnu system shadow)
  #:use-module (guix gexp)
  #:use-module (nongnu packages linux))

(define-public %common-system
  (operating-system
    (host-name "guix")
    (file-systems %base-file-systems)
    (kernel linux)
    (firmware (list linux-firmware))
    (bootloader
      (bootloader-configuration
        (bootloader grub-efi-bootloader)
        (targets '("/boot/efi"))))
    (timezone "Europe/Vilnius")
    (locale "lt_LT.utf8")
    (locale-definitions
      (append %default-locale-definitions
        (list
          (locale-definition
            (name "lt_LT.utf8")
            (source "lt_LT")
            (charset "UTF-8")))))
    (keyboard-layout (keyboard-layout "us"))
    (users
      (append %base-user-accounts
        (list
          (user-account
            (name "eidmar")
            (group "users")
            (supplementary-groups '("wheel" "netdev" "audio" "video" "kvm"))
            (home-directory "/home/eidmar")
            (shell (file-append (specification->package "bash") "/bin/bash"))))))
    (skeletons '())
    (packages
      (map (compose list specification->package+output)
        '("nss-certs"
          "kmod")))
    (services
      (append
        (modify-services %desktop-services
          (delete guix-service-type)
          (delete network-manager-service-type)
          (delete special-files-service-type))
        (list
          (service special-files-service-type
            `(("/bin/guile" ,(file-append (specification->package "guile") "/bin/guile"))
              ("/bin/bash" ,(file-append (specification->package "bash") "/bin/bash"))
              ("/bin/env" ,(file-append (specification->package "coreutils") "/bin/env"))
              ("/bin/sh" ,(file-append (specification->package "bash") "/bin/sh"))))
          (service guix-service-type
            (guix-configuration
              (substitute-urls
                (append %default-substitute-urls
                  (list "https://substitutes.nonguix.org" "https://guix.bordeaux.inria.fr")))
              (authorized-keys
                (append %default-authorized-guix-keys
                  (list
                    (plain-file "substitutes.nonguix.org.pub"
                      (string-append
                        "(public-key"
                        " (ecc"
                        "  (curve Ed25519)"
                        "  (q #C1FD53E5D4CE971933EC50C9F307AE2171A2D3B52C804642A7A35F84F3A4EA98#)))"))
                    (plain-file "guix.bordeaux.inria.fr.pub"
                      (string-append
                        "(public-key"
                        " (ecc"
                        "  (curve Ed25519)"
                        "  (q #89FBA276A976A8DE2A69774771A92C8C879E0F24614AAAAE23119608707B3F06#)))")))))))
          (service gnome-desktop-service-type)
          (service bluetooth-service-type)
          (service network-manager-service-type
            (network-manager-configuration
              (dns "none")))
          (service dnsmasq-service-type
            (dnsmasq-configuration
              (cache-size 0)
              (no-resolv? #t)
              (query-servers-in-order? #t)
              (servers '("1.1.1.2"))))
          (simple-service 'resolv-service etc-service-type
            `(("resolv.conf" ,(plain-file "resolv.conf" "nameserver=127.0.0.1")))))))))
