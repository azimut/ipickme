(uiop:define-package #:ipickme/ui
  (:use #:cl #:ltk)
  (:export #:show)
  (:import-from #:serapeum #:op #:lret #:~>))

(in-package #:ipickme/ui)

(defun show (images)
  (with-ltk ()
    (wm-title *tk* "ImgPicker 0.1")
    (~> images to-buttons gridify)))

(defun to-buttons (images)
  (lret ((buttons (mapcar #'image2button images)))
    (mapcar (op (configure _ :state :disabled))
            (rest buttons))))

(defun to-button (path &aux (image (image-load (make-image) path)))
  (make-instance
   'button
   :image image
   :command (lambda () (print path) (exit-wish))))

;; TODO: assumes 1 row
(defun gridify (buttons)
  (dotimes (i (length buttons))
    (grid (nth i buttons) 0 i)))
