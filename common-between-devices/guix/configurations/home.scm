;;; SPDX-License-Identifier: GPL-3.0-or-later
;;; Copyright © 2025 Eidvilas Markevičius <markeviciuseidvilas@gmail.com>

(use-modules (gnu home services)
             (gnu home services desktop)
             (gnu home services shells)
             (gnu home services sound)
             (gnu home services syncthing)
             (gnu home services xdg)
             (gnu home-services version-control)
             (gnu services)
             (guix download)
             (guix gexp)
             (guix packages)
             (json))

(define %xdg-config-home
  (string-append (getenv "HOME") "/.config"))

(define %current-directory
  (dirname (current-filename)))

(define %confidential-data
  (call-with-input-file (string-append %current-directory "/home/confidential-data.scm")
    read))

(define %emacs-init
  (load (string-append %current-directory "/home/emacs-init.scm")))

(define %qutebrowser-bookmarks
  (load (string-append %current-directory "/home/qutebrowser-bookmarks.scm")))

(home-environment
  (services
    (list
      (service home-bash-service-type
        (home-bash-configuration
          (guix-defaults? #f)
          (environment-variables
            '(("PAGER" . "cat")
              ("PATH" . "$HOME/Vykdomosios:$PATH")
              ("EDITOR" . "emacsclient")
              ("GSK_RENDERER" . "ngl")
              ("ALTERNATE_EDITOR" . "")
              ("HISTFILE" . "/dev/null")
              ("TESSDATA_PREFIX" . "/run/current-system/profile/share/tessdata")))
          (aliases
            '(("ls" . "ls -A -F -N -h -v --tabsize=0 --time-style=long-iso")
              ("ll" . "ls -l")
              ("cp" . "cp -i -v")
              ("mv" . "mv -i -v")
              ("rm" . "rm -I -v")
              ("rmdir" . "rmdir -v")
              ("chmod" . "chmod -c")))
          (bashrc (list (plain-file "bashrc" "PS1=\"$(tput setaf 2)⩩$(tput sgr0) \"")))))

      (service home-xdg-configuration-files-service-type
        `(("emacs/init.el"
           ,(plain-file "emacs-init.el" %emacs-init))

          ("git/credentials"
           ,(plain-file "git-credentials"
              (format #f (string-join '("https://~a:~a@gitlab.com" "https://~a:~a@github.com") "\n")
                (assoc-ref %confidential-data "gitlab.com:username")
                (assoc-ref %confidential-data "gitlab.com:password")
                (assoc-ref %confidential-data "github.com:username")
                (assoc-ref %confidential-data "github.com:personal-access-tokens:token1"))))

          ("guix-gaming-channels/games.scm"
           ,(plain-file "gaming-config.scm"
              (format #f "~s"
                `(make-gaming-config
                   '((gog ((email ,(assoc-ref %confidential-data "gog.com:email"))
                           (password ,(assoc-ref %confidential-data
                                        "gog.com:password")))))))))

          ("qutebrowser/config.py"
           ,(plain-file "qutebrowser-config.py"
              (string-join
                '("config.load_autoconfig(False)"
                  "config.set('window.title_format', 'qutebrowser')"
                  "config.set('completion.web_history.max_items', 0)"
                  "config.set('content.fullscreen.window', True)"
                  "config.set('url.searchengines', {'DEFAULT': 'https://google.com/search?q={}'})"
                  "config.set('url.start_pages', 'https://google.com')")
                "\n")))

          ("qutebrowser/greasemonkey/youtube-mute-and-skip-ads.js"
           ,(origin
              (method url-fetch)
              (uri "https://update.greasyfork.org/scripts/461341/1458801/YouTube%20Mute%20and%20Skip%20Ads.user.js")
              (file-name "youtube-mute-and-skip-ads.js")
              (sha256 (base32 "1j3pfkgkw6c0qialg57y5xf5qjqp9k1a52qfmbnk9b7mg22j8m06"))))

          ("yt-dlp/config"
           ,(plain-file "yt-dlp-config" "--no-mtime"))))

      (service home-xdg-user-directories-service-type
        (home-xdg-user-directories-configuration
          (desktop "$HOME")
          (documents "$HOME/Dokumentai")
          (download "$HOME/Atsisiuntimai")
          (music "$HOME/Garso įrašai")
          (pictures "$HOME/Atvaizdai")
          (publicshare "")
          (templates "$HOME/Šablonai")
          (videos "$HOME/Vaizdo įrašai")))

      (service home-git-service-type
        (home-git-configuration
          (config `((user ((name . "Eidvilas Markevičius")
                           (email . "markeviciuseidvilas@gmail.com")))
                    (sendemail ((smtpserver . "smtp.gmail.com")
                                (smtpuser . "markeviciuseidvilas@gmail.com")
                                (smtpencryption . "ssl")
                                (smtpserverport . 465)
                                (smtpPass . ,(assoc-ref %confidential-data
                                               "gmail.com:password:git-send-email"))))
                    (credential ((helper . "store")))
                    (core ((quotePath . #f)))))))

      (service home-dbus-service-type)
      (service home-pipewire-service-type)
      ;;(service home-syncthing-service-type)

      (simple-service 'qutebrowser-bookmarks home-activation-service-type
        `(begin
           (mkdir-p (string-append ,%xdg-config-home "/qutebrowser/bookmarks"))
           (call-with-output-file (string-append ,%xdg-config-home "/qutebrowser/bookmarks/urls")
             (lambda (port)
               (display ,%qutebrowser-bookmarks port))))))))
