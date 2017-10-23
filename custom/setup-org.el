(require 'org)

;; http://emacs.stackexchange.com/questions/23819/emacs-org-mode-agenda-filter-doesnt-work
(setq org-agenda-files
      '("~/org-note/"
        "~/org-note/diary/"
        "~/emacs-learning/"
        "~/Documents/"))

(define-key org-mode-map (kbd "M-.") 'org-open-at-point)
(define-key org-mode-map (kbd "M-,") 'org-mark-ring-goto)

(setq org-agenda-start-day "-3d")
(setq org-agenda-span 10)
(setq org-agenda-start-on-weekday nil)

;; http://orgmode.org/worg/org-tutorials/org4beginners.html
(setq org-todo-keywords
      '((sequence "TODO(t)" "IN-PROGRESS(i)" "WAITING(w)" "|" "DONE(d)" "CANCELLED(c)")))
(setq org-use-fast-todo-selection t)

(set-register ?o (cons 'file "~/org-note/daily.org"))
;; (setq org-refile-targets '((org-agenda-files . (:maxlevel . 6))))
(setq org-refile-targets '((org-agenda-files . (:maxlevel . 1))))
(setq org-default-notes-file "~/org-note/note.org")

(global-set-key (kbd "<f11>") 'org-capture)
(setq org-capture-templates
      (quote (("n" "note" entry (file "~/org-note/note.org")
               ;; "* %? :NOTE:\n%U\n%a\n" :clock-in t :clock-resume  t)
               "* %? :NOTE:\n%T\n" :clock-in nil :clock-resume  t)
              ("t" "todo" entry (file "~/org-note/note.org")
               "* TODO %?\n%T\nDEADLINE: %t\n" :clock-in nil :clock-resume t)
              ("f" "flifla" entry (file "~/org-note/note.org")
               "* %? :flifla:\n%U\n" :clock-in nil :clock-resume t))))

(provide 'setup-org)
