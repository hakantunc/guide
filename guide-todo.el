;;; guide-todo.el --- Guide Todo Minor Mode          -*- lexical-binding: t; -*-

;; Copyright (C) 2020  Hakan Tunc

;; Author: Hakan Tunc
;; Keywords: calendar

;;; Code:

(require 'cl-lib)
(require 'dash)

(defconst guide-history "GuideHistory")
(defconst guide-schedule-fixed "GuideScheduleFixed")

(defun guide-get-history ()
  (org-entry-get-multivalued-property nil guide-history))

(defun guide-prepend-date ()
  (let ((field-name guide-history))
    (apply
     #'org-entry-put-multivalued-property
     nil
     field-name
     (append (list (format-time-string "%F"))
             (guide-get-history)))))

(defun guide-get-fixed-schedule ()
  (let ((gsf (org-entry-get nil guide-schedule-fixed)))
    (if gsf
        (string-to-number gsf)
      nil)))

(defun guide-clear-overlays ()
  (interactive)
  (ov-clear 'ov-for-guide))

(defun guide-display-schedule ()
  (interactive)
  (guide-clear-overlays)
  (org-map-entries
   (lambda ()
     (let*
         ((p (point))
          (l (org-current-level))
          (v (org-entry-get nil guide-schedule-fixed))
          (x (if v v "∞")))
       (ov p
           (+ p 1 l)
           'after-string
           (format "%2s " x)
           'ov-for-guide t)))
   nil nil))

(defun guide-move-down ()
  (interactive)
  (guide-clear-overlays)
  (save-excursion
    (let ((amount (guide-get-fixed-schedule)))
      (condition-case nil
          (if amount
              (cl-loop repeat amount do
                       (org-metadown))
            (while t
              (org-metadown)))
        (user-error nil))
      (outline-hide-subtree)))
  (org-show-children)
  (org-show-entry))

(defun guide-move-down-with-date ()
  (interactive)
  (guide-prepend-date)
  (guide-move-down))

(defun guide-get-top-level-history ()
  (let ((entries (-non-nil
                  (org-map-entries
                   (lambda ()
                     (if (equal (org-current-level) 1)
                         (guide-get-history)
                       nil)) nil nil))))
    (-flatten entries)))

(provide 'guide-todo)
;;; guide-todo.el ends here
