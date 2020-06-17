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

;; No blinking cursor.
(blink-cursor-mode 0)

;; Highlight maching parens (brackets).
(defvar show-paren-delay 0.01)
(show-paren-mode 1)

;; Place all auto-saves and backups in the directory.
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

(setq-default fill-column 80)

;; display line numbers and column numbers in all modes
(setq line-number-mode t)
(setq column-number-mode t)


;; Use spaces instead of tabs when indenting.
(setq-default indent-tabs-mode nil)

;; Show trailing whitespaces.
(setq-default whitespace-style '(face trailing tabs))
(setq-default show-trailing-whitespace t)
(global-whitespace-mode)

;; Enable the continuous scrolling in the dov-view mode.
(setq-default doc-view-continuous t)
;; Auto-scroll in the compilation mode, until the first error.
(setq-default compilation-scroll-output "first-error")


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

(require 'ido)
(setq ido-enable-flex-matching t
      ido-everywhere t
      ;; Disable searching in other directories when there are no matches.
      ido-auto-merge-work-directories-length -1)
(ido-mode t)

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



;; Generic completion mechanism from a list: e.g., a list of files when finding a file.
;; (use-package ivy
;;   :ensure t
;;   :config (progn (ivy-mode 1)
;; 		 (global-set-key (kbd "C-c g") 'counsel-git)  ; find file by name
;; 		 (global-set-key (kbd "C-c j") 'counsel-git-grep)
;; 		 (global-set-key (kbd "M-y") 'counsel-yank-pop)  ; show/search kill-ring
;; 		 (global-set-key (kbd "C-c C-r") 'ivy-resume)))

;; Text Selection.
;; Expand region increases the selected region by semantic units.
(use-package expand-region
  :ensure t
  :config (global-set-key (kbd "C-=") 'er/expand-region))

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
		 (setq which-key-idle-delay 1)))


;; ---------------- WINDOW NAVIGATION

;; Swith to another window.
(global-set-key (kbd "M-o") 'other-window)

;; ---------------- PROGRAMMING SUPPORT

;; Completion
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

(add-hook 'doc-view-mode-hook 'auto-revert-mode)

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

;; Emacs has build-in python mode. To use with venv, activate venv and launch
;; emacs from within venv.
(add-hook 'python-mode-hook (lambda() (setq fill-column 88)))

(use-package scala-mode
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



;; ------------------------ MISC
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (magit which-key vue-mode use-package scala-mode format-all flycheck expand-region evil))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


;;; init.el ends here
