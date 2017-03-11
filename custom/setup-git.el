(use-package magit
  :init
  ;; magit requires git >= 1.9.4, while GUI Emacs do not know $PATH in shell.
  (add-to-list 'exec-path "/usr/local/bin/"))

(provide 'setup-git)
