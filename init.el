(setq inhibit-startup-message t)

(setq delete-old-versions -1)
(setq version-control t)
(setq sentence-end-double-space nil)
(setq default-fill-column 80)

(tool-bar-mode -1)
(menu-bar-mode -1)
(tooltip-mode -1)
(scroll-bar-mode -1)

(setq scroll-step 1)

(set-face-attribute 'default nil :font "Fira Code" :height 120)

;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("org" . "https://orgmode.org/elpa/")
			 ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(column-number-mode)
(global-display-line-numbers-mode t)

;; Disable line numbers in some modes
(dolist (mode '(org-mode-hook
		term-mode-hook
		eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(use-package evil
  :config
  (evil-mode 1)
;;  (define-key evil-normal-state-map (kbd "/") 'counsel-grep-or-swiper)
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(use-package swiper)
(use-package ivy
  :diminish
  :bind (("C-s" . counsel-grep-or-swiper)
	 :map ivy-minibuffer-map
	 ("TAB" . ivy-alt-done)
	 ("C-l" . ivy-alt-done)
	 ("C-j" . ivy-next-line)
	 ("C-k" . ivy-previous-line)
	 :map ivy-switch-buffer-map
	 ("C-k" . ivy-previous-line)
	 ("C-l" . ivy-done)
	 ("C-d" . ivy-switch-buffer-kill)
	 :map ivy-reverse-i-search-map
	 ("C-k" . ivy-previous-line)
	 ("C-d" . ivy.reverse-i-search-kill))
  :config
  (ivy-mode 1))

;; Display documentation string when listing commands
(use-package counsel
  :bind (("M-x" . counsel-M-x)
	 ("C-x b" . counsel-ibuffer)
	 ("C-x C-f" . counsel-find-file)
	 :map minibuffer-local-map
	 ("C-r" . 'counsel-minibuffer-history)))
(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 10)))

; Themes
(use-package gruvbox-theme)

(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)
   (sqlite . t)))

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.3))

;; Set theme
(global-hl-line-mode 1)

(use-package doom-themes
  :init (load-theme 'doom-gruvbox t))
;; Key bindings

(use-package general
  :config
  (general-define-key :states 'normal "/" 'counsel-grep-or-swiper)
  (general-define-key
   :states '(normal visual insert emacs)
   :prefix "SPC"
   :non-normal-prefix "C-SPC"
 
   ;; General
   "SPC" '(counsel-M-x :which-key "interactive command")
   "!"   'shell-command
   ":"   'eval-expression
   ;; Files
   "f"   '(:ignore t :which-key "files")
   "f f" 'counsel-find-file
   "f s" 'save-buffer
   ;; Windows
   "w"   '(:ignore t :which-key "windows")
   ;;"w c" ' Close window
   "w q" 'delete-window
   "w i" 'split-window-right
   "w -" 'split-window-below
   "w w" '(evil-window-next :which-key "next window")
   "w W" '(evil-window-prev :which-key "previous window")
   "w l" '(evil-window-right :which-key "focus right")
   "w h" '(evil-window-left :which-key "focus left")
   "w j" '(evil-window-down :which-key "focus down")
   "w k" '(evil-window-up :which-key "focus up")
 
   ;; Buffers
   "b"   '(:ignore t :which-key "buffers")
   "b b" '(counsel-switch-buffer :which-key "switch buffer")
   "b d" 'kill-buffer
 
   ;; Help
   "h"   '(:ignore t :which-key "help")
   "h d" '(:ignore t :which-key "help-define")
   "h d v" '(describe-variable :which-key "describe variable")
   "h d f" '(describe-function :which-key "describe function")
   "h d m" '(describe-mode :which-key "describe mode")))

(use-package key-chord
  :init (key-chord-mode 1)
  :config
  (key-chord-define-global "ii" 'evil-normal-state))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (general which-key use-package rainbow-delimiters ivy-rich gruvbox-theme evil doom-themes doom-modeline counsel))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
