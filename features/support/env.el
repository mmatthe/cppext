(require 'f)

(defvar cppext-support-path
  (f-dirname load-file-name))

(defvar cppext-features-path
  (f-parent cppext-support-path))

(defvar cppext-root-path
  (f-parent cppext-features-path))

(add-to-list 'load-path cppext-root-path)

(require 'cppext)
(require 'cppext-addmember)
(require 'espuds)
(require 'ert)

(Setup
 ;; Before anything has run
 (setq debug-on-error nil)
 )

(Before
 ;; Before each scenario is run
 (save-window-excursion
 (let ((revert-without-query t))
   (mapc (lambda (b)
	   (when (buffer-file-name b)
	     (switch-to-buffer b)
	     (revert-buffer t t)))
	 (buffer-list))))
 )

(After
 ;; After each scenario is run
 )

(Teardown
 ;; After when everything has been run
 )
