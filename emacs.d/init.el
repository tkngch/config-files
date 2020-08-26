;;; init.el --- Emacs configuration file.

;;; Commentary:
;; This is work in progress.  Expect frequent, breaking changes.

;;; Code:

;; Disable the toolbar at the top.
(tool-bar-mode -1)
;; Disable the menubar at the top.
(menu-bar-mode -1)
;; Disable the scrollbar on the side.
(scroll-bar-mode -1)
;; keyboard scroll one line at a time
(setq scroll-step 1)
;; Do not recenter point (cursor) when it moves off screen for smooth scrolling.
(setq scroll-conservatively 101)
;; Let point keep its screen position when scrolling, so that `C-v` `M-v`
;; sequence brings back point where it was.
(setq scroll-preserve-screen-position t)
;; Disable popup on mouse hover on mode-line.
(tooltip-mode -1)

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

;; Line-wrap at 80 columns.
(setq-default fill-column 80)

;; display line numbers and column numbers in all modes
(setq line-number-mode t)
(setq column-number-mode t)
;; Display the relative line number on the left.
(setq display-line-numbers 'relative)

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
(set-face-attribute 'default nil :height 94)



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
;; Filename completion.
;; (require 'ido)
;; (setq ido-enable-flex-matching t
;;       ido-everywhere t
;;       ;; Disable searching in other directories when there are no matches.
;;       ido-auto-merge-work-directories-length -1)
;; (ido-mode t)

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

;; Show trailing whitespaces.
(require 'whitespace)
(setq-default whitespace-style '(face trailing tabs))
(setq-default show-trailing-whitespace t)
(global-whitespace-mode)
;; Don't show whitespaces in certain major modes.
(add-hook 'eshell-mode-hook (lambda () (setq show-trailing-whitespace nil)))
(add-hook 'term-mode-hook (lambda () (setq show-trailing-whitespace nil)))
(add-hook 'compilation-mode-hook (lambda () (setq show-trailing-whitespace nil)))

;; Enable the continuous scrolling in the dov-view mode.
(setq-default doc-view-continuous t)


;; ================ PACKAGE CONFIGURATION
;; Load the functions and variables defined in `package`.
(require 'package)
;; Disable automatic package loading, for slightly faster startup.
(setq package-enable-at-startup nil)
;; Add MELPA to the list of package archives.
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
;; Load packages explicitly in this init file.
(package-initialize)

;; Install `use-package` for package management/configuration if not
;; installed.
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)

;; ---------------- KEY BINDINGS

;; `C-y M-y M-y M-y ...` goes through kill ring.
;; `M-x rgrep` looks for files containig search word.
;; `M-;` to comment out a section of code.
;; `M-/` to autocomplete with dabbrev.
;; `M-q` to format a paragraph. The column width is determined by 'fill-column.
;; ‘C-q <tab>’ to insert a tab.
;; `M-x revert-buffer` to reload the file.
;; `M-h` to select a paragraph/function.
;; 'C-SPC' to start selection.
;; `M-w` to copy the selected.
;; `C-w` to cut the selected.
;; `C-k` to cut rest of line.
;; `C-x C-s` to save current buffer.
;; `C-x s` to save all buffers.
;; `C-/` to undo. `M-x undo-only`
;; `C-?` to redo. 'M-x undo-redo`
;; `C-x 4 f` to open a file in a new window.
;; https://www.gnu.org/software/emacs/manual/html_node/emacs/Moving-Point.html

;; Enable EVIL (Extensible VI Layer) mode.
(use-package evil
  :ensure t
  :init (progn
          ;; Keep default Emacs bindings in insert state.
          (setq evil-disable-insert-state-bindings t))
  :config
  (evil-mode 1))

;; Use which-key to display the key bindings in a popup.
;; (which-key-mode) in the config enables the minor mode.
;; (use-package which-key
;;   :ensure t
;;   :config (progn (which-key-mode)
;;                  ;; Set the time delay (in seconds) for the which-key popup to
;;                  ;; appear. A value of zero might cause issues so a non-zero
;;                  ;; value is recommended.
;;                  (setq which-key-idle-delay 1)))

;; ---------------- EMAIL
(autoload 'notmuch "notmuch" "notmuch mail" t)

;; ---------------- PROGRAMMING SUPPORT

;; Use the completion framework.
(use-package company
  :ensure t
  :config (progn
            (global-company-mode 1)
            (setq company-idle-delay 0.01)))

(use-package all-the-icons
  :ensure t)
;; To install icons, `M-x all-the-icons-install-fonts`.

;; Filename completion.
;; Much nicer than ido-mode.
(use-package counsel
  :ensure t
  :init (progn
          (setq ivy-count-format "(%d/%d) ")
          (setq ivy-extra-directories ())  ;; Remove ./ and ../ from find-file completion.
          (global-set-key (kbd "C-s") 'swiper-isearch)
          (global-set-key (kbd "M-x") 'counsel-M-x)
          (global-set-key (kbd "C-x C-f") 'counsel-find-file)
          (global-set-key (kbd "M-y") 'counsel-yank-pop)
          (global-set-key (kbd "<f1> f") 'counsel-describe-function)
          (global-set-key (kbd "<f1> v") 'counsel-describe-variable)
          (global-set-key (kbd "<f1> l") 'counsel-find-library)
          (global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
          (global-set-key (kbd "<f2> u") 'counsel-unicode-char)
          (global-set-key (kbd "<f2> j") 'counsel-set-variable)
          (global-set-key (kbd "C-x b") 'ivy-switch-buffer)
          (global-set-key (kbd "C-c v") 'ivy-push-view)
          (global-set-key (kbd "C-c V") 'ivy-pop-view)
          )
  :config (ivy-mode 1))

(use-package all-the-icons-ivy
  :ensure t
  :init (add-hook 'after-init-hook 'all-the-icons-ivy-setup))

(use-package all-the-icons-dired
  :ensure t
  :init (add-hook 'dired-mode-hook 'all-the-icons-dired-mode))

;; (use-package neotree
;;   :ensure t
;;   :init (progn
;;           (evil-set-initial-state 'neotree-mode 'emacs)
;;           (setq neo-theme 'arrow)
;;           (setq neo-default-system-application nil)))

(use-package eglot
  :ensure t
  :init (progn
          (add-hook 'scala-mode-hook 'eglot-ensure)))

;; Use code-linter.
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

;; Emacs has build-in python mode. To use with venv, activate venv and launch
;; emacs from within venv.
(add-hook 'python-mode-hook (lambda() (setq fill-column 88)))
;; To activate venv, issue `M-x pyvenv-activate` and then select .venv
;; directory.
(use-package pyvenv
  :ensure t)

(use-package scala-mode
  :ensure t)

(use-package lua-mode
  :ensure t)


(use-package vue-mode
  :ensure t)

(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)  ;; gfm is for github flavoured markdown
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode)))

;; Use code-formatter. To auto-format on save, we use the minor mode
;; format-all-mode. This minor mode is enabled individually for each major mode.
(use-package format-all
  :ensure t
  :hook ((emacs-lisp-mode . format-all-mode)
         (python-mode . format-all-mode)
         (scala-mode . format-all-mode)
         (markdown-mode . format-all-mode)
         (gfm-mode . format-all-mode)
         (vue-mode . format-all-mode)
         ))

(use-package magit
  :ensure t
  :bind (("C-x g" . magit-status)))


;; ------------------------ COLORS
;; Color theme

;; Built-in themes are /usr/share/emacs/26.3/etc/themes
;; (load-theme 'adwaita)
(load-theme 'deeper-blue)
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

;; Hide the minor mode indications from the mode line.
;; (define-minor-mode minor-mode-blackout-mode
;;   "Hides minor modes from the mode line."
;;   t)

;; (catch 'done
;;   (mapc (lambda (x)
;;           (when (and (consp x)
;;                      (equal (cadr x) '("" minor-mode-alist)))
;;             (let ((original (copy-sequence x)))
;;               (setcar x 'minor-mode-blackout-mode)
;;               (setcdr x (list "" original)))
;;             (throw 'done t)))
;;         mode-line-modes))

;; ;; Toggle the minor mode indication on/off.
;; (global-set-key (kbd "C-c m") 'minor-mode-blackout-mode)

;; Display the current function name in the mode line.
(require 'which-func)
(which-function-mode t)
(setq which-func-unknown "∅")

;; (setq-default display-line-numbers 'relative)

(setq-default mode-line-format
              '(
                "%e"
                mode-line-front-space
                mode-line-client
                mode-line-frame-identification
                ;; (:eval (all-the-icons-icon-for-buffer))
                ;; " "
                (:eval (propertize "%b" 'face 'bold))
                " "
                mode-line-modified
                " "
                "(row: %03l; col: %02C)"
                "   "
                (which-function-mode (#1="" which-func-format " "))
                (global-mode-string (#1# global-mode-string " "))
                (:eval (propertize
                        " " 'display
                        `((space :align-to (- (+ right right-fringe right-margin)
                                              ,(+ 2 (string-width mode-name)))))))
                ;; mode-line-modes
                "%m"
                mode-line-end-spaces
                )
              )

;; Colors are taken from the nord theme: https://www.nordtheme.com/
(set-face-attribute 'mode-line nil
                    :background "#a3be8c"
                    :foreground "#3b4252"
                    :box '(:line-width 6 :color "#a3be8c")
                    :overline nil
                    :underline nil)
;; M-x list-faces-display
(set-face-attribute 'which-func nil
                    :foreground "#4c566a")

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
 '(package-selected-packages
   '(all-the-icons dired-sidebar ivy lua-mode pyvenv magit vue-mode use-package scala-mode format-all flycheck evil)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


;;; init.el ends here
