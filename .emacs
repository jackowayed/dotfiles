(setq load-path (cons "~/.emacs.d" load-path))


;; emacs-rails

;;; inf-ruby
;;; (1) modify .emacs to use ruby-mode
   (autoload 'ruby-mode "ruby-mode"
     "Mode for editing ruby source files" t)
   (setq auto-mode-alist
         (append '(("\\.rb$" . ruby-mode)) auto-mode-alist))
   (setq interpreter-mode-alist (append '(("ruby" . ruby-mode))
                                     interpreter-mode-alist))

;; ;;(2) set to load inf-ruby and set inf-ruby key definition in ruby-mode.

   (autoload 'run-ruby "inf-ruby"
     "Run an inferior Ruby process")
   (autoload 'inf-ruby-keys "inf-ruby"
     "Set local key defs for inf-ruby in ruby-mode")
   (add-hook 'ruby-mode-hook
         '(lambda ()
            (inf-ruby-keys)
   ))
;; ;; find-recursive
 (require 'find-recursive)

;; ;; emacs-rails itself
(setq load-path (cons "~/.emacs.d/emacs-rails" load-path))
(require 'rails)


(require 'ruby-electric)

     ;;; rhtml-mode
     (add-to-list 'load-path "~/.emacs.d/rhtml")
     (require 'rhtml-mode)
     ;(add-hook 'rhtml-mode-hook
     	  ;(lambda () (rinari-launch)))




;;bindings
;(global-set-key (kbd "C-c c") 'word-count)
(global-set-key (kbd "C-c s") 'rails-lib:run-primary-switch)




(require 'haml-mode nil 't)
(add-to-list 'auto-mode-alist '("\\.haml$" . haml-mode))

;;(add-to-list 'load-path "/path/to/sass-mode.el")
(require 'sass-mode nil 't)
(add-to-list 'auto-mode-alist '("\\.sass$" . sass-mode))
(require 'gist nil 't)
(require 'ruby-mode nil 't)
(add-to-list 'auto-mode-alist '("\\.rb$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.rake$" . ruby-mode))


;; (if window-system
;;     (progn
;;       (global-font-lock-mode 1)
;;       (require 'color-theme)
;;       (color-theme-initialize)
;; ;;      (load-file "~/.elisp/color-theme-github.el")
;;       (load-file "~/.emacs.d/twilight-emacs/color-theme-twilight.el")
;;       (color-theme-twilight)
;; ))
(if window-system
    (progn
      (global-font-lock-mode 1)
      (setq load-path (cons "~/.emacs.d/color-theme-6.6.0" load-path))
      (require 'color-theme)
      (color-theme-initialize)
      (require 'custom-color)
      (custom-color)
;;      (load-file "~/.elisp/color-theme-github.el")
;      (load-file "~/.emacs.d/twilight-emacs/color-theme-twilight.el")

))
;; (require 'color-theme)
;; (color-theme-initialize)
;; (custom-color)

;;http://gist.github.com/19554
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




;;; init.el --- Where all the magic begins

(setq longlines-aut-wrap nil)


(add-to-list 'load-path "~/.emacs.d/vendor/textmate.el")
(require 'textmate)
(textmate-mode)

(setq truncate-partial-width-windows nil)

   (add-to-list 'auto-mode-alist '("\\.js\\'" . javascript-mode))
   (autoload 'javascript-mode "javascript" nil t)
   (require 'yaml-mode)
   (add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))


(autoload 'markdown-mode "markdown-mode.el"
"Major mode for editing Markdown files" t)
(setq auto-mode-alist
(cons '("\\.md" . markdown-mode) auto-mode-alist))

;; Remove splash screen
(setq inhibit-splash-screen t)




;; Key Mappings
(global-set-key (kbd "C-c C-v") 'clipboard-yank)
(global-set-key (kbd "C-c C-d") 'copy-region-as-kill)


(require 'textile-mode)
(add-to-list 'auto-mode-alist '("\\.textile\\'" . textile-mode))

(autoload 'magit-status "magit" nil t)
(global-set-key "\C-ci" 'magit-status)

(require 'open-file-in-github)
(transient-mark-mode)

;; ;; snippet
 (require 'snippet)

;no system beep
(setq visible-bell t)

; http://stackoverflow.com/questions/93415/maximizing-an-emacs-frame-to-just-one-monitor-with-elisp
(defun toggle-fullscreen ()
  "toggles whether the currently selected frame consumes the entire display or is decorated with a window border"
  (interactive)
  (let ((f (selected-frame)))
    (modify-frame-parameters f `((fullscreen . ,(if (eq nil (frame-parameter f 'fullscreen)) 'fullboth nil))))))

(global-set-key (kbd "<f4>") 'toggle-fullscreen)

(require 'latex-repl)

(setq auto-mode-alist
      (append '(("\\.latex$" . latex-mode)) auto-mode-alist))

(require 'word-count-race)

;; Kills all them buffers except scratch
;; optained from http://www.chrislott.org/geek/emacs/dotemacs.html
(defun nuke-all-buffers ()
  "kill all buffers, leaving *scratch* only"
  (interactive)
  (mapcar (lambda (x) (kill-buffer x))
	  (buffer-list))
  (delete-other-windows))

(require 'clojure-mode)


;python-mode
(setq auto-mode-alist (cons '("\\.py$" . python-mode) auto-mode-alist))
(setq interpreter-mode-alist (cons '("python" . python-mode)
				   interpreter-mode-alist))
(autoload 'python-mode "python-mode" "Python editing mode." t)

(tool-bar-mode -1)