;;; -*- lexical-binding: t -*-

;;; Variables

(defvar luna-autoload-file (expand-file-name "autoload.el" user-emacs-directory)
  "The path of autoload file which has all the autoload functions.")

(defvar luna-star-enable-alist nil
  "((star1 . t) (star2 . nil)), then start1 is enabled and star2 is not.")

(defvar luna-cache-dir (expand-file-name "cache" user-emacs-directory)
  "The dir for cache files.")

(defvar luna-package-list nil
  "List of package symbols. Added by ‘load-package’.")

;;; Functions

(defun luna-load-or-create (file &rest args)
  "Load FILE if file exists, otherwise create it.
ARGS is as same as in `load'.
FILE must be absolute path."
  (if (file-exists-p file)
      (apply #'load file args)
    (save-excursion
      (find-file file)
      (save-buffer)
      (kill-buffer))))

(defun luna-load-relative (file &rest args)
  "Load file relative to user-emacs-directory. ARGS are applied to ‘load'."
  (apply #'luna-load-or-create (expand-file-name file user-emacs-directory) args))

(defmacro load-package (package &rest body)
  "Thin wrapper around ‘use-package’. "
  (declare (indent 1))
  `(safe-eval (add-to-list 'luna-package-list ',package t)
              (use-package ,package
                ,@body)))

(defmacro safe-eval (&rest body)
  "Eval BODY and not afraid of error."
  `(condition-case err
       (progn ,@body)
     (error (message (format "Error: %s" (error-message-string err))))))

(defvar luna-prepared-p nil
  "T if ‘luna-before-install-package’ has ran.")

(defun luna-before-install-package ()
  "Setup for installing packages."
  (interactive)
  (require 'cowboy)
  (require 'package)
  (package-initialize t)
  ;; (add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
  (setq package-archives '(("melpa" . "https://elpa.emacs-china.org/melpa/")
                           ("gnu" . "https://elpa.emacs-china.org/gnu/")))
  (package-refresh-contents)
  (setq luna-prepared-p t))

(defun luna-install-all-package ()
  "Install  packages."
  (interactive)
  (display-buffer "*Messages*")
  (unless luna-prepared-p
    (luna-before-install-package))
  (dolist (package luna-package-list)
    (cowboy-install package)))

(defmacro luna-lsp/eglot (lsp eglot)
  "Run LSP or EGLOT based on `luna-lsp'."
  `(pcase luna-lsp
     ('lsp ,lsp)
     ('eglot ,eglot)))

;;; Convienient

(defun luna-jump-to-package (package)
  "Jump to the configuration of package string."
  (interactive (list (completing-read "Package: " (mapcar #'symbol-name luna-package-list))))
  (find-file user-init-file)
  (goto-char (point-min))
  (unless (re-search-forward (format "(load-package %s" package) nil t)
    (message "Not found")))

(provide 'lunary)
