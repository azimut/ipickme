(uiop:define-package  #:ipickme/ui
  (:use #:gtk #:gdk #:gdk-pixbuf #:gobject #:glib #:gio #:pango #:cairo #:cl)
  (:import-from #:serapeum #:op #:lret)
  (:export #:show))

(in-package #:ipickme/ui)

(defun show (originals thumbnails &aux (length (length originals)))
  (within-main-loop
    (let ((window (make-instance
                   'gtk-window :type :toplevel
                   :title "ipickme"
                   :default-width (* 150 length)
                   :default-height 200
                   :border-width 12))
          (box (gtk-box-new :horizontal length)))

      (gtk-window-set-position window :center-always)
      (g-signal-connect window "destroy"
                        (lambda (widget)
                          (declare (ignore widget))
                          (leave-gtk-main)))

      (let ((buttons (make-buttons thumbnails)))
        (mapc (op (gtk-container-add box _)) buttons)
        (mapc (op (signal-connect window _ _)) buttons originals)
        (mapc #'fade buttons))

      (gtk-container-add window box)
      (gtk-widget-show-all window))))

(defun signal-connect (window button original)
  (flet ((click (widget)
           (declare (ignore widget))
           (princ original)
           (gtk-widget-destroy window))
         (focus (widget event)
           (declare (ignore event))
           (bright widget))
         (unfocus (widget event)
           (declare (ignore event))
           (fade widget)))
    (g-signal-connect button "clicked" #'click)
    (g-signal-connect button "focus-in-event" #'focus)
    (g-signal-connect button "focus-out-event" #'unfocus)))

(defun make-buttons (paths) (mapcar #'make-button paths))
(defun make-button (path &aux (image (gtk-image-new-from-file path)))
  (lret ((button (gtk-button-new)))
    (gtk-widget-get-style-context button)
    (gtk-container-add button image)))

(defun fade   (widget) (g-object-set-property widget "opacity" .1))
(defun bright (widget) (g-object-set-property widget "opacity" .9))
