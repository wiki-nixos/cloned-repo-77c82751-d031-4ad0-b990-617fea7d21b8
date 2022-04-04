(after! magit
  (setq magit-diff-refine-hunk 'all
        magit-repository-directories '(("~/src" . 3)))
  ;; automaticailly refresh magit buffers when files are saved
  (add-hook! 'after-save-hook #'magit-after-save-refresh-status))

(after! forge
  (setq  forge-topic-list-limit '(100 . -10)
         forge-owned-accounts '(("loganlinn"
                                 "patch-tech"
                                 "plumatic"
                                 "omcljs"))))
