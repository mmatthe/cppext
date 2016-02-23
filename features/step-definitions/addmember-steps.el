;; This file contains your project specific step definitions. All
;; files in this directory whose names end with "-steps.el" will be
;; loaded automatically by Ecukes.

(Given "^I open file \"\\([^\"]+\\)\"$"
      (lambda (file)
	(find-file-existing (f-join cppext-features-path "data/" file))))

(When "^I call addmember with \"\\([^\"]+\\)\"$"
      (lambda (sign)
	(When "I start an action chain")
	(When "I press \"M-x\"")
	(When "I type \"cppext/addmember\"")
	(When "I press \"<return>\"")
	(When (format "I type \"%s\"" sign))
	(When "I execute the action chain")))

(Given "^I have \"\\(.+\\)\"$"
  (lambda (something)
    (message something)
    ))

(When "^I have \"\\(.+\\)\"$"
  (lambda (something)
    ;; ...
    ))

(Then "^I should have \"\\(.+\\)\"$"
  (lambda (something)
    ;; ...
    ))

(And "^I have \"\\(.+\\)\"$"
  (lambda (something)
    ;; ...
    ))

(But "^I should not have \"\\(.+\\)\"$"
  (lambda (something)
    ;; ...
    ))
