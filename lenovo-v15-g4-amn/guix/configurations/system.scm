;;; SPDX-License-Identifier: GPL-3.0-or-later
;;; Copyright © 2025 Eidvilas Markevičius <markeviciuseidvilas@gmail.com>

(use-modules (gnu system file-systems)
             (markeviciuseidvilas systems common))

(operating-system
  (inherit %common-system)
  (host-name "lenovo-v15-g4-amn")
  (file-systems
    (append %base-file-systems
      (list
        (file-system
          (mount-point "/boot/efi")
          (device (uuid "8EF1-7EE4" 'fat))
          (type "vfat"))
        (file-system
          (mount-point "/")
          (device (uuid "bd08d290-c73d-4bf1-8a03-0f518280a138" 'ext4))
          (type "ext4"))))))
