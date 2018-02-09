;; export init.org to init.html
(require 'org)
(require 'ox-html)
(defun export-init-to-html()
  (find-file "init.org")
  (org-html-export-to-html))
