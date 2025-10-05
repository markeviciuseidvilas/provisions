;;; SPDX-License-Identifier: GPL-3.0-or-later
;;; Copyright © 2025 Eidvilas Markevičius <markeviciuseidvilas@gmail.com>

(use-modules (gnu system file-systems)
             (markeviciuseidvilas systems common))

(operating-system
  (inherit %common-system)
  (host-name "lenovo-thinkpad-t430")
  (file-systems
    (append %base-file-systems
      (list
        (file-system
          (mount-point "/boot/efi")
          (device (uuid "F206-C40F" 'fat))
          (type "vfat"))
        (file-system
          (mount-point "/")
          (device (uuid "f566bbb7-a718-4498-bb7f-006ae0425186" 'ext4))
          (type "ext4"))))))
