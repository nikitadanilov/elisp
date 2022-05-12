(defun ros-hook ()
  ""
  (interactive)
  (let ((path (expand-file-name buffer-file-name)))
    (mapcar
     (lambda (x)
       (if (string-match (car x) path)
	   (let ((suffix (substring path (match-end 0))))
	     (save-window-excursion
	       (async-shell-command
		 (format (cdr x) path (file-name-directory suffix) suffix))))))
     ros-dirs)))

(define-minor-mode ros-mode
  "A local mode to automatically rsync buffers on save."
  :lighter " ros"
  :global t
  (cond (ros-mode (add-hook    'after-save-hook 'ros-hook))
        (t        (remove-hook 'after-save-hook 'ros-hook))))

(defgroup ros nil "rsync on save")
(defcustom ros-dirs nil "A list of pairs (path . cmd).

Here PATH is a regexp matching a buffer path on the source system
and CMD is a format string with 3 arguments: (1) absolute local
path to the file being transferred, (3) local path, relative to
PATH, (2) directory part of the local path.

For example: 

((\"/home/user/projects/foo\" . \"rsync --rsync-path=\\\"mkdir -p '/home/other/%2$s' && rsync\\\" -azq '%1$s' 'other@vm:/home/other/%3$s'\"))"
  :group 'ros
  :type '(repeat (cons string string)))
(provide 'ros)

