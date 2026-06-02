;; === Debugging ===
;; uncomment for Debugging
;;(setq debug-on-error t)
;; Set debug at point
;;(debug)

;; TODO
;; - Review: https://git.jonathanh.co.uk/jab2870/Dotfiles/src/branch/master

;; =============================
;; PACKAGE INSTALLATION
;; =============================
(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  (when (< emacs-major-version 24)
    ;; For important compatibility libraries like cl-lib
    (add-to-list 'package-archives '("gnu" . (concat proto "://elpa.gnu.org/packages/")))))
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))
(setq package-list '(yasnippet
                     guide-key
                     guru-mode
                     org
                     undo-tree
                     org-contacts
                     use-package
                     writegood-mode
                     flycheck
                     highlight-indentation
                     popwin
                     wrap-region
                     ))

(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))
(require 'use-package)

;; =============================
;; Setup Message Composition
;; =============================

;; Automatically use Message mode when a buffer named "*mutt*" is opened
(add-to-list 'auto-mode-alist '("/neomutt*" . message-mode))

;; Add useful hooks for mail composition
;; https://www.gnu.org/software/emacs/manual/html_mono/message.html#Insertion-Variables
(add-hook 'message-mode-hook (lambda ()
  ;;(auto-fill-mode t)   ; Enable automatic line wrapping (soft breaks)
  ;;(setq fill-column 72) ; Set line length for email standards (RFC 1855)
  ))

;; Spell Checking
(defun my-message-setup-routine ()
  (flyspell-mode 1))
(add-hook 'message-setup-hook 'my-message-setup-routine)

;; =============================
;; Contact Management
;; =============================
;; TODO: https://www.reddit.com/r/emacs/comments/18yb7hp/comment/lasovg5/?context=3

;; ORG-CONTACTS

(setq my-contacts-file "~/contacts.org")

(use-package notmuch
  :ensure nil ; nil because it's installed via the system package manager
  :commands (notmuch notmuch-search notmuch-show)
)

(use-package org-contacts
  :after org
  :ensure nil
  :custom
    (org-contacts-files (list my-contacts-file))
)

;; I place my contacts in one single org-contacts file, and this is organized by two header levels, the first level are organizations or company names and the second level are the contact name itself. At the moment I have a few hundreds contacts and don't feel any speed issues, which is said, that would happen by using org-contacts depending on the amount of contacts.  https://www.reddit.com/r/orgmode/comments/1dzrndg/contact_management_with_emacs_orgmode_orgcontacts/

(defun my:search-emails-from-contact (timeframe)
  (interactive "sTimeframe (week/month/year): ")
  (let* ((contact-email (bk:org-contacts-get-email))
         (time-arg (cond ((string= timeframe "week") "1w")
                         ((string= timeframe "month") "1m")
                         ((string= timeframe "year") "1y")
                         (t (error "Invalid timeframe"))))
         (query (format "(from:%s OR to:%s) AND date:%s..now"
                        contact-email contact-email time-arg)))
    (if contact-email
        (notmuch-tree query)
      (message "No contact selected or contact has no email."))))

