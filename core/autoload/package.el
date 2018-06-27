;;;###autoload
(defun moon-jump-to-config-or-package (type)
  "Jump to a TYPE file of a star.
If TYPE is 'config, go to config.el,
if TYPE is 'package, go to package.el,
if TYPE is 'readme, go to README.el,
if TYPE is 'autoload, go to autoload.el,
if TYPE is 'autoload-dir, go to autoload/."
  (let ((star-path (completing-read "Select a star: " moon-star-path-list))
        (file-name-plist '(config "config.el" package "package.el"
                                  readme "README.el" autoload "autoload.el"
                                  autoload-dir "autoload/")))
    (find-file (concat star-path (plist-get file-name-plist type)))))


;;;###autoload
(defun moon/jump-to-config ()
  "Jump to config file of a star."
  (interactive)
  (moon-jump-to-config-or-package 'config))

;;;###autoload
(defun moon/jump-to-package ()
  "Jump to package file of a star."
  (interactive)
  (moon-jump-to-config-or-package 'package))

;;;###autoload
(defun moon/jump-to-autoload ()
  "Jump to autoload file of a star."
  (interactive)
  (moon-jump-to-config-or-package 'autoload))

;;;###autoload
(defun moon/jump-to-readme ()
  "Jump to readme file of a star."
  (interactive)
  (moon-jump-to-config-or-package 'readme))

;;;###autoload
(defun moon/jump-to-autoload-dir ()
  "Jump to autoload directory of a star."
  (interactive)
  (moon-jump-to-config-or-package 'autoload-dir))

;;;###autoload
(defun moon/check-config ()
  "Check if ther is anything wrong with your star config."
  (interactive)
  )


;;;###autoload
(defun moon-check-package (config-file package-file)
  "Check if all the packages in `use-package|' `config.el' are declared in `package|' in `package.el'."
  (let ((package-list ()))
    (while (re-search-forward "use-package.? \\(.+?\\)\\b" nil t)
      (add-to-list 'package-list (match-string-no-properties 1)))))


;;;###autoload
(defun moon/run-test ()
  "Run tests."
  (interactive)
  (save-buffers-kill-emacs))
