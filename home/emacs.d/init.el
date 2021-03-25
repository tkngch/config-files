;;; init.el --- Emacs configuration file.

;;; Commentary:
;; `C-y M-y M-y M-y ...` goes through kill ring.
;; `M-x rgrep` looks for files containig search word.
;; `M-;` to comment out a section of code.
;; `M-/` to autocomplete with dabbrev.
;; `M-<tab>` to autocomplete at point, typically with lsp.
;; `M-q` to format a paragraph. The column width is determined by 'fill-column.
;; ‘C-q <tab>’ to insert a tab.
;; `M-x revert-buffer` to reload the file.
;; 'C-SPC' to start selection.
;; `M-w` to copy the selected.
;; `C-w` to cut the selected.
;; `C-k` to cut rest of line.
;; `C-x C-s` to save current buffer.
;; `C-x s` to save all buffers.
;; `C-/` to undo. `M-x undo-only`
;; `C-?` to redo. 'M-x undo-redo`
;; `C-x 4 f` to open a file in a new window.
;; `M-@` to select a word.
;; `M-h` to select a paragraph.
;; `M-g g` to go to line.
;; `M-p` and `M-n` to scroll without moving the cursor. (not default. defined below.)
;; https://www.gnu.org/software/emacs/manual/html_node/emacs/Moving-Point.html

;;; Code:

;; Disable the toolbar at the top.
(tool-bar-mode -1)
;; Disable the menubar at the top.
(menu-bar-mode -1)
;; Disable the scrollbar on the side.
(scroll-bar-mode -1)
;; Disable popup on mouse hover on mode-line.
(tooltip-mode -1)
;; Disable the built-in vc-mode for version control
(setq-default vc-handled-backends nil)
;; Disable automatic package loading, for slightly faster startup.
(setq-default package-enable-at-startup nil)
;; Inhibit the startup screen.
(setq inhibit-startup-screen t)
;; Inhibit the buffer list display when more than 2 files are loaded.
(setq inhibit-startup-buffer-menu t)

;; keyboard scroll one line at a time
(setq scroll-step 1)
;; Do not recenter point (cursor) when it moves off screen for smooth scrolling.
(setq scroll-conservatively 101)
;; Let point keep its screen position when scrolling, so that `C-v` `M-v`
;; sequence brings back point where it was.
(setq scroll-preserve-screen-position t)

;; No blinking cursor.
(blink-cursor-mode 0)

;; Highlight maching parens (brackets).
(setq-default show-paren-delay 0.01)
(show-paren-mode 1)

;; Place all auto-saves and backups in the directory.
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;; Do not create a lock file, whose name starts with .#
(setq create-lockfiles nil)

;; Line-wrap at 80 columns.
(setq-default fill-column 80)

;; Use spaces instead of tabs when indenting.
(setq-default indent-tabs-mode nil)

