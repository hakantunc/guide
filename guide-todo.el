;;; guide-todo.el --- Guide Todo Minor Mode          -*- lexical-binding: t; -*-

;; Copyright (C) 2020  Hakan Tunc

;; Author: Hakan Tunc
;; Keywords: calendar

;;; Code:

(defun guide-v2-move-down-with-date ()
  (interactive)
  (guide-v2-append-date)
  (guide-v2-move-down))

(defun guide-v2-append-date ()
  (interactive)
  (let ((field-name "GuideHistory"))
    (apply
     #'org-entry-put-multivalued-property
     nil
     field-name
     (append (org-entry-get-multivalued-property nil field-name)
             (list (format-time-string "%F"))))))

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
