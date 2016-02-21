(defun mm/compile () (interactive)
  "If a variable 'mm/proj-build-dir' is available, run make in
this directory. Otherwise, run the normal compile-function"
  (if (boundp 'mm/proj-build-dir)
      (let ((cmd (concat "cd " mm/proj-build-dir " && make -j8")))
	(compile cmd))
    (call-interactively 'compile)))


(defun mm/get-list-elem (n listOrVar)
  (if (listp listOrVar)
	  (nth n listOrVar)
	listOrVar))

(defun mm/run-compiled-program (workdir bindir exec)
  (let ((cmd (concat "cd " workdir " && " bindir exec)))
	(compile cmd)))
(defun mm/test-bindir () (concat mm/proj-build-dir mm/test-dir))

(defun mm/run-unit-tests (n) (interactive)
  (mm/run-compiled-program (mm/test-bindir) (mm/test-bindir) mm/unit-test-exec))

(defun mm/run-integration-tests (n) (interactive)
  (mm/run-compiled-program (mm/test-bindir) (mm/test-bindir) (mm/get-list-elem n mm/integration-test-exec)))

(defun mm/run-ctest () (interactive)
  (mm/run-compiled-program (mm/test-bindir) "" "ctest --output-on-failure"))

(defun mm/run-main (n) (interactive)
  (mm/run-compiled-program (concat mm/proj-root-dir mm/work-dir) mm/proj-build-dir (mm/get-list-elem n mm/main-exec)))

(defun mm/gmocktokillring ()
  (interactive)
  (let ((class (thing-at-point 'word))
	(file (buffer-file-name)))
    (with-temp-buffer
      (shell-command (concat "gmock_gen.py " file " " class) (current-buffer))
      (kill-region (point-min) (point-max))
      )))


(defun mm/c-mode-keys () (interactive)
  (local-set-key (kbd "C-c C-r C-t") (lambda () (interactive) (mm/run-unit-tests 0)))
  (local-set-key (kbd "C-c C-r C-c") 'mm/run-ctest)
  (local-set-key (kbd "C-c C-r C-i") (lambda () (interactive) (mm/run-integration-tests 0)))
  (local-set-key (kbd "C-c C-r C-r") (lambda () (interactive) (mm/run-main 0)))
  (local-set-key (kbd "C-c C-c") 'mm/compile)
  (local-set-key (kbd "C-c C-f") 'clang-format-region)

  (local-set-key (kbd "C-c r m") 'am/add-member)

  (local-set-key (kbd "C-c <") 'rtags-location-stack-back)
  (local-set-key (kbd "C-c >") 'rtags-location-stack-forward)

  (local-set-key (kbd "C-c C-m") 'mm/gmocktokillring)
)
(add-hook 'c-mode-common-hook 'mm/c-mode-keys)


(provide 'cppext)
