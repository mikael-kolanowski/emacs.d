;; Custom file
(setq custom-file (concat user-emacs-directory "custom-vars.el"))
(load custom-file 'noerror 'nomessage)
;; UI
(tool-bar-mode -1)
(menu-bar-mode -1)
(blink-cursor-mode -1)
(setq inhibit-startup-screen t)
(setq ring-bell-function 'ignore)

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

(electric-pair-mode)

;; Package management
(setq package-archives '(( "melpa" . "https://melpa.org/packages/")
			 ("elpa" . "https://elpa.gnu.org/packages/")))
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))
(setq use-package-always-ensure t)

(use-package vertico
  :init
  (vertico-mode))

(use-package marginalia
  :init
  (marginalia-mode))

(load-theme 'modus-operandi nil)

(setq org-agenda-files '("~/org/agenda/"))

(global-set-key (kbd "C-c a") #'org-agenda)

(defun make-markdown-link (start end target)
  "Turn the marked text into a markdown link,
prompting for the link target"
  (interactive
   (list
    (region-beginning)
    (region-end)
    (read-string "Link target: ")))
  (let ((caption (buffer-substring start end)))
    (replace-region-contents start end
     (lambda () (format "[%s](%s)" caption target)))))
