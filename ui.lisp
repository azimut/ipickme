(uiop:define-package #:ipickme/ui
  (:use #:cl #:ltk)
  (:export #:show)
  (:import-from #:serapeum #:op #:lret #:~> #:->))

(in-package #:ipickme/ui)

(defvar *buttons* ())

(defun show (images)
  (with-ltk ()
    (ltk::use-theme "alt")
    (setf *buttons* (~> images to-buttons))))

(defun to-buttons (paths)
  (let ((buttons ()))
    (dotimes (i (length paths) buttons)
      (let ((btn (to-button (nth i paths))))
        (push btn buttons)
        (grid btn 0 i :padx 10 :pady 10)))))

(defun to-button (path &aux (image (image-load (make-image) path)))
  (make-instance
   'button
   :image image
   :command (lambda () (print path) (exit-wish))))
