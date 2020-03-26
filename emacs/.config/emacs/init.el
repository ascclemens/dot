;; installed packages
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(inhibit-startup-screen t)
 '(package-selected-packages
   '(nhexl-mode lsp-mode rustic sql-indent web-mode dockerfile-mode yaml-mode flycheck base16-theme move-text ## company-quickhelp aggressive-indent smartparens mwim rainbow-delimiters anzu magit-lfs highlight-indent-guides magit ace-window atom-one-dark-theme company neotree))
 '(require-final-newline t)
 '(safe-local-variable-values '((engine . jinja)))
 '(sp-highlight-pair-overlay nil))

;; add melpa packages
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/"))
(package-initialize)

;; set kill-whole-line to C-c k
(global-set-key (kbd "C-c k") 'kill-whole-line)
;; set neotree to f8
(global-set-key [f8] 'neotree-toggle)
;; rebind M-o to ace-window
(global-set-key (kbd "M-o") 'ace-window)

;; load atom one dark theme
(load-theme 'atom-one-dark t)
;; (setq base16-theme-256-color-source "colors")
;; (load-theme 'base16-tomorrow-night t)

;; set font for gui emacs
(set-frame-font "Fira Code-12" nil t)

;; flycheck
(add-hook 'after-init-hook 'global-flycheck-mode)

;; remove trailing whitespace
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; use spaces for tabs
(setq-default indent-tabs-mode nil)
(setq-default tab-width 2)
(defvaralias 'custom-tab-width 'tab-width)
(defvaralias 'rustic-indent-offset 'tab-width)
(defvaralias 'css-indent-offset 'tab-width)
(setq-default sh-basic-offset 2)
(setq-default sh-indentation 2)

;; show matching parens
(show-paren-mode 1)

;; turn on spellcheck and autofill for text
(add-hook 'text-mode-hook 'turn-on-auto-fill)
(add-hook 'text-mode-hook 'turn-on-flyspell)
;; but turn them off for yaml
(add-hook 'yaml-mode-hook 'turn-off-auto-fill)
(add-hook 'yaml-mode-hook 'turn-off-flyspell)

;; use web-mode for web stuff
(add-to-list 'auto-mode-alist '("\\.html\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html.tera\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.css\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.scss\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.js\\'" . web-mode))
(setq web-mode-enable-engine-detection t)
(setq web-mode-markup-indent-offset 2)
(setq web-mode-css-indent-offset 2)
(setq web-mode-code-indent-offset 2)

;; show commit formatting
(add-to-list 'auto-mode-alist '("COMMIT_EDITMSG$" . diff-mode))

;; unified diffs
(setq diff-switches "-u -w")

;; show column, as well
(setq column-number-mode 2)

;; magit
(global-set-key (kbd "C-x g") 'magit-status)

;; handle indentation with C-a/C-e
(global-set-key (kbd "C-a") 'mwim-beginning)
(global-set-key (kbd "C-e") 'mwim-end)

;; move lines with M-up/M-down
(global-set-key (kbd "<M-up>") 'move-text-up)
(global-set-key (kbd "<M-down>") 'move-text-down)

;; Behave like vi's o command
(defun open-next-line (arg)
  "Move to the next line and then opens a line.
    See also `newline-and-indent'."
  (interactive "p")
  (end-of-line)
  (open-line arg)
  (next-line 1)
  (when newline-and-indent
    (indent-according-to-mode)))

;; Behave like vi's O command
(defun open-previous-line (arg)
  "Open a new line before the current one.
     See also `newline-and-indent'."
  (interactive "p")
  (beginning-of-line)
  (open-line arg)
  (when newline-and-indent
    (indent-according-to-mode)))

;; do open next/prev line with M-n/M-p
(global-set-key (kbd "M-n") 'open-next-line)
(global-set-key (kbd "M-p") 'open-previous-line)
(defvar newline-and-indent t)

;; anzu (match index/count)
(global-anzu-mode 1)

;; indent sql
(add-hook 'sql-mode-hook 'sqlind-minor-mode)

;; rainbow delimiters when editing code
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)

;; highlight indent guides
(add-hook 'prog-mode-hook 'highlight-indent-guides-mode)
(setq highlight-indent-guides-method 'fill)

;; smartparens for code
(require 'smartparens-config) ; load lang configs as well
(add-hook 'prog-mode-hook 'smartparens-mode)

;; aggressively indent code
(global-aggressive-indent-mode 1)

;; turn on line numbers but not for term or neotree
(global-display-line-numbers-mode 1)
(add-hook 'neo-after-create-hook (lambda(&rest _) (display-line-numbers-mode -1)))
(add-hook 'term-mode-hook (lambda() (display-line-numbers-mode -1)))

;; enable rust
;; (require 'rust-mode)
;; (add-hook 'rust-mode-hook 'cargo-minor-mode)
;; (add-hook 'rust-mode-hook 'racer-mode)
;; (add-hook 'racer-mode-hook 'eldoc-mode)
;; (add-hook 'racer-mode-hook 'company-mode)
;; (add-hook 'racer-mode-hook 'company-quickhelp-mode)
;; (with-eval-after-load 'rust-mode
;;   (add-hook 'flycheck-mode-hook #'flycheck-rust-setup))
;; (define-key rust-mode-map (kbd "TAB") 'company-indent-or-complete-common)
;; (setq company-tooltip-align-annotations 1)

(require 'flycheck)
(require 'rustic)
(require 'smartparens-rust)
(setq rustic-lsp-server 'rust-analyzer)
(add-hook 'rustic-mode-hook #'lsp)
(sp-with-modes 'rustic-mode
  (sp-local-pair "'" "'"
                 :unless '(sp-in-comment-p sp-in-string-quotes-p sp-in-rust-lifetime-context)
                 :post-handlers'(:rem sp-escape-quotes-after-insert))
  (sp-local-pair "<" ">"
                 :when '(sp-rust-filter-angle-brackets)
                 :skip-match 'sp-rust-skip-match-angle-bracket))

;; turn on ido mode and separate by newline
(ido-mode 1)
(setq ido-separator "\n")

;; don't put backup files in same dir
(setq
 backup-by-copying t
 backup-directory-alist '(("." . "~/.local/share/emacs/backups/"))
 delete-old-versions t
 kept-new-versions 6
 kept-old-versions 2
 version-control t)

;; put autosaves in temp dir
(setq auto-save-file-name-transforms
      `((".*", temporary-file-directory t)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
