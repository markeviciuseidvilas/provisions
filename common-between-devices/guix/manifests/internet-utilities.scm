;;; SPDX-License-Identifier: GPL-3.0-or-later
;;; Copyright © 2025 Eidvilas Markevičius <markeviciuseidvilas@gmail.com>

(use-modules (guix transformations))

(specifications->manifest
  '("iproute2"
    "iputils"
    "inetutils"
    "curl"
    "wget"
    "yt-dlp"
    "aria2"
    "lgogdownloader"
    "transmission"
    "transmission:gui"
    "rsync"
    "openssh"
    "drawterm"
    "gfeeds"
    "openfortivpn"))
