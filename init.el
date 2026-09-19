;;; ... -*- lexical-binding: t -*-

;;     ▄████████   ▄▄▄▄███▄▄▄▄      ▄████████  ▄████████    ▄████████ 
;;    ███    ███ ▄██▀▀▀███▀▀▀██▄   ███    ███ ███    ███   ███    ███ 
;;    ███    █▀  ███   ███   ███   ███    ███ ███    █▀    ███    █▀  
;;   ▄███▄▄▄     ███   ███   ███   ███    ███ ███          ███        
;;  ▀▀███▀▀▀     ███   ███   ███ ▀███████████ ███        ▀███████████ 
;;    ███    █▄  ███   ███   ███   ███    ███ ███    █▄           ███ 
;;    ███    ███ ███   ███   ███   ███    ███ ███    ███    ▄█    ███ 
;;    ██████████  ▀█   ███   █▀    ███    █▀  ████████▀   ▄████████▀  
                                                                  
(global-display-line-numbers-mode)
(global-hl-line-mode)

(setq mac-option-modifier 'meta)
(setq mac-right-option-modifier 'none)
(setopt mac-command-modifier 'meta)
(setopt mac-right-command-modifier 'super)
(setopt mac-option-modifier nil)
(setopt mac-right-option-modifier 'alt)
(setq mac-option-modifier 'meta)
(setq mac-right-option-modifier 'none)

;; Custom file
(setq custom-file (concat user-emacs-directory "custom-vars.el"))
(load custom-file 'noerror 'nomessage)
;; UI
(tool-bar-mode -1)
(menu-bar-mode -1)

(set-frame-font "Source Code Pro-12")
(load-theme 'modus-operandi)

;; Mode line
(setq-default mode-line-format
              '("%e"
                mode-line-front-space
                mode-line-buffer-identification
                " "
                mode-line-position
                " "
                mode-line-modes
                mode-line-end-spaces))

(setq inhibit-startup-screen t)
(setq scroll-margin 0
      scroll-conservatively 100000
      scroll-preserve-screen-position 1)

;; store all backup and autosave files in the tmp dir
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

(global-display-line-numbers-mode)
(hl-line-mode)

(setq recentf-max-saved-items 200)
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
;; Package management
(setq package-archives'(("melpa" . "https://melpa.org/packages/")
			 ("nongnu" . "https://elpa.nongnu.org/nongnu/")
			 ("elpa" . "https://elpa.gnu.org/packages/")))
;; typst-ts-mode 0.12.2 autoloads use `define-compilation-mode`.
(require 'compile)
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))
(setq use-package-always-ensure t)

(use-package emacs
  :ensure nil
  :custom
  (ring-bell-function 'ignore)
  ;; The week starts on Monday
  (calendar-week-start-day 1)
  (use-short-answers t)

  :config
  (blink-cursor-mode -1)
  ;; Remember cursor position in files
  (save-place-mode 1)
  ;; Remember recently opened files
  (recentf-mode 1)
  ;; Refresh buffers when files change on disk
  (global-auto-revert-mode 1)
  ;; C-x o C-x o -> C-x o o
  (repeat-mode)
  (electric-pair-mode)
  )

(use-package isearch
  :ensure nil
  :bind
  (:map isearch-mode-map
        ("C-." . isearch-forward-thing-at-point))
  :custom
  (lazy-count-prefix-format "(%s/%s) ")
  (isearch-lazy-count t)
  (isearch-allow-motion t)
  (isearch-allow-scroll t)
  (isearch-repeat-on-direction-change t)
  (isearch-wrap-pause 'no-ding)
  (search-whitespace-regexp ".*?"))

(use-package vertico
  :custom
  (vertico-count 15)
  :init
  (vertico-mode))

(use-package marginalia
  :init
  (marginalia-mode))

(use-package orderless
  :config
  (setq completion-styles '(orderless basic)))

(use-package consult
  :bind
  (("M-o f" . consult-find))
  ("M-o g" . consult-ripgrep)
  ("M-o l" . consult-line)
  ;; Drop-in replacements
  ("C-x b" . consult-buffer)
  ("M-y" . consult-yank-pop)
  ("M-g i" . consult-imenu)
  ("M-g g" . consult-goto-line))

(use-package magit)

(use-package which-key
  :init
  (which-key-mode))

;; Coding ----------------------------------------------------------------------
(use-package eglot
  :ensure nil
  :custom
  (eglot-autoshutdown t)
  (eglot-events-buffer-size 0)
  (eglot-sync-connect nil)
  :hook
  ((go-ts-mode go-mode typescript-ts-mode tsx-ts-mode) . eglot-ensure)
  :bind
  (:map eglot-mode-map
        ("C-c e a" . eglot-code-actions)
        ("C-c e r" . eglot-rename)
        ("C-c e f" . eglot-format)
        ("C-c e i" . eglot-inlay-hints-mode)
        ("C-c e R" . eglot-reconnect)))

;; Emacs 31's TypeScript and TSX modes use these parsers for reliable syntax
;; highlighting and structural editing.  `treesit-install-language-grammar`
;; uses this list when a parser has not yet been installed.
(setq treesit-language-source-alist
      '((typescript . ("https://github.com/tree-sitter/tree-sitter-typescript"
                       "master" "typescript/src"))
        (tsx . ("https://github.com/tree-sitter/tree-sitter-typescript"
                "master" "tsx/src"))
        (typst . ("https://github.com/uben0/tree-sitter-typst"))
        (go . ("https://github.com/tree-sitter/tree-sitter-go"))))

(use-package typst-ts-mode
  :mode "\\.typ\\'")

(use-package company
  :hook (prog-mode . company-mode)
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.15)
  (company-tooltip-align-annotations t)
  (company-require-match nil)
  :config
  (setq company-backends '(company-capf)))

;; Apply the server's formatter on save.  This means gopls runs gofmt/goimports
;; for Go, while the TypeScript server respects the project's formatter setup.
(defun mk/eglot-format-on-save ()
  "Format the current Eglot-managed buffer before it is saved."
  (when (bound-and-true-p eglot-managed-mode)
    (eglot-format-buffer)))

(dolist (hook '(go-ts-mode-hook go-mode-hook
                typescript-ts-mode-hook tsx-ts-mode-hook))
  (add-hook hook (lambda ()
                   (add-hook 'before-save-hook #'mk/eglot-format-on-save nil t))))

;; familiar navigation keys, backed by the language server where applicable.
(global-set-key (kbd "M-.") #'xref-find-definitions)
(global-set-key (kbd "M-?") #'xref-find-references)
(global-set-key (kbd "C-c e d") #'eldoc-doc-buffer)

(setq org-agenda-files '("~/org/agenda/"))
(global-set-key (kbd "C-c a") #'org-agenda)

;; Custom LISP -----------------------------------------------------------------
(defun make-markdown-link (start end target)
  "turn the marked text into a markdown link, prompting for the link target"
  (interactive
   (list
    (region-beginning)
    (region-end)
    (read-string "link target: ")))
  (let ((caption (buffer-substring start end)))
    (replace-region-contents start end
                             (lambda () (format "[%s](%s)" caption target)))))

(defun elisp-insert-section (title)
  (interactive (list (read-string "Section title: ")))
  (let* ((target-length 80)
         (remaining-length (- target-length (length title) 3 1))) ;; ;;_title_
    (insert ";; " title " " (make-string remaining-length ?-))))

(defun esperantize-region (start end)
  (interactive (list (region-beginning) (region-end)))
  (let ((contents (buffer-substring start end)))
    (dolist (subst '(("CX" . "Ĉ")
                    ("Cx" . "Ĉ")
                    ("GX" . "Ĝ")
                    ("Gx" . "Ĝ")
                    ("JX" . "Ĵ")
                    ("Jx" . "Ĵ")
                    ("SX" . "Ŝ")
                    ("Sx" . "Ŝ")
                    ("UX" . "Ŭ")
                    ("Ux" . "Ŭ")
                    ("cx" . "ĉ")
                    ("gx" . "ĝ")
                    ("jx" . "ĵ")
                    ("sx" . "ŝ")
                    ("ux" . "ŭ")))
      (setq contents (string-replace (car subst) (cdr subst) contents)))
    (replace-region-contents start end contents)))
