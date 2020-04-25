;;; guide-todo.el --- Guide Todo Minor Mode          -*- lexical-binding: t; -*-

;; Copyright (C) 2020  Hakan Tunc

;; Author: Hakan Tunc
;; Keywords: calendar

;;; Code:

(defun guide-v2-move-down ()
  (interactive)
  (cl-loop repeat (guide-v2-get-fixed-schedule) do
           (org-metadown)))

(defun guide-v2-get-fixed-schedule ()
  (string-to-number
   (org-entry-get nil "GuideFixedSchedule")))

(provide 'guide-todo)
;;; guide-todo.el ends here
