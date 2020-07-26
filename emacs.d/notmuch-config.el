;;; package --- summary
;;; Commentary:
;;; Code:

(require 'notmuch)
(require 'sendmail)

;; Disable whitespace mode.
(add-hook 'notmuch-search-mode-hook (lambda () (setq show-trailing-whitespace nil)))
(add-hook 'notmuch-show-mode-hook (lambda () (setq show-trailing-whitespace nil)))

;; close the mail window after sending it.
(setq-default message-kill-buffer-on-exit t)

;; Don’t display killed threads in my inbox.
(setq-default notmuch-saved-searches '((:name "inbox (personal)"
                                              :query "tag:inbox AND tag:to-me AND NOT tag:archive"
                                              :key "1")
                                       (:name "inbox (others)"
                                              :query "date:2weeks.. AND tag:inbox AND NOT tag:to-me AND NOT tag:archive"
                                              :key "2")
                                       (:name "archive"
                                              :query "date:2weeks.. AND tag:archive"
                                              :key "3")
                                       (:name "sent"
                                              :query "date:2weeks.. AND tag:sent"
                                              :key "4")))

(setq-default notmuch-search-result-format
              '(("date" . "%12s  ")
                ("authors" . "%-20s  ")
                ("subject" . "%s  ")
                ("tags" . "%s")
                ))

;; Show newest messages at the top.
(setq notmuch-search-oldest-first nil)

;; List of tag changes to apply to a message when it is archived.
(setq notmuch-archive-tags '("+archive" "-inbox"))

;; Use sendmail(1) to send emails.
(setq message-send-mail-function 'message-send-mail-with-sendmail)
(setq send-mail-function 'sendmail-send-it)

;; Do not add Fcc header to emails.
(setq notmuch-fcc-dirs nil)
;; Customise the headers.
(setq-default message-default-mail-headers "Cc:\nBcc: tkngch@runbox.com\n")


;;; notmuch-config.el ends here
