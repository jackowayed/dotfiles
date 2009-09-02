;;; XEmacs backwards compatibility file
;;;(setq user-init-file
;;;      (expand-file-name "init.el"
;;;                        (expand-file-name ".xemacs" "~")))
;;;(setq custom-file
;;;      (expand-file-name "custom.el"
;;;                        (expand-file-name ".xemacs" "~")))

(message "IN YUR DOT EMACS LOADIN YUR LISPS")
;; (load-file user-init-file)
;; (load-file custom-file)
(setq load-path (cons "~/.emacs.d" load-path))
(require 'rails)
(require 'find-recursive)


(autoload 'ruby-mode "ruby-mode"
      "Mode for editing ruby source files" t)
    (setq auto-mode-alist
          (append '(("\\.rb$" . ruby-mode)) auto-mode-alist))
    (setq interpreter-mode-alist (append '(("ruby" . ruby-mode))
                                     interpreter-mode-alist))



(autoload 'run-ruby "inf-ruby"
      "Run an inferior Ruby process")
    (autoload 'inf-ruby-keys "inf-ruby"
      "Set local key defs for inf-ruby in ruby-mode")
    (add-hook 'ruby-mode-hook
          '(lambda ()
             (inf-ruby-keys)
    ))

(add-to-list 'loadpath
      "/home/daniel/.emacs.d/ecb-2.32")
(defvar user-temporary-file-directory
  (concat temporary-file-directory user-login-name "/"))
(make-directory user-temporary-file-directory t)
(setq backup-by-copying t)
(setq backup-directory-alist
      `(("." . ,user-temporary-file-directory)
        (,tramp-file-name-regexp nil)))
(setq auto-save-list-file-prefix
      (concat user-temporary-file-directory ".auto-saves-"))
(setq auto-save-file-name-transforms
      `((".*" ,user-temporary-file-directory t)))
(require 'twittering-mode)
(setq twittering-username "jackowayed")
(setq twittering-password "j4t3#t")
(defun word-count nil "Count words in buffer" (interactive)
  (shell-command-on-region (point-min) (point-max) "wc -w"))
