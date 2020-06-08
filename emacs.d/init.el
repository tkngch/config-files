;; This is work in progress. Expect frequent, breaking changes.


;; Run info-lookup-symbol (C-h S) to see the documentation.

;; Disable the toolbar at the top.
(tool-bar-mode -1)
;; Disable the menubar at the top.
(menu-bar-mode -1)
;; Disable the scrollbar on the side.
(scroll-bar-mode -1)
;; keyboard scroll one line at a time
(setq scroll-step 1)

;; Highlight maching parens (brackets).
(defvar show-paren-delay 0.01)
(show-paren-mode 1)

;; Place all auto-saves and backups in the directory.
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

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

;; Generic completion mechanism from a list: e.g., a list of files when finding a file.
(use-package ivy
  :ensure t
  :config (progn (ivy-mode 1)
		 (global-set-key (kbd "C-c g") 'counsel-git)
		 (global-set-key (kbd "C-c j") 'counsel-git-grep)))

;; Text Selection.
;; Expand region increases the selected region by semantic units.
(use-package expand-region
  :ensure t
  :config (global-set-key (kbd "C-=") 'er/expand-region))

;; M-; to comment out a section of code.
;; M-/ to autocomplete with dabbrev.

;; Enable EVIL (Extensible VI Layer) mode.
(defvar evil-disable-insert-state-bindings t) ;; Keep default Emacs bindings in insert state.
(use-package evil
  :ensure t
  :config
  (evil-mode 1))

;; Use which-key to display the key bindings in a popup.
;; (which-key-mode) in the config enables the minor mode.
(use-package which-key
  :ensure t
  :config (progn (which-key-mode)
		 ;; Set the time delay (in seconds) for the which-key popup to appear. A value of
		 ;; zero might cause issues so a non-zero value is recommended.
		 (setq which-key-idle-delay 0.1)))


;; ---------------- WINDOW NAVIGATION

;; Swith to another window.
(global-set-key (kbd "M-o") 'other-window)

;; ---------------- PROGRAMMING SUPPORT

(require 'dabbrev)
;; Do not ignore case in matches and searches.
(setq case-fold-search nil)
(setq dabbrev-case-fold-search nil)

;; Use the completion framework.
;; (use-package company
;;   :ensure t
;;   :config (progn
;; 	    ;; Use the company-mode in all buffers.
;; 	    (global-company-mode 1)
;; 	    (setq company-idle-delay 0.01)))

;; Use code-linter.
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

;; Use code-formatter. To auto-format on save, we use the minor mode
;; format-all-mode. This minor mode is enabled individually for each
;; major mode.
(use-package format-all
  :ensure t
  :hook ((emacs-lisp-mode . format-all-mode)
	 (python-mode . format-all-mode)
	 (scala-mode . format-all-mode)
	 (vue-mode . format-all-mode)
	 ))

;; Emacs has build-in python mode. To use with venv, activate venv and
;; launch emacs from within venv.

(use-package scala-mode
  :ensure t)

(use-package vue-mode
  :ensure t)

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



;; ------------------------ MISC
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


;;; init.el ends here