;; Ask for confirmation before killing (C-x C-c) emacs.
(setq confirm-kill-emacs 'yes-or-no-p)

;; Resize the frame pixelwise, to rid of gaps due to size hints.
(setq frame-resize-pixelwise t)

;; If available, use "Source Code Pro" font.
(when (member "Source Code Pro" (font-family-list))
  (set-face-attribute 'default nil :font "Source Code Pro")
  )
(set-face-attribute 'default nil :height 100)

;; Use ibuffer instead of buffer menu
(global-set-key (kbd "C-x C-b") 'ibuffer)
(setq-default ibuffer-formats
              '(
                (;; the default format
                 mark  ;; the current mark if any
                 modified  ;; the modification status
                 read-only  ;; read-only status
                 locked
                 " "  ;; space to separate the elements
                 name
                 ;; (name 70 70 :left :elide)  ;; name of buffer, up to 70 chars.
                 ;; " "
                 ;; (mode 16 16 :left :elide)
                 )
                (;; alternative format. To be toggled with ` key.
                 mark
                 modified
                 read-only
                 locked
                 " "
                 ;; (name 20 20 :left :elide)
                 ;; " "
                 filename-and-process
                 )))

(add-to-list 'auto-mode-alist '("^/tmp/neomutt-" . mail-mode))

;; ========================= COPY & PASTE
;; Use the PRIMARY selection (mouse-selected) *and* the CLIPBOARD selection
;; (copy function selected). When yanking, both will be set. When inserting, the
;; more recently changed one will be used.
(setq select-enable-primary t)
(setq select-enable-clipboard t)

;; ======================== COMPILATION
(require 'compile)
;; Don’t ask to kill currently running compilation, just kill it.
(setq-default compilation-always-kill t)

(defun compile-at-makefile (command)
  "Locate makefile and run COMMAND at the location."
  (interactive
   (let* ((makefile-directory (locate-dominating-file default-directory "makefile"))
          (command (concat "make -k -C " (shell-quote-argument makefile-directory))))
     (list (compilation-read-command command))
     ))
  (compile command))

;; Auto-scroll in the compilation mode, until the first error.
(setq-default compilation-scroll-output "first-error")

(global-set-key (kbd "C-3") 'compile-at-makefile)
(global-set-key (kbd "C-4") 'recompile)


;; ======================== COMPLETION
;; Word completion.
(require 'dabbrev)
;; Do not ignore case in matches and searches.
(setq case-fold-search nil
      dabbrev-case-fold-search nil)

;; Spell-check
(require 'flyspell)
(setq flyspell-issue-message-flag nil
      ispell-local-dictionary "en_GB"
      ispell-program-name "aspell"
      ispell-extra-args '("--sug-mode=ultra"))
(add-hook 'text-mode-hook 'flyspell-mode)
(add-hook 'prog-mode-hook 'flyspell-prog-mode)


;; ---------------- WINDOW NAVIGATION
;; Swith to another window.
(global-set-key (kbd "M-o") 'other-window)


;; ======================== DRAWING
;; automatically revert buffers when files change
(global-auto-revert-mode 1)

;; ;; Show trailing whitespaces.
;; (require 'whitespace)
;; (setq-default whitespace-style '(face trailing tabs))
;; (setq-default show-trailing-whitespace t)
;; (global-whitespace-mode)
;; ;; Don't show whitespaces in certain major modes.
;; (add-hook 'eshell-mode-hook (lambda () (setq show-trailing-whitespace nil)))
;; (add-hook 'term-mode-hook (lambda () (setq show-trailing-whitespace nil)))
;; (add-hook 'compilation-mode-hook (lambda () (setq show-trailing-whitespace nil)))
;; (add-hook 'calendar-mode-hook (lambda () (setq show-trailing-whitespace nil)))

;; Enable the continuous scrolling in the dov-view mode.
(setq-default doc-view-continuous t)


;; ================ PACKAGE CONFIGURATION
;; Load the functions and variables defined in `package`.
(require 'package)
;; Add MELPA to the list of package archives.
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
;; Depending on the versions of emacs and gnutls, the next line needs to be uncommented.
;; See https://emacs.stackexchange.com/a/51772
;; (setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")

;; Load packages explicitly in this init file.
(package-initialize)

;; Install `use-package` for package management/configuration if not
;; installed.
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)

;; ---------------- KEY BINDINGS

;; `M-p` and `M-n` to scroll without moving the cursor.
(global-set-key "\M-n" "\C-u1\C-v")
(global-set-key "\M-p" "\C-u1\M-v")

(use-package undo-tree
  :ensure t
  :config (global-undo-tree-mode))


;; ---------------- EMAIL
(autoload 'notmuch "notmuch" "notmuch mail" t)

;; ---------------- PROGRAMMING SUPPORT

;; Use the completion framework.
;; (use-package company
;;   :ensure t
;;   :config (progn
;;             (global-company-mode 1)
;;             (setq company-idle-delay 0.01)))


(use-package icomplete-vertical
  :ensure t
  :demand t
  :custom
  (completion-styles '(partial-completion substring))
  (completion-category-overrides '((file (styles basic substring))))
  (read-file-name-completion-ignore-case t)
  (read-buffer-completion-ignore-case t)
  (completion-ignore-case t)
  :config
  (icomplete-mode)
  (icomplete-vertical-mode)
  :bind (:map icomplete-minibuffer-map
              ("<down>" . icomplete-forward-completions)
              ("C-n" . icomplete-forward-completions)
              ("<up>" . icomplete-backward-completions)
              ("C-p" . icomplete-backward-completions)
              ("C-v" . icomplete-vertical-toggle)))



;; Whenever the window scrolls a light will shine on top of your cursor so you
;; know where it is.
(use-package beacon
  :ensure t
  :config (beacon-mode 1))

;; (use-package all-the-icons
;;   :ensure t)
;; To install icons, `M-x all-the-icons-install-fonts`.

;; Filename completion.
;; (use-package counsel
;;   :ensure t
;;   :init (progn
;;           (setq ivy-count-format "(%d/%d) ")
;;           (setq ivy-extra-directories ())  ;; Remove ./ and ../ from find-file completion.
;;           (global-set-key (kbd "C-s") 'swiper-isearch)
;;           (global-set-key (kbd "M-x") 'counsel-M-x)
;;           (global-set-key (kbd "C-x C-f") 'counsel-find-file)
;;           (global-set-key (kbd "M-y") 'counsel-yank-pop)
;;           (global-set-key (kbd "<f1> f") 'counsel-describe-function)
;;           (global-set-key (kbd "<f1> v") 'counsel-describe-variable)
;;           (global-set-key (kbd "<f1> l") 'counsel-find-library)
;;           (global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
;;           (global-set-key (kbd "<f2> u") 'counsel-unicode-char)
;;           (global-set-key (kbd "<f2> j") 'counsel-set-variable)
;;           (global-set-key (kbd "C-x b") 'ivy-switch-buffer)
;;           (global-set-key (kbd "C-c v") 'ivy-push-view)
;;           (global-set-key (kbd "C-c V") 'ivy-pop-view)
;;           )
;;   :config (ivy-mode 1))

;; (use-package all-the-icons-ivy
;;   :ensure t
;;   :init (add-hook 'after-init-hook 'all-the-icons-ivy-setup))

;; (use-package all-the-icons-dired
;;   :ensure t
;;   :init (add-hook 'dired-mode-hook 'all-the-icons-dired-mode))

;; (use-package eglot
;;   :ensure t
;;   :init (progn
;;           ;; Disable documentation on hover
;;           (setq eglot-ignored-server-capabilites '(:hoverProvider))
;;           (add-hook 'scala-mode-hook 'eglot-ensure)
;;           (add-hook 'python-mode-hook 'eglot-ensure)))

(use-package lsp-mode
  :ensure t
  :init (progn
          ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
          (setq lsp-keymap-prefix "C-c l")
          ;; Performance tuning for lsp-mode
          (setq gc-cons-threshold 100000000)
          (setq read-process-output-max (* 1024 1024)) ;; 1mb
          (setq lsp-headerline-breadcrumb-enable nil)
          (setq lsp-enable-file-watchers nil)
          (setq lsp-log-io nil) ; if set to true can cause a performance hit
          )
  :hook (
         ;; (python-mode . lsp)
         (scala-mode . lsp)
         )
  :commands lsp)

(use-package lsp-pyright
  :ensure t
  :hook (python-mode . (lambda ()
                         (require 'lsp-pyright)
                         (lsp))))

(use-package lsp-metals
  :ensure t)

;; Use code-linter.
(use-package flycheck
  :ensure t
  ;; :init (global-flycheck-mode)
  ;; flycheck does not work great for some languages (e.g., Scala). So do not enable globally.
  :hook ((python-mode . flycheck-mode)))

(add-hook 'python-mode-hook (lambda() (setq fill-column 88)))

(use-package pyvenv
  :ensure t)

(use-package kotlin-mode
  :ensure t
  :init (add-hook 'kotlin-mode-hook (lambda() (setq fill-column 100))))

(use-package scala-mode
  :ensure t
  :init (add-hook 'scala-mode-hook (lambda() (setq fill-column 100))))

(use-package lua-mode
  :ensure t)

(use-package ess
  :ensure t)

(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)  ;; gfm is for github flavoured markdown
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode)))

(use-package yaml-mode
  :ensure t
  :mode (("\\.yml\\'" . yaml-mode)))

(use-package dockerfile-mode
  :ensure t)

(use-package jinja2-mode
  :ensure t)

;; Use code-formatter. To auto-format on save, we use the minor mode
;; format-all-mode. This minor mode is enabled individually for each major mode.
(use-package format-all
  :ensure t
  :hook ((emacs-lisp-mode . format-all-mode)
         (python-mode . format-all-mode)
         (markdown-mode . format-all-mode)
         (gfm-mode . format-all-mode)
         ))

(use-package magit
  :ensure t
  :bind (("C-x g" . magit-status)))


;; ------------------------ COLORS
;; Color theme

;; Built-in themes are /usr/share/emacs/26.3/etc/themes
;; (load-theme 'adwaita)
;; (load-theme 'deeper-blue)
;; (load-theme 'dichromacy)
;; (load-theme 'leuven)
;; (load-theme 'light-blue)
;; (load-theme 'manoj-dark)
;; (load-theme 'misterioso)
;; (load-theme 'tango-dark)
;; (load-theme 'tango)
;; (load-theme 'tsdh-dark)
;; (load-theme 'tsdh-light)
;; (load-theme 'wheatgrass)
;; (load-theme 'whiteboard)
;; (load-theme 'wombat)

(use-package nord-theme
  :ensure t
  :config (load-theme 'nord t))

;; (setq-default mode-line-format
;;               '(
;;                 "%e"
;;                 mode-line-front-space
;;                 mode-line-client
;;                 mode-line-frame-identification
;;                 (:eval (propertize "%b" 'face 'bold))
;;                 " "
;;                 mode-line-modified
;;                 " "
;;                 "(row: %03l; col: %02C)"
;;                 "   "
;;                 (global-mode-string (#1="" global-mode-string " "))
;;                 (:eval (propertize
;;                         " " 'display
;;                         `((space :align-to (- (+ right right-fringe right-margin)
;;                                               ,(+ 2 (string-width mode-name)))))))
;;                 ;; mode-line-modes
;;                 "%m"
;;                 mode-line-end-spaces
;;                 )
;;               )

;; Colors are taken from the nord theme: https://www.nordtheme.com/
(set-face-attribute 'mode-line nil
                    :background "#a3be8c"
                    :foreground "#3b4252"
                    :box '(:line-width 6 :color "#a3be8c")
                    :overline nil
                    :underline nil)
;; M-x list-faces-display

(set-face-attribute 'mode-line-inactive nil
                    :background "#3b4252"
                    :foreground "#d8dee9"
                    :box '(:line-width 6 :color "#3b4252")
                    :overline nil
                    :underline nil)


;; ------------------------ MISC
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("37768a79b479684b0756dec7c0fc7652082910c37d8863c35b702db3f16000f8" default))
 '(package-selected-packages
   '(jinja2-mode kotlin-mode beacon all-the-icons dired-sidebar lua-mode pyvenv magit use-package scala-mode format-all flycheck)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


;;; init.el ends here
