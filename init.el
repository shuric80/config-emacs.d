;; Performance tweaking for modern machines
(setq gc-cons-threshold 100000000)
(setq read-process-output-max (* 1024 1024))


(setq package-archives
      '(("elpy" . "http://jorgenschaefer.github.io/packages/")
        ("melpa" . "https://melpa.org/packages/")
))

;; Hide UI
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
;; "Don't show splash screen"
(setq inhibit-startup-screen t)
(use-package gcmh
  :ensure t
  :demand t
  :config
  (gcmh-mode 1))


;; Better default modes
(electric-pair-mode t)
(show-paren-mode 1)
(setq-default indent-tabs-mode nil)
(save-place-mode t)
(savehist-mode t)
(recentf-mode t)
(global-auto-revert-mode t)
(use-package system-packages
  :ensure t
  :custom
  (system-packages-noconfirm t))

(use-package use-package-ensure-system-package :ensure t)

(use-package paradox
  :ensure t
  :defer 1
  :config
  (paradox-enable))

(use-package frame
  :bind
  ("C-z" . nil)
  :custom
  (initial-frame-alist '((vertical-scroll-bars))))

(use-package ibuffer
  :bind
  ([remap list-buffers] . ibuffer))

(use-package help
  :defer t
  :bind
  (("C-?" . help-command)
   :map mode-specific-map
   ("h" . help-command)))

(use-package files
  :hook
  (before-save . delete-trailing-whitespace)
  :custom
  (require-final-newline t)
  ;; backup settings
  (backup-by-copying t)
  (backup-directory-alist
   `((".*" . ,(locate-user-emacs-file "backups"))))
  (delete-old-versions t)
  (kept-new-versions 6)
  (kept-old-versions 2)
  (version-control t))

(use-package autorevert
  :defer 0.1)

(use-package recentf
  :defer 0.1
  :custom
  (recentf-auto-cleanup 30)
  :config
  (recentf-mode)
  (run-with-idle-timer 30 t 'recentf-save-list))

(use-package em-smart
  :defer t
  :config
  (eshell-smart-initialize)
  :custom
  (eshell-where-to-jump 'begin)
  (eshell-review-quick-commands nil)
  (eshell-smart-space-goes-to-end t))

(use-package esh-help
  :ensure t
  :defer t
  :config
  (setup-esh-help-eldoc))

(use-package esh-autosuggest
  :ensure t
  :hook (eshell-mode . esh-autosuggest-mode))

(use-package esh-module
  :defer t
  :custom
  (eshell-modules-list '(eshell-tramp)))

(use-package eshell-prompt-extras
  :ensure t
  :after (eshell esh-opt)
  :custom
  (eshell-prompt-function #'epe-theme-dakrone))

(use-package eshell-toggle
  :ensure t
  :after projectile
  :custom
  (eshell-toggle-use-projectile-root t)
  (eshell-toggle-run-command nil)
  :bind
  ("M-`" . eshell-toggle))


(use-package ls-lisp
  :defer t
  :custom
  (ls-lisp-emulation 'MS-Windows)
  (ls-lisp-ignore-case t)
  (ls-lisp-verbosity nil))

(use-package dired
  :custom (dired-dwim-target t "guess a target directory")
  :hook
  (dired-mode . dired-hide-details-mode))

(use-package dired-x
  :bind
  ([remap list-directory] . dired-jump)
  :custom
  ;; do not bind C-x C-j since it's used by jabber.el
  (dired-bind-jump nil))

(use-package dired-toggle
  :ensure t
  :defer t)

(use-package dired-hide-dotfiles
  :ensure t
  :bind
  (:map dired-mode-map
        ("." . dired-hide-dotfiles-mode))
  :hook
  (dired-mode . dired-hide-dotfiles-mode))

(use-package diredfl
  :ensure t
  :hook
  (dired-mode . diredfl-mode))

(use-package async
  :ensure t
  :defer t
  :custom
  (dired-async-mode 1))

(use-package dired-rsync
  :ensure t
  :bind
  (:map dired-mode-map
        ("r" . dired-rsync)))

(use-package dired-launch
  :ensure t
  :hook
  (dired-mode . dired-launch-mode))

;; (use-package dired-git-info
;;   :ensure t
;;   :bind
;;   (:map dired-mode-map
;;         (")" . dired-git-info-mode)))

(use-package dired-recent
  :ensure t
  :bind
  (:map
   dired-recent-mode-map ("C-x C-d" . nil))
  :config
  (dired-recent-mode 1))

(use-package faces
  :custom
  (face-font-family-alternatives
   '(("Monospace" "courier" "fixed")
     ("Consolas" "Monaco" "Roboto Mono" "PT Mono" "Terminus" "Monospace")
     ("Monospace Serif" "CMU Typewriter Text" "Courier 10 Pitch" "Monospace")
     ("Serif" "Alegreya" "CMU Serif" "Georgia" "Cambria" "Times New Roman" "DejaVu Serif" "serif")))
  :custom-face
  (variable-pitch ((t (:family "Serif" :height 135))))
  (fixed-pitch ((t (:family "Monospace Serif" :height 125))))
  (default ((t (:family "Monospace Serif" :height 125)))))

(use-package font-lock
  :defer t
  :custom-face
  (font-lock-comment-face ((t (:inherit font-lock-comment-face :italic t))))
  (font-lock-doc-face ((t (:inherit font-lock-doc-face :italic t))))
  (font-lock-string-face ((t (:inherit font-lock-string-face :italic t)))))

	(use-package open-color
  ;;:quelpa
  ;;(open-color :repo "a13/open-color.el" :fetcher github :version original)
)

(use-package lor-oc-theme
  :config
  (load-theme 'lor-oc t)
  :load-path "/home/dk/git/lor-theme"
  ;; :quelpa
  ;; (lor-theme :repo "a13/lor-theme" :fetcher github :version original)
  )

(use-package lsp-python-ms
  :ensure t
  :init (setq lsp-python-ms-auto-install-server t)
  :hook (python-mode . (lambda ()
                         (require 'lsp-python-ms)
                         (lsp))))  ; or lsp-deferred




(use-package eglot
  :ensure t
  :defer t
  :bind (:map eglot-mode-map
              ("C-c C-d" . eldoc)
              ("C-c C-e" . eglot-rename)
              ("C-c C-o" . python-sort-imports)
              ("C-c C-f" . eglot-format-buffer))
  :hook ((python-mode . eglot-ensure)
         (python-mode . flyspell-prog-mode)
         (python-mode . superword-mode)
         (python-mode . hs-minor-mode)
         (python-mode . (lambda () (set-fill-column 88))))
  :config
  (setq-default eglot-workspace-configuration
                '((:pylsp . (:configurationSources ["flake8"]
                                                   :plugins (
                                                             :pycodestyle (:enabled :json-false)
                                                             :mccabe (:enabled :json-false)
                                                             :pyflakes (:enabled :json-false)
                                                             :flake8 (:enabled :json-false
                                                                               :maxLineLength 88)
                                                             :ruff (:enabled t
                                                                             :lineLength 88)
                                                             :pydocstyle (:enabled t
                                                                                   :convention "numpy")
                                                             :yapf (:enabled :json-false)
                                                             :autopep8 (:enabled :json-false)
                                                             :black (:enabled t
                                                                              :line_length 88
                                                                              :cache_config t)))))))


(use-package lsp-pyright
  :ensure t
  :hook (python-mode . (lambda ()
                         (require 'lsp-pyright)
                         (lsp))))  ; or lsp-deferred
