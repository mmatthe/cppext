;;; addmember: add a member function to an open C++ class (header + source in separate files)

(setq am/rxmemberfunc " \\([A-Za-z0-9]+\\)::[A-Za-z0-9]+(.*)\\(\s+const\\)?\s*\n\s*{")

(defun cppext/addmember () (interactive)
  (let* ((class (am/get-current-class-name))
	(sign (am/read-function-signature class)))
    (am/add-declaration sign class)
    (am/add-definition (am/member-function-implementation-text sign class))
    (message (format "Added the new member to %s" class))))

(defun am/get-current-class-name () (interactive)
  (save-excursion
    (progn
      (search-backward-regexp am/rxmemberfunc)
      (match-string 1))))

(defun am/read-function-signature (class) (interactive)
  (read-from-minibuffer (format "Add method to class %s: " class)))

(defun am/member-function-implementation-text (signature class)
  (concat
   (replace-regexp-in-string "\\(\\w+\\)(\\(.*\\))"
			     (format "%s::\\1(\\2)" class)
			     signature)
   " {\n\n}\n\n"))

(defun am/add-definition (text)
  (c-end-of-defun)
  (insert "\n" text)
  (previous-line 3)
  (indent-relative))

(defun am/add-declaration (signature class) (interactive)
  (let* ((buf (am/find-buffer-with-class class)))
    (unless buf
      (error (format "I couldn't find the buffer with the class definition for class %s. Is it open?" class)))
    (with-current-buffer buf
      (save-excursion
	(if (am/move-to-declaration-insertion-point class)
	    (insert signature ";")
	  (error "I couldn't find the insertion point"))))))

(defun am/find-buffer-with-class (name) (interactive)
  (setq res nil)
  (let ((buffers (cdr (buffer-list))))
    (while buffers
      (let ((buf (car buffers)))
	(if (am/is-class-in-buffer name buf)
	    (progn
	      (setq res buf)
	      (setq buffers nil))
	  (setq buffers (cdr buffers)))))
    res))

(defun am/is-class-in-buffer (name buf)
  (with-current-buffer buf
    (save-excursion
      (goto-char (point-min))
      (condition-case nil
	  (progn
	    (search-forward-regexp (format "class\s+%s\\(\s+:\s*.*\\)?\n?\s*{" name))
	    t)
	(error nil)))))

(defun am/move-to-declaration-insertion-point (class)
  (condition-case ex
      (progn
	(goto-char (point-min))
	(search-forward-regexp (format "class\s+%s" class))
	(search-forward "// AUTOMATIC INSERTION POINT")
	(end-of-line)
	(insert "\n")
	(indent-relative)
	t)
    ('error nil)))





(provide 'cppext-addmember)
;;; addmembel.el ends here
