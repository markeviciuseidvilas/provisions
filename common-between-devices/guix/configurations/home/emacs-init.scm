;;; SPDX-License-Identifier: GPL-3.0-or-later
;;; Copyright © 2025 Eidvilas Markevičius <markeviciuseidvilas@gmail.com>

(string-join
  (map (lambda (sexp) (format #f "~s" sexp))
    '((setq message-log-max nil)
      (setq frame-title-format "emacs")
      (setq icon-title-format "emacs")
      (setq create-lockfiles nil)
      (setq scroll-step 1)
      (setq-default cursor-type 'bar)
      (setq-default tab-width 2)

      (setq messages-buffer-max-lines nil)

      (setq auto-save-list-file-prefix nil)
      (setq initial-major-mode 'fundamental-mode)

      (use-package simple
        :config
        (setq backward-delete-char-untabify-method nil)
        (setq-default indent-tabs-mode nil)
        (column-number-mode 1))

      (use-package comint
        :config
        (setq comint-prompt-read-only t))

      (use-package eglot
        :config
        (setq eglot-autoreconnect nil)
        (setq eglot-sync-connect 0)
        (add-to-list 'eglot-server-programs
          '(csharp-mode . ("omnisharp-wrapper" "-lsp"))))

      (use-package csharp-mode
        :config
        (define-key csharp-mode-map (kbd "TAB") 'completion-at-point))

      (use-package faces
        :config
        (set-face-attribute 'default nil :height 100))

      (use-package which-key
        :config
        (which-key-mode 1))

      (use-package files
        :config
        (setq auto-save-default nil)
        (setq auto-mode-alist
          '(("\\.c\\'" . c-mode)
            ("\\.cpp\\'" . c++-mode)
            ("\\.el\\'" . emacs-lisp-mode)
            ("\\.org\\'" . org-mode)
            ("\\.py\\'" . python-mode)
            ("\\.scm\\'" . scheme-mode)
            ("\\.xml\\'" . xml-mode)
            ("\\.cs\\'" . csharp-mode)))
        (setq magic-mode-alist nil)
        (setq magic-fallback-mode-alist nil)
        (setq make-backup-files nil)
        (setq require-final-newline t))

      (use-package tool-bar
        :config
        (tool-bar-mode 0))

      (use-package custom
        :config
        (load-theme 'modus-operandi))

      (use-package scroll-bar
        :config
        (scroll-bar-mode 0))

      (use-package menu-bar
        :config
        (menu-bar-mode 0))

      (use-package frame
        :config
        (blink-cursor-mode 0))

      (use-package paren
        :config
        (show-paren-mode 1))

      (use-package hl-line
        :config
        (global-hl-line-mode 0))

      (use-package vertico
        :config
        (setq vertico-cycle t)
        (setq vertico-sort-function 'vertico-sort-alpha)
        (vertico-mode 1))

      (use-package minibuffer
        :config
        (setq completion-in-region-function 'consult-completion-in-region)
        (setq completion-styles '(orderless)))

      (use-package delsel
        :config
        (delete-selection-mode 1))

      (use-package electric
        :config
        (electric-indent-mode 0))

      (use-package marginalia
        :config
        (marginalia-mode 1))

      (use-package shr
        :config
        (setq shr-cookie-policy nil))

      (use-package whitespace
        :config
        (setq whitespace-style '(face tabs))
        (set-face-background 'whitespace-tab "#0F0F0F")
        (global-whitespace-mode 1))

      (use-package wid-edit
        :config
        (setq widget-global-map (make-sparse-keymap)))

      (use-package jinx
        :config
        (setq global-jinx-modes '(text-mode))
        (global-jinx-mode))

      (use-package dired
        :config
        (setq dired-listing-switches "-Fahvl")))))
