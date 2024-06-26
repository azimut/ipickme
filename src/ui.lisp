(uiop:define-package #:ipickme/ui
  (:use #:gtk #:gdk #:gdk-pixbuf #:gobject #:glib #:gio #:pango #:cairo #:cl)
  (:import-from #:serapeum #:op #:lret* #:~> #:->)
  (:import-from #:bordeaux-threads #:thread)
  (:export #:show))

(in-package #:ipickme/ui)

(-> show (List Integer) (values Thread Integer &optional))
(defun show (images size &aux (length (length images)))
  (within-main-loop
    (let ((window (make-instance
                   'gtk-window :type :toplevel
                   :title "ipickme"
                   :default-width (* size length)
                   :default-height (truncate (+ size (* .1 size)))
                   :border-width 12))
          (box (gtk-box-new :horizontal length)))

      (gtk-window-set-position window :center-always)

      ;; NOTE: returning NIL makes it so it doesn't swallows the key event
      (g-signal-connect window "key_press_event"
                        (lambda (w ev &aux (key (gdk-event-key-string ev)))
                          (declare (ignore w))
                          (when (and (plusp (length key))
                                     (char= #\esc (elt key 0)))
                            (gtk-widget-destroy window))))
      (g-signal-connect window "destroy"
                        (lambda (widget)
                          (declare (ignore widget))
                          (leave-gtk-main)))

      (let ((buttons (make-buttons images size)))
        (mapc (op (gtk-container-add box _)) buttons)
        (mapc (op (signal-connect window _ _)) buttons images)
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

(defun make-buttons (paths size) (mapcar (op (make-button _ size)) paths))
(defun make-button (path size)
  (lret* ((pixbuf (~> (namestring path)
                      (pixbuf-of-size size)))
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
