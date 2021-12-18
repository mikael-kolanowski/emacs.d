(use-package evil
  :init
  (setq evil-want-keybinding nil)
  (evil-mode)
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)
  :config
  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(use-package evil-collection
  :init (evil-collection-init))

(use-package key-chord
  :init (key-chord-mode)
  :config
  (key-chord-define-global "ii" 'evil-normal-state))

(provide 'vi)
