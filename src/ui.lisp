(uiop:define-package  #:ipickme/ui
  (:use #:gtk #:gdk #:gdk-pixbuf #:gobject #:glib #:gio #:pango #:cairo #:cl)
  (:import-from #:serapeum #:op #:lret* #:~>)
  (:export #:show))

(in-package #:ipickme/ui)

(defun show (originals &aux (length (length originals)))
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

      (let ((buttons (make-buttons originals)))
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
(defun make-button (path)
  (lret* ((pixbuf (~> (namestring path)
                      (pixbuf-of-size 150)))
          (image  (gtk-image-new-from-pixbuf pixbuf))
          (button (gtk-button-new)))
    (gtk-container-add button image)))

(defun pixbuf-of-size (path size)
  (let* ((pixbuf (gdk-pixbuf-new-from-file path))
         (width  (gdk-pixbuf-get-width pixbuf))
         (height (gdk-pixbuf-get-height pixbuf))
         (w/h    (/ width height)))
    (if (> w/h 1)
        (gdk-pixbuf-scale-simple pixbuf size (truncate (/ size w/h)) :bilinear)
        (gdk-pixbuf-scale-simple pixbuf (truncate (* w/h size)) size :bilinear))))

(defun fade   (widget) (g-object-set-property widget "opacity" .1))
(defun bright (widget) (g-object-set-property widget "opacity" .9))
