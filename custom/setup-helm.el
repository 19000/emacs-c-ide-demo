(use-package helm
  :init
  (progn
    (require 'helm-config)
    (require 'helm-grep)
    ;; To fix error at compile:
    ;; Error (bytecomp): Forgot to expand macro with-helm-buffer in
    ;; (with-helm-buffer helm-echo-input-in-header-line)
    (if (version< "26.0.50" emacs-version)
        (eval-when-compile (require 'helm-lib)))

    (defun helm-hide-minibuffer-maybe ()
      (when (with-helm-buffer helm-echo-input-in-header-line)
        (let ((ov (make-overlay (point-min) (point-max) nil nil t)))
          (overlay-put ov 'window (selected-window))
          (overlay-put ov 'face (let ((bg-color (face-background 'default nil)))
                                  `(:background ,bg-color :foreground ,bg-color)))
          (setq-local cursor-type nil))))

    (add-hook 'helm-minibuffer-set-up-hook 'helm-hide-minibuffer-maybe)
    ;; The default "C-x c" is quite close to "C-x C-c", which quits Emacs.
    ;; Changed to "C-c h". Note: We must set "C-c h" globally, because we
    ;; cannot change `helm-command-prefix-key' once `helm-config' is loaded.
    (global-set-key (kbd "C-c h") 'helm-command-prefix)
    (global-unset-key (kbd "C-x c"))

    (define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebihnd tab to do persistent action
    (define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB works in terminal
    (define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z

    (define-key helm-grep-mode-map (kbd "<return>")  'helm-grep-mode-jump-other-window)
    (define-key helm-grep-mode-map (kbd "n")  'helm-grep-mode-jump-other-window-forward)
    (define-key helm-grep-mode-map (kbd "p")  'helm-grep-mode-jump-other-window-backward)
    ;;; Try to bind other keys like `helm-locate' and `helm-find-files-recursive-dirs' and `C-x C-b'

    (when (executable-find "curl")
      (setq helm-google-suggest-use-curl-p t))

    (setq helm-google-suggest-use-curl-p t
          helm-scroll-amount 4 ; scroll 4 lines other window using M-<next>/M-<prior>
          ;; helm-quick-update t ; do not display invisible candidates
          helm-ff-search-library-in-sexp t ; search for library in `require' and `declare-function' sexp.

          ;; you can customize helm-do-grep to execute ack-grep
          ;; helm-grep-default-command "ack-grep -Hn --smart-case --no-group --no-color %e %p %f"
          ;; helm-grep-default-recurse-command "ack-grep -H --smart-case --no-group --no-color %e %p %f"
          helm-split-window-in-side-p t ;; open helm buffer inside current window, not occupy whole other window
          ;;; Try to set this to `nil', and see if it affect `M-a' + `Grep' behavior.

          helm-echo-input-in-header-line t

          ;; helm-candidate-number-limit 500 ; limit the number of displayed canidates
          helm-ff-file-name-history-use-recentf t
          helm-move-to-line-cycle-in-source t ; move to end or beginning of source when reaching top or bottom of source.
          ;;; Important

          helm-buffer-skip-remote-checking t

          helm-mode-fuzzy-match t

          helm-buffers-fuzzy-matching t ; fuzzy matching buffer names when non-nil
                                        ; useful in helm-mini that lists buffers
          helm-org-headings-fontify t
          ;; helm-find-files-sort-directories t
          ;; ido-use-virtual-buffers t
          helm-semantic-fuzzy-match t
          helm-M-x-fuzzy-match t
          helm-imenu-fuzzy-match t
          helm-lisp-fuzzy-completion t
          ;; helm-apropos-fuzzy-match t
          helm-buffer-skip-remote-checking t
          helm-locate-fuzzy-match t
          helm-display-header-line nil

          helm-locate-recursive-dirs-command "mdfind -onlyin %s -name %s"
          helm-locate-fuzzy-match nil
          helm-locate-command "mdfind -name %s %s")

    (add-to-list 'helm-sources-using-default-as-input 'helm-source-man-pages)

    (global-set-key (kbd "M-x") 'helm-M-x)
    (global-set-key (kbd "M-y") 'helm-show-kill-ring)
    (global-set-key (kbd "C-x b") 'helm-buffers-list)
    (global-set-key (kbd "C-x C-f") 'helm-find-files)
    (global-set-key (kbd "C-c r") 'helm-recentf)
    (global-set-key (kbd "C-h SPC") 'helm-all-mark-rings)
    (global-set-key (kbd "C-c h o") 'helm-occur)
    (global-set-key (kbd "C-c h o") 'helm-occur)

    (global-set-key (kbd "C-c h w") 'helm-wikipedia-suggest)
    (global-set-key (kbd "C-c h g") 'helm-google-suggest)

    (global-set-key (kbd "C-c h x") 'helm-register)
    ;; (global-set-key (kbd "C-x r j") 'jump-to-register)

    (define-key 'help-command (kbd "C-f") 'helm-apropos)
    (define-key 'help-command (kbd "r") 'helm-info-emacs)
    (define-key 'help-command (kbd "C-l") 'helm-locate-library)

    ;; use helm to list eshell history
    (add-hook 'eshell-mode-hook
              #'(lambda ()
                  (define-key eshell-mode-map (kbd "M-l")  'helm-eshell-history)))

;;; Save current position to mark ring
    (add-hook 'helm-goto-line-before-hook 'helm-save-current-pos-to-mark-ring)

    ;;; helm minibuffer history eats backslashes in regex search
    ;; show minibuffer history with Helm
    (define-key minibuffer-local-map (kbd "M-p") 'helm-minibuffer-history)
    (define-key minibuffer-local-map (kbd "M-n") 'helm-minibuffer-history)
    ;;; minibuffer-local-map

    (define-key global-map [remap find-tag] 'helm-etags-select)

    (define-key global-map [remap list-buffers] 'helm-buffers-list)

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;; PACKAGE: helm-swoop                ;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;; Locate the helm-swoop folder to your path
    (use-package helm-swoop
      :init  ;; It won't work when put in `:config'
      ;; When doing isearch, hand the word over to helm-swoop
      (define-key isearch-mode-map (kbd "M-o") 'helm-swoop-from-isearch) ;;; Re-bind this `M-i', since it awkward for Dovrak layout, as well as `M-y'
      (define-key isearch-mode-map (kbd "M-O") 'helm-multi-swoop-all-from-isearch)

      :bind (("C-c h o" . helm-swoop)         ;;; Overwrote `helm-occur'
             ("C-c s" . helm-multi-swoop-all) ;;; Awesome!!

             ;;; Usage: https://github.com/jwiegley/use-package/issues/226#issuecomment-189053334
             :map helm-swoop-map
             ("M-o" . helm-multi-swoop-all-from-helm-swoop))

      :config
      ;; It won't work when put in `:init'
      ;; Either `:config' or `:bind :map' is okay.
      ;; From helm-swoop to helm-multi-swoop-all
      ;; (define-key helm-swoop-map (kbd "M-i") 'helm-multi-swoop-all-from-helm-swoop)

      ;; Save buffer when helm-multi-swoop-edit complete
      (setq helm-multi-swoop-edit-save t)  ;;; `helm-multi-swoop-edit' ? What's this

      ;; If this value is t, split window inside the current window
      (setq helm-swoop-split-with-multiple-windows t) ;;; Try revise

      ;; Split direcion. 'split-window-vertically or 'split-window-horizontally
      (setq helm-swoop-split-direction 'split-window-vertically) ;;; `horizontally'!! in fullscreen.

      ;; If nil, you can slightly boost invoke speed in exchange for text color
      (setq helm-swoop-speed-or-color t))


    (helm-mode 1)

    (use-package helm-projectile
      :init
      (helm-projectile-on)
      (setq projectile-completion-system 'helm)
      (setq projectile-indexing-method 'alien))

    (use-package helm-ag
      ;; :init
      :config

      ;; Rewrite this function, add `query' param
      (defun helm-do-ag--helm (&optional query)
        (let ((search-dir (if (not (helm-ag--windows-p))
                              helm-ag--default-directory
                            (if (helm-do-ag--target-one-directory-p helm-ag--default-target)
                                (car helm-ag--default-target)
                              helm-ag--default-directory))))
          (helm-attrset 'name (helm-ag--helm-header search-dir)
                        helm-source-do-ag)
          (helm :sources '(helm-source-do-ag) :buffer "*helm-ag*" :keymap helm-do-ag-map
                :input (or query
                           (helm-ag--marked-input t)
                           (helm-ag--insert-thing-at-point helm-ag-insert-at-point))
                :history 'helm-ag--helm-history)))

      ;; Rewrite this function, add `query' param
      (defun helm-do-ag (&optional basedir targets query)
        (interactive)
        (require 'helm-mode)
        (helm-ag--init-state)
        (let* ((helm-ag--default-directory (or basedir default-directory))
               (helm-ag--default-target (cond (targets targets)
                                              ((and (helm-ag--windows-p) basedir) (list basedir))
                                              (t
                                               (when (and (not basedir) (not helm-ag--buffer-search))
                                                 (helm-read-file-name
                                                  "Search in file(s): "
                                                  :default default-directory
                                                  :marked-candidates t :must-match t)))))
               (helm-do-ag--extensions (when helm-ag--default-target
                                         (helm-ag--do-ag-searched-extensions)))
               (one-directory-p (helm-do-ag--target-one-directory-p
                                 helm-ag--default-target)))
          (helm-ag--set-do-ag-option)
          (helm-ag--set-command-features)
          (helm-ag--save-current-context)
          (helm-attrset 'search-this-file
                        (and (= (length helm-ag--default-target) 1)
                             (not (file-directory-p (car helm-ag--default-target)))
                             (car helm-ag--default-target))
                        helm-source-do-ag)
          (if (or (helm-ag--windows-p) (not one-directory-p)) ;; Path argument must be specified on Windows
              (helm-do-ag--helm query)
            (let* ((helm-ag--default-directory
                    (file-name-as-directory (car helm-ag--default-target)))
                   (helm-ag--default-target nil))
              (helm-do-ag--helm query)))))

      (defun helm-do-ag-project-root--symbol-at-point ()
        (interactive)
        (helm-do-ag (helm-ag--project-root) nil (thing-at-point 'symbol)))

      :bind
      (("C-c h d" . helm-do-ag-project-root--symbol-at-point)))
    ))

;; (use-package helm-ag)


(provide 'setup-helm)
