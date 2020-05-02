;;; guide-todo.el --- Guide Todo Minor Mode          -*- lexical-binding: t; -*-

;; Copyright (C) 2020  Hakan Tunc

;; Author: Hakan Tunc
;; Keywords: calendar

;;; Code:

(defun guide-v2-move-down ()
  (interactive)
  (let ((amount (guide-v2-get-fixed-schedule)))
    (condition-case nil
        (if amount
            (cl-loop repeat amount do
                     (org-metadown))
          (while t
            (org-metadown)))
      (user-error nil))))

(defun guide-v2-get-fixed-schedule ()
  (let ((gfs (org-entry-get nil "GuideFixedSchedule")))
    (if gfs
        (string-to-number gfs)
      nil)))

(provide 'guide-todo)
;;; guide-todo.el ends here
