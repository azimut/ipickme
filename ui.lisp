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
        (bind btn "<FocusOut>" (lambda (ev) (setf (value btn) nil)))
        (bind btn "<FocusIn>" (lambda (ev) (setf (value btn) t)))
        (bind btn "<Return>" (lambda (ev) (funcall (command btn))))
        (grid btn 0 i :padx 10 :pady 10)))))

(defun to-button (path &aux (image (image-load (make-image) path)))
  (make-instance
   'check-button
   :image image
   :command (lambda () (print path) (exit-wish))))
