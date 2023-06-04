
;; Performance tweaking for modern machines
(setq gc-cons-threshold 100000000)
(setq read-process-output-max (* 1024 1024))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

;; Hide UI
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; Better default modes
(electric-pair-mode t)
(show-paren-mode 1)
(setq-default indent-tabs-mode nil)
(save-place-mode t)
(savehist-mode t)
(recentf-mode t)
(global-auto-revert-mode t)

;; Better default settings
(require 'uniquify)
(setq uniquify-buffer-name-style 'forward
      window-resize-pixelwise t
      frame-resize-pixelwise t
      load-prefer-newer t
      backup-by-copying t
      custom-file (expand-file-name "custom.el" user-emacs-directory))
(add-hook 'prog-mode-hook 'display-line-numbers-mode)

;; Refresh package archives (GNU Elpa)
;;(unless package-archive-contents
;;  (package-refresh-contents))

;; ;; Great looking theme
;; (use-package modus-themes
;;   :ensure t
;;   :init
;;   (modus-themes-load-themes)
;;   :config
;;   (modus-themes-load-vivendi))

;; Code completion at point
;; (use-package company
;;   :ensure t
;;   :hook (after-init . global-company-mode)
;;   :custom
;;   (company-idle-delay 0))

;; Better minibuffer completion
(use-package vertico
  :ensure t
  :custom
  (vertico-cycle t)
  (read-buffer-completion-ignore-case t)
  (read-file-name-completion-ignore-case t)
  (completion-styles '(basic substring partial-completion flex))
  :init
  (vertico-mode))

;; Save minibuffer results
(use-package savehist
  :init
  (savehist-mode))

;; Show lots of useful stuff in the minibuffer
(use-package marginalia
  :after vertico
  :ensure t
  :init
  (marginalia-mode))


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


(use-package pyvenv
  :demand t
  :config
  (setq pyvenv-workon "emacs")  ; Default venv
  (pyvenv-tracking-mode 1))


;;GIT
(use-package magit
 :demand t
 :config
 (progn
   (defun md/magit-quit ()
     (interactive)
     (magit-mode-bury-buffer)
     (shackle--eyebrowse-close-slot-by-tag "git"))

   (evil-define-key 'normal magit-mode-map
     (kbd "TAB") 'magit-section-toggle
     (kbd "<RET>") 'magit-visit-thing
     "q" 'md/magit-quit
     "r" 'magit-refresh
     "n" 'magit-section-forward
     "p" 'magit-section-backward
     "+" 'magit-stage-file
     "-" 'magit-unstage-file
     "[" 'magit-diff-less-context
     "]" 'magit-diff-more-context
     )
   ;;(setq magit-display-buffer-function 'magit-display-buffer-fullframe-status-v1)
   (setq magit-display-buffer-function 'display-buffer)

   ;; I don't know why, but by default I can't get magit-blame to adhere to my
   ;; normal-mode map below, even though Evil says I'm in normal mode. Explicitly
   ;; calling evil-normal-state fixes it.
   (evil-define-key 'normal magit-blame-mode-map
     (kbd "<RET>") 'magit-show-commit
     "q" 'magit-blame-quit
     "gj" 'magit-blame-next-chunk
     "gn" 'magit-blame-next-chunk
     "gk" 'magit-blame-previous-chunk
     "gp" 'magit-blame-previous-chunk)

   (add-hook 'magit-revision-mode-hook 'evil-normal-state)
 :bind (:map md/leader-map
       ("gg" . magit-status)
       ("gm" . magit-dispatch-popup)
       ("gb" . magit-blame)
       ("gl" . magit-log-head)

       ;; Diff gives the full git diff output. Ediff shows ediff for a single
       ;; file.
       ("gd" . magit-diff-buffer-file)
       ("gD" . magit-diff-dwim)
       ("ge" . magit-ediff-popup)

       ;; NOTE - this doesn't play nicely with mode-line:
       ;; - https://github.com/magit/magit/blob/master/Documentation/magit.org#the-mode-line-information-isnt-always-up-to-date
       ;; - https://github.com/syl20bnr/spacemacs/issues/2172
       ("gC" . magit-commit-popup)
       ("gc" . magit-checkout)))
;;YAML
(use-package yaml-mode :demand t)

;;MARKDOWN
(use-package markdown-mode
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.gfm\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.apib\\'" . markdown-mode)  ; Apiary
         ("\\.markdown\\'" . markdown-mode))
  :config (progn
            ;; Markdown-cycle behaves like org-cycle, but by default is only
            ;; enabled in insert mode. gfm-mode-map inherits from
            ;; markdown-mode-map, so this will enable it in both.
            (evil-define-key 'normal markdown-mode-map
              (kbd "TAB") 'markdown-cycle
              "gk" 'markdown-previous-visible-heading
              "gj" 'markdown-next-visible-heading)))


(use-package dockerfile-mode)


