;;; guide-todo.el --- Guide Todo Minor Mode          -*- lexical-binding: t; -*-

;; Copyright (C) 2020  Hakan Tunc

;; Author: Hakan Tunc
;; Keywords: calendar

;;; Code:

(require 'cl-lib)
(require 'dash)

(defconst guide-history "GuideHistory")
(defconst guide-schedule-fixed "GuideScheduleFixed")

(defun guide-v2-get-history ()
  (org-entry-get-multivalued-property nil guide-history))

(defun guide-v2-prepend-date ()
  (let ((field-name guide-history))
    (apply
     #'org-entry-put-multivalued-property
     nil
     field-name
     (append (list (format-time-string "%F"))
             (guide-v2-get-history)))))

(defun guide-v2-get-fixed-schedule ()
  (let ((gsf (org-entry-get nil guide-schedule-fixed)))
    (if gsf
        (string-to-number gsf)
      nil)))

(defun guide-v2-move-down ()
  (interactive)
  (save-excursion
    (let ((amount (guide-v2-get-fixed-schedule)))
      (condition-case nil
          (if amount
              (cl-loop repeat amount do
                       (org-metadown))
            (while t
              (org-metadown)))
        (user-error nil)))))

(defun guide-v2-move-down-with-date ()
  (interactive)
  (guide-v2-prepend-date)
  (guide-v2-move-down))

(defun guide-v2-get-top-level-history ()
  (let ((entries (-non-nil
                  (org-map-entries
                   (lambda ()
                     (if (equal (org-current-level) 1)
                         (guide-v2-get-history)
                       nil)) nil nil))))
    (-flatten entries)))

(provide 'guide-todo)
;;; guide-todo.el ends here
