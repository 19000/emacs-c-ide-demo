(require 'package)
(add-to-list 'package-archives
         '("melpa" . "http://melpa.org/packages/") t)

(package-initialize)

(when (not package-archive-contents)
    (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(add-to-list 'load-path "~/.emacs.d/custom")

(require 'setup-general)

;; (require 'setup-ivy-counsel)
(if (version< emacs-version "24.4")
    (require 'setup-ivy-counsel)
  (require 'setup-helm)
  (require 'setup-helm-gtags))

;; (require 'setup-ggtags)
(require 'setup-cedet)
(require 'setup-editing)
(require 'setup-python)
(require 'setup-git)
(require 'setup-misc)
(require 'setup-org)
(require 'setup-terminal-keymapping)
