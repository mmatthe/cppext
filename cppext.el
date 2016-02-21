(defun cppext/compile () (interactive)
  "If a variable 'cppext/proj-build-dir' is available, run make in
this directory. Otherwise, run the normal compile-function"
  (if (boundp 'cppext/proj-build-dir)
      (let ((cmd (concat "cd " cppext/proj-build-dir " && make -j8")))
	(compile cmd))
    (call-interactively 'compile)))

(defun cppext/test-bindir () (concat cppext/proj-build-dir cppext/test-dir))

(defun cppext/run-unit-tests (n) (interactive)
  (interactive)
  (let ((rundir (cppext/test-bindir))
	(bindir (cppext/test-bindir)))
    (cppext/choose-and-run-compiled-program rundir
					    bindir
					    cppext/unit-test-exec
					    "")))

(defun cppext/run-integration-tests ()
  (interactive)
  (let ((rundir (cppext/test-bindir))
	(bindir (cppext/test-bindir)))
    (cppext/choose-and-run-compiled-program rundir
					    bindir
					    cppext/integration-test-exec
					    "")))

(defun cppext/run-ctest () (interactive)
  (cppext/run-compiled-program (cppext/test-bindir) "" "ctest --output-on-failure"))

(setq cppext/last-main-exec "")
(defun cppext/run-main ()
  (interactive)
  (let ((rundir (concat cppext/proj-root-dir cppext/work-dir))
	(bindir cppext/proj-build-dir))
    (setq cppext/last-main-exec
	  (cppext/choose-and-run-compiled-program rundir
						  bindir
						  cppext/main-exec
						  cppext/last-main-exec))))

(defun cppext/choose-and-run-compiled-program (workdir bindir cmds lastcmd)
  (let ((cmdStr (if (listp cmds)
		    (completing-read "Choose executable to run: "
				     cmds
				     nil t lastcmd)
		  cmds)))
    (message cmdStr)
    (cppext/run-compiled-program workdir bindir cmdStr)
    cmdStr))

(defun cppext/run-compiled-program (workdir bindir exec)
  (let ((cmd (concat "cd " workdir " && " bindir exec)))
	(compile cmd)))

(defun cppext/gmocktokillring ()
  (interactive)
  (let ((class (thing-at-point 'word))
	(file (buffer-file-name)))
    (with-temp-buffer
      (shell-command (concat "gmock_gen.py " file " " class) (current-buffer))
      (kill-region (point-min) (point-max))
      )))


(defun cppext/c-mode-keys () (interactive)
  (local-set-key (kbd "C-c C-r C-t") (lambda () (interactive) (cppext/run-unit-tests 0)))
  (local-set-key (kbd "C-c C-r C-c") 'cppext/run-ctest)
  (local-set-key (kbd "C-c C-r C-i") (lambda () (interactive) (cppext/run-integration-tests 0)))
  (local-set-key (kbd "C-c C-r C-r") 'cppext/run-main)
  (local-set-key (kbd "C-c C-c") 'cppext/compile)
  (local-set-key (kbd "C-c C-f") 'clang-format-region)

  (local-set-key (kbd "C-c r m") 'am/add-member)

  (local-set-key (kbd "C-c <") 'rtags-location-stack-back)
  (local-set-key (kbd "C-c >") 'rtags-location-stack-forward)

  (local-set-key (kbd "C-c C-m") 'cppext/gmocktokillring)
)
(add-hook 'c-mode-common-hook 'cppext/c-mode-keys)



(provide 'cppext)
