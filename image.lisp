(uiop:define-package #:ipickme/image
  (:use #:cl #:lisp-magick-wand #:series)
  (:export #:create-thumbnails))

(in-package #:ipickme/image)

(defun create-thumbnails (images)
  (collect
    (mapping ((image (scan images)) (i (scan-range)))
      (create-thumbnail image (format nil "ipickme-thumbnail-~2,'0d.png" i) 150 150))))

(defun create-thumbnail (filename output width height)
  (prog1 output
    (with-magick-wand (wand :load filename)
      (let ((a (/ (get-image-width wand) (get-image-height wand))))
        (if (> a (/ width height))
            (scale-image wand width (truncate (/ width a)))
            (scale-image wand (truncate (* a height)) height))
        (write-image wand output)))))
