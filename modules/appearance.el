;; Set font
(set-face-attribute 'default nil :font "Fira Code" :height 120)

(column-number-mode)
;; Display line numbers
(global-display-line-numbers-mode)
;; Highlight current line
(global-hl-line-mode)

;; Disable line numbers in some modes
(dolist (mode '(org-mode-hook
		term-mode-hook
		eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 10)))

(use-package doom-themes
  :init (load-theme 'doom-gruvbox t))

(provide 'appearance)
