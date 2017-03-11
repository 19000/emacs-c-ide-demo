;;(use-package elpy)
(use-package jedi
  :init (progn
          (jedi:install-server)
          (setq jedi:complete-on-dot t)
          (add-hook 'python-mode-hook 'jedi:setup))

  :bind (("M-." . jedi:goto-definition)
         ("M-," . jedi:goto-definition-pop-marker)))

(provide 'setup-python)
