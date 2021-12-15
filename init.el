(setq inhibit-startup-message t)

(setq sentence-end-double-space nil)
(setq default-fill-column 80)

(tool-bar-mode -1)
(menu-bar-mode -1)
(tooltip-mode -1)
(scroll-bar-mode -1)

(setq scroll-step 1)

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

(add-to-list 'load-path "~/.emacs.d/modules")
(require 'appearance)
(require 'ivy-config)
(require 'vi)
(require 'lsp)


(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)
   (sqlite . t)))

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.3))


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
   "u"   'universal-argument
   ;; Files
   "f"   '(:ignore t :which-key "files")
   "f f" 'counsel-find-file
   "f s" 'save-buffer
   ;; Windows
   "w"   '(:ignore t :which-key "windows")
   ;;"w c" ' Close window
   "w d" 'delete-window
   "w /" 'split-window-right
   "w _" 'split-window-below
   "w w" '(evil-window-next :which-key "next window")
   "w W" '(evil-window-prev :which-key "previous window")
   "w l" '(evil-window-right :which-key "focus right")
   "w h" '(evil-window-left :which-key "focus left")
   "w j" '(evil-window-down :which-key "focus down")
   "w k" '(evil-window-up :which-key "focus up")
   "w L" '(evil-window-move-far-right :which-key "move right")
   "w H" '(evil-window-move-far-left :which-key "move left")
   "w J" '(evil-window-move-very-bottom :which-key "move down")
   "w K" '(evil-window-move-very-top :which-key "move up")
   "w +" 'evil-window-increase-height
   "w -" 'evil-window-decrease-height
   "w >" 'evil-window-increase-width
   "w <" 'evil-window-decrease-width
 
   ;; Buffers
   "b"   '(:ignore t :which-key "buffers")
   "b b" '(counsel-ibuffer :which-key "switch buffer")
   "b d" 'kill-current-buffer
 
   ;; Help
   "h"   '(:ignore t :which-key "help")
   "h d" '(:ignore t :which-key "help-define")
   "h d v" '(describe-variable :which-key "describe variable")
   "h d f" '(describe-function :which-key "describe function")
   "h d m" '(describe-mode :which-key "describe mode")))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (company company-mode evil-collection modular-config general which-key use-package rainbow-delimiters ivy-rich gruvbox-theme evil doom-themes doom-modeline counsel))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