;; Additionally I add tags to my contacts, first, for each organization I have often contact with and on contacts which I would like to be in a kind of group, where I would like to send emails to all of them, but don't like to type in each individual again and again. For this I created some small elisp functions (as commands), where I can type in tags and get back all emails from the contacts with these tags. I can type in several tags and get all emails combined for every tag given. https://www.reddit.com/r/orgmode/comments/1dzrndg/contact_management_with_emacs_orgmode_orgcontacts/
(defun my:insert-emails-for-tagged-contacts (tags)
  "Insert email addresses for contacts tagged with TAGS at the current cursor position. - https://www.reddit.com/r/orgmode/comments/1dzrndg/contact_management_with_emacs_orgmode_orgcontacts/"
  (interactive "sEnter tags (separated by space): ")
  (unless org-contacts-files
    (error "org-contacts-files is not set. Please set this variable to your org-contacts file path."))
  (let ((email-list nil)
        (tag-list (split-string tags " "))) ; divides the string in a list of tags
    ;; loop over all contacts in org-contacts-files and collect emails
    (dolist (contacts-file org-contacts-files)
      (with-current-buffer (find-file-noselect contacts-file)
        (org-map-entries
         (lambda ()
           (let* ((contact-tags (org-get-tags))
                  (contact-email (org-entry-get nil "EMAIL"))
                  (contact-name (org-get-heading t t t t)))
             (when (and contact-email (> (length contact-email) 0) (seq-intersection contact-tags tag-list))
               (push (format "%s <%s>" contact-name contact-email) email-list))))
         nil 'file)))
    ;; past email adresse at actual position
    (insert (mapconcat 'identity email-list ", "))))


;; ----------------
;; Creating Contacts
;; ----------------

(use-package org-capture
  :ensure nil
  :after org
  :preface
  (defvar my/org-contacts-template "* %(org-contacts-template-name)
:PROPERTIES:
:EMAIL: %(org-contacts-template-email)
:NAME: %^{NAME}
:ALIAS: %^{ALIAS}
:NICKNAME: %^{NICKNAME}
:ADDRESS: %^{289 Cleveland St. Brooklyn, 11206 NY, USA}
:BIRTHDAY: %^{yyyy-mm-dd}
:NOTE: %^{NOTE}
:END:" "Template for org-contacts.")
  :custom
  (org-capture-templates
   `(("c" "Contact" entry (file+headline my-contacts-file "Friends"),
      my/org-contacts-template
      :empty-lines 1))))


;; =============================
;; ENCODING
;; =============================

;; UTF-8 by default
(prefer-coding-system 'latin-1)
(if (not (assoc "UTF-8" language-info-alist))
    (set-language-environment "latin-1")
  (set-language-environment "utf-8")
  (set-keyboard-coding-system 'utf-8)
  (set-terminal-coding-system 'utf-8)
  (prefer-coding-system 'utf-8))

(set-charset-priority 'unicode)
(setq org-export-coding-system 'utf-8)
(setq default-process-coding-system '(utf-8-unix . utf-8-unix))

;; === Working with RTL languages ===
(defun reorder-rtl-text ()
  (interactive)
  (setq bidi-display-reordering nil)
  )
(defalias 'make-right-to-left-text-left-to-right 'reorder-rtl-text)
(defalias 'display-text-left-to-right 'reorder-rtl-text)




;; =============================
;; EMACS INTERFACE CONFIG
;; =============================

;; I do hate typing the full yes or no though
;; yes/no turns to y/n

(fset 'yes-or-no-p 'y-or-n-p)

;; =============================
;; VIEWING EMAILS
;; =============================

;; -----------------------------
;; Clean up
;; -----------------------------

;; Get rid of the annoying menubars, toolbars, scrollbars, bells, and splash screens.
(menu-bar-mode -1)
(if (boundp 'tool-bar-mode)
    (tool-bar-mode 0))
(if (fboundp 'scroll-bar-mode)
    (scroll-bar-mode 0))
(setq ring-bell-function 'ignore)
(setq inhibit-splash-screen t)


;; -----------------------------
;; Viewing
;; -----------------------------

(require 'highlight-indentation)

;; Wrap Regions

; wrap-region
(message "wrap region")
(require 'wrap-region)
(add-hook 'prog-mode-hook (lambda () (wrap-region-mode t)))
(add-hook 'markdown-mode-hook (lambda () (wrap-region-mode t)))
(wrap-region-add-wrapper "*" "*")

;; Mark and Cursor
;; I like to have the mark always active when I am selecting text.  This highlights the mark area.
(setq transient-mark-mode t)

;; I like to know exactly what character my cursor is on. This sets the cursor to be a box on top of that character.
(setq-default cursor-type 'box)

;; I use popwin mode to make sure that temporary buffers act as pop-up windows and can be closed with <C-g>.
(require 'popwin)
(popwin-mode 1)


;; Guide Key
;; https://github.com/kai2nenobu/guide-key displays the available key bindings automatically and dynamically.
(require 'guide-key)
(setq guide-key/guide-key-sequence t)
(guide-key-mode 1)
(setq guide-key/idle-delay .5)
(setq guide-key/popup-window-position 'bottom)


;; Emacs Guru Mode
;  [[https://github.com/bbatsov/guru-mode][Guru mode]] disables some common keybindings and suggests the use of the established Emacs alternatives instead.
(require 'guru-mode)

;; Currently running this globally.
(guru-global-mode +1)
;; I only want to get warnings when I use the arrow keys.
(setq guru-warn-only t)


;; =============================
;; EDITING TEXT
;; =============================

;; Overwrite Highlighted Text
;; Also does the same as delete selection mode
;; cua-selection-mode - enables typing over a region to replace it
(cua-selection-mode t)

;;--------------------
;; Unfill Paragraph
;;--------------------
;; [[https://emacs.stackexchange.com/questions/2606/opposite-of-fill-paragraph][From Stack Overflow user King Marvel]]

(defun unfill-paragraph ()
  "Takes a multi-line paragraph and makes it into a single line of text."
  (interactive)
  (let ((fill-column (point-max)))
    (fill-paragraph nil)))


;;--------------------
;; Moving Lines
;;--------------------

;; Add ability to move single lines
(defmacro save-column (&rest body)
  `(let ((column (current-column)))
     (unwind-protect
         (progn ,@body)
       (move-to-column column))))
(put 'save-column 'lisp-indent-function 0)

(defun move-line-up ()
  (interactive)
  (save-column
    (transpose-lines 1)
    (forward-line -2)))

(defun move-line-down ()
  (interactive)
  (save-column
    (forward-line 1)
    (transpose-lines 1)
    (forward-line -1)))

(global-set-key [(meta shift up)]  'move-line-up)
(global-set-key [(meta shift down)]  'move-line-down)
;;--------------------
;; END Moving Lines
;;--------------------


;; Handy key definition
(define-key global-map "\M-Q" 'unfill-paragraph)

;; FlyCheck
(require 'flycheck)

;; Keybindings
(message "key binding")
(global-set-key (kbd "C-c m f") 'flycheck-mode)
(global-set-key (kbd "C-c f r")
                '(lambda ()
                   (interactive)
                   (flycheck-mode t)))
(global-set-key [(f5)] 'flycheck-previous-error)
(global-set-key [(f6)] 'flycheck-next-error)

(add-hook 'message-mode-hook 'turn-on-flyspell 'append)

(require 'writegood-mode)

;; Personal key space
(define-prefix-command 'writegood-global-map)
(global-set-key (kbd "C-c w") 'writegood-global-map)

(define-key writegood-global-map (kbd "m") 'writegood-mode)
(define-key writegood-global-map (kbd "g") 'writegood-grade-level)
(define-key writegood-global-map (kbd "e") 'writegood-reading-ease)

;; Undo Help
;; Undo tree makes complex undo actions easy
(require 'undo-tree)
(global-undo-tree-mode t)

;; Prevent undo tree files from polluting your active dir
(setq undo-tree-auto-save-history nil)
(setq undo-tree-history-directory-alist '(("." . "/tmp/")))
;; The author of undo-tree (Dr. Toby Cubitt) admits that undo/redo-in-region has always been buggy and difficult to debug. He suggests disabling undo/redo in region until he has free time at some point in the future to work on this library again. To read about the most common bug with undo-in region, see the following two bug reports:
(setq undo-tree-enable-undo-in-region nil)


;; Yasnippet
(require 'yasnippet)
(yas/global-mode 1)
(setq yas/indent-line 'fixed) ; for indented snippets

;; Rebind yasnippet-expand to C-c tab. This is because the new version of yasnippet has a wrong fallback to the default <tab>, breaking Python's indentation cycling feature, and possibly other things too.
;;     - See:
;;        - https://github.com/fgallina/python.el/issues/123
;;        - https://github.com/capitaomorte/yasnippet/issues/332
(add-hook 'yas-minor-mode-hook
          '(lambda ()
             (define-key yas-minor-mode-map [(tab)] nil)
             (define-key yas-minor-mode-map (kbd "TAB") nil)
             (define-key yas-minor-mode-map  (kbd "<C-tab>") 'yas-expand-from-trigger-key)))

;; Otherwise we get errors
(setq warning-suppress-types nil)
(add-to-list 'warning-suppress-types '(yasnippet backquote-change))


;;---------------------
;; Navigation
;;---------------------

;;   Movement and line based commands should operate on the lines that I see (even if they are using word wrap) by default.
(global-visual-line-mode t)


;; Move to the beginning of the text
(defun smart-beginning-of-line ()
  "Move point to first non-whitespace character or beginning-of-line.

Move point to the first non-whitespace character on this line.
If point was already at that position, move point to beginning of line."
  (interactive) ; Use (interactive "^") in Emacs 23 to make shift-select work
  (let ((oldpos (point)))
    (back-to-indentation)
    (and (= oldpos (point))
         (beginning-of-line))))

(global-set-key (kbd "C-a") 'smart-beginning-of-line)
