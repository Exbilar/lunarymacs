;;; eglot.el --- Eglot Config      -*- lexical-binding: t; -*-


;;; Commentary:
;;

;;; Code:
;;

;;; Keys

(with-eval-after-load 'general
  (luna-default-leader
   "l f" #'eglot-format-buffer
   "l R" #'eglot-rename
   "l d" #'xref-find-definitions
   "l r" #'xref-find-references
   "l k" #'eldoc-box-quit-frame
   "l s" #'eldoc-box-show-frame)
  (general-define-key
   "C-h C-h" #'eldoc-box-eglot-help-at-point))

;;; Packages

(load-package eglot
  :defer t
  :config
  ;; (add-to-list 'eglot-ignored-server-capabilites :hoverProvider)
  )

(load-package eldoc-box
  :commands (eldoc-box-hover-mode
             eldoc-box-eglot-help-at-point
             eldoc-box-helpful-callable
             eldoc-box-helpful-variable
             eldoc-box-helpful-key)
  :init
  ;; (add-hook 'eglot--managed-mode-hook #'eldoc-box-hover-mode t)
  (setq eldoc-box-cleanup-interval 0.2
        eldoc-box-clear-with-C-g t))

;;; Function


;;; eglot.el ends here
