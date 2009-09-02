(defun depth-from-git-root ()
  (length (split-string
           (shell-command-to-string "git rev-parse --show-cdup")
           "/")))
 
(defun relative-file-name ()
  (mapconcat 'identity (last
              (split-string (buffer-file-name) "/")
              (depth-from-git-root))
             "/"))
 
(defun my-filter (condp lst)
  (delq nil
        (mapcar (lambda (x) (and (funcall condp x) x)) lst)))
 
(defun current-branchp (branch)
  (if (string-match "^\\* " branch)
      t nil))
 
(defun current-git-branch ()
  (substring
   (car (my-filter 'current-branchp
                   (split-string (shell-command-to-string "git branch") "\n")))
   2))
 
(defun github-repo ()
  (substring
   (replace-regexp-in-string
    ".*:" ""
    (shell-command-to-string "git config remote.origin.url"))
   0 -5))
 
(defun github-url ()
  (concat
   "http://github.com/" (github-repo) "/blob/"
   (current-git-branch) "/" (relative-file-name)))
 
(defun open-file-in-github ()
  (interactive)
  (browse-url (github-url)))

(defun open-file-in-github-line-highlighted ()
  (interactive)
  (browse-url (github-url-line-marked)))

(defun open-file-in-github-region-highlighted ()
  (interactive)
  (browse-url (github-url-region-marked)))

(defun github-url-line-marked ()
  (concat 
   (github-url) "#L" (number-to-string (line-number-at-pos))))

(defun github-url-region-marked ()
  (concat
   (github-url) "#L"
   (number-to-string (min (line-number-at-pos (mark)) (line-number-at-pos (point))))
   "-"
   (number-to-string (max (line-number-at-pos (mark)) (line-number-at-pos (point))))))

(provide 'open-file-in-github)