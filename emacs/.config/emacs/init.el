;; This is currently symlinked into ~/.emacs.el.

;; emacs now has support for XDG_CONFIG_DIR, but Fedora 31 does not
;; yet have a new enough emacs.

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

;; flycheck
(add-hook 'after-init-hook 'global-flycheck-mode)

;; use spaces for tabs
(setq indent-tabs-mode nil)
(setq custom-tab-width 2)
(setq rust-indent-offset 2)

;; show column, as well
(setq column-number-mode 2)

;; handle indentation with C-a/C-e
(global-set-key (kbd "C-a") 'mwim-beginning)
(global-set-key (kbd "C-e") 'mwim-end)

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

;; rainbow delimiters when editing code
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)

;; highlight indent guides
(add-hook 'prog-mode-hook 'highlight-indent-guides-mode)
(setq highlight-indent-guides-method 'fill)

;; smartparens for code
(add-hook 'prog-mode-hook 'smartparens-mode)

;; aggressively indent code
(global-aggressive-indent-mode 1)

;; enable rust
(require 'rust-mode)
(add-hook 'rust-mode-hook 'cargo-minor-mode)
(add-hook 'rust-mode-hook 'racer-mode)
(add-hook 'racer-mode-hook 'eldoc-mode)
(add-hook 'racer-mode-hook 'company-mode)
(add-hook 'racer-mode-hook 'company-quickhelp-mode)
(with-eval-after-load 'rust-mode
  (add-hook 'flycheck-mode-hook 'flycheck-rust-setup))
(define-key rust-mode-map (kbd "TAB") 'company-indent-or-complete-common)
(setq company-tooltip-align-annotations 1)

;; turn on ido mode and separate by newline
(ido-mode 1)
(setq ido-separator "\n")

;; installed packages
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (flycheck-rust company-quickhelp aggressive-indent smartparens mwim rainbow-delimiters anzu magit-lfs highlight-indent-guides magit ace-window atom-one-dark-theme company racer cargo rust-mode neotree)))
 '(sp-highlight-pair-overlay nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
