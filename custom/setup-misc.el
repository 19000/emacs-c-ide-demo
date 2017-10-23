;; (add-to-list 'company-backends 'company-c-headers)

(electric-pair-mode 1)

(global-set-key (kbd "M-`") 'other-window)

(defun my-other-frame ()
  (interactive)
  (other-frame 1))
(global-set-key (kbd "<f7>") 'my-other-frame)


(use-package quickrun
  :config
  (progn (quickrun-add-command "c++/clang++"
                        '((:command . "clang++")
                          ;; (:exec    . ("%c -x c++ %o -o %e %s" "%e %a"))
                          ;; (:compile-only . "%c -Wall -Werror %o -o %e %s")
                          (:exec . ("%c -std=c++11 -lstdc++ %o -o %e %s" "%e %a"))
                          (:compile-only . "%c -Wall -Werror -std=c++11 -lstdc++ %o -o %e %s")
                          (:remove  . ("%e"))
                          (:description . "Compile C++ file with llvm/clang++ and execute")))
         (quickrun-set-default "c++" "c++/clang++")))

(use-package google-this
  :config
  ;; google ncr
  (defun google-this-url ()
    "URL for google searches."
    (concat google-this-base-url google-this-location-suffix "/search?ion=1&q=%s&gws_rd=cr&hl=en&num=30"))
  :bind (("C-c C-g" . google-this-noconfirm)))


(defun pbcopy (start end arg &optional interactive)
  (interactive "r\nP\np")
  (if interactive
      (if (region-active-p)
          (progn (call-process-region start end "pbcopy")
                 (message "Region Copied."))
        (progn (call-process-region (point-min) (point-max) "pbcopy")
               (message "Buffer Copied."))))
  (setq deactivate-mark t))

(defun leetcode-replace-newline ()
  (interactive)
  (save-excursion (save-restriction
                    (setq message-log-max nil)
                    (goto-char (point-min))
                    (while (re-search-forward "\xd") ;^M: C-x C-= Char: RET (13, #o15, #xd)
                      (replace-match "")))))
(defun pbpaste ()
  (interactive)
  (call-process-region (point) (if mark-active (mark) (point)) "pbpaste" t t)
  (leetcode-replace-newline))

(defun pbcut ()
  (interactive)
  (pbcopy)
  (delete-region (region-beginning) (region-end)))

(global-set-key (kbd "C-c c") 'pbcopy)
(global-set-key (kbd "C-c v") 'pbpaste)
;; (global-set-key (kbd "C-c x") 'pbcut)


(defun comment-or-uncomment-region-or-line ()
    "Comments or uncomments the region or the current line if there's no active region."
    (interactive)
    (let (beg end)
      (if (region-active-p)
          (setq beg (region-beginning) end (region-end))
        (setq beg (line-beginning-position) end (line-end-position)))
      (comment-or-uncomment-region beg end)))
(global-set-key (kbd "M-;") 'comment-or-uncomment-region-or-line)

;; (setq tab-width 4) ; or any other preferred value
;; (defvaralias 'c-basic-offset 'tab-width)
;; (defvaralias 'cperl-indent-level 'tab-width)
;;; Tabs vs Spaces
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4) ; or any other preferred value
(setq-default c-basic-offset tab-width)
(setq-default cperl-indent-level tab-width)

(show-paren-mode 1)


(setq-default message-log-max 10000)




;;; http://stackoverflow.com/questions/1128927/how-to-scroll-line-by-line-in-gnu-emacs
(setq scroll-step            1
      scroll-conservatively  10000)


;;; For restore Windows and Frames, otherwise it'll throw errors when `desktop-change-dir`.
;;; http://stackoverflow.com/questions/18612742/emacs-desktop-save-mode-error
;;;
;; (setq desktop-restore-frames t)
;; (setq desktop-restore-in-current-display t)
;;; It is the (setq desktop-restore-forces-onscreen nil) line specifically that fixes this issue.
(setq desktop-restore-forces-onscreen nil)


(add-hook 'emacs-lisp-mode-hook 'eldoc-mode)
;; (eldoc-mode 1)                          ; Not work
                                        ; Need set for each buffer?
(define-key emacs-lisp-mode-map (kbd "M-.") 'find-function-at-point)

;;; https://www.emacswiki.org/emacs/point-undo.el
;; (require 'point-undo)
;; (define-key global-map (kbd "C-<") 'point-undo)  ;; maybe need setup `input-decode-map' to work
;; (define-key global-map (kbd "C->") 'point-redo)
;; (define-key global-map [f5] 'point-undo)
;; (define-key global-map [f6] 'point-redo)

(set-register ?i (cons 'file "~/.emacs.d/init.el"))

;; (global-hl-line-mode 1)

(setq visible-bell t)

(savehist-mode 1)
(setq savehist-additional-variables '(kill-ring search-ring regexp-search-ring))
;; (setq savehist-file "~/.emacs.d/tmp/savehist")

(provide 'setup-misc)
