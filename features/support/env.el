(require 'f)

(defvar cppext-support-path
  (f-dirname load-file-name))

(defvar cppext-features-path
  (f-parent cppext-support-path))

(defvar cppext-root-path
  (f-parent cppext-features-path))

(add-to-list 'load-path cppext-root-path)

(require 'cppext)
(require 'espuds)
(require 'ert)

(Setup
 ;; Before anything has run
 )

(Before
 ;; Before each scenario is run
 )

(After
 ;; After each scenario is run
 )

(Teardown
 ;; After when everything has been run
 )
