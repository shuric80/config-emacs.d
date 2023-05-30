;; .emacs.d/init.el


;; ===================================

;; MELPA Package Support

;; ===================================

;; Enables basic packaging support

(require 'package)

;; Adds the Melpa archive to the list of available repositories

(add-to-list 'package-archives

             '("melpa" . "http://melpa.org/packages/") t)
;; Initializes the package infrastructure

(package-initialize)


;; If there are no archived package contents, refresh them

(when (not package-archive-contents)

  (package-refresh-contents))

(setq inhibit-startup-message t)

;; Disable tool bar, menu bar, scroll bar.
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

;; Highlight current line.
(global-hl-line-mode t)

(add-to-list 'load-path "~/.emacs.d/modus-themes")

(use-package ibuffer
  :bind
  ([remap list-buffers] . ibuffer))

(use-package lsp-mode
  :config
  (setq lsp-idle-delay 0.5
        lsp-enable-symbol-highlighting t
        lsp-enable-snippet nil  ;; Not supported by company capf, which is the recommended company backend
        lsp-pyls-plugins-flake8-enabled t)
  (lsp-register-custom-settings
   '(("pyls.plugins.pyls_mypy.enabled" t t)
     ("pyls.plugins.pyls_mypy.live_mode" nil t)
     ("pyls.plugins.pyls_black.enabled" t t)
     ("pyls.plugins.pyls_isort.enabled" t t)

     ;; Disable these as they're duplicated by flake8
     ("pyls.plugins.pycodestyle.enabled" nil t)
     ("pyls.plugins.mccabe.enabled" nil t)
     ("pyls.plugins.pyflakes.enabled" nil t)))
  :hook
  ((python-mode . lsp)
   (lsp-mode . lsp-enable-which-key-integration))
  :bind (:map evil-normal-state-map
              ("gh" . lsp-describe-thing-at-point)
              :map md/leader-map
              ("Ff" . lsp-format-buffer)
              ("FR" . lsp-rename)))

(use-package lsp-ui
  :config (setq lsp-ui-sideline-show-hover t
                lsp-ui-sideline-delay 0.5
                lsp-ui-doc-delay 5
                lsp-ui-sideline-ignore-duplicates t
                lsp-ui-doc-position 'bottom
                lsp-ui-doc-alignment 'frame
                lsp-ui-doc-header nil
                lsp-ui-doc-include-signature t
                lsp-ui-doc-use-childframe t)
  :commands lsp-ui-mode
  :bind (:map evil-normal-state-map
              ("gd" . lsp-ui-peek-find-definitions)
              ("gr" . lsp-ui-peek-find-references)
              :map md/leader-map
              ("Ni" . lsp-ui-imenu)))


