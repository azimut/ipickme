(uiop:define-package #:ipickme/image
  (:use #:cl #:lisp-magick-wand #:series)
  (:import-from #:uiop #:command-line-arguments)
  (:export #:thumbnails))

(in-package #:ipickme/image)

(eval-when (:compile-toplevel :execute :load-toplevel)
  (series::install))

(defun thumbnails (&aux (images (images)))
  (gathering ((originals collect) (thumbs collect))
    (iterate ((original (scan images)) (idx (scan-range)))
      (create-thumbnail original (thumb-name idx) 150 150)
      (next-out thumbs (thumb-name idx))
      (next-out originals original))))

(defun thumb-name (idx)
  (format nil "ipickme-thumbnail-~2,'0d.png" idx))

(defun images ()
  (mapcar #'truename (command-line-arguments)))

(defun create-thumbnail (filename output width height)
  (with-magick-wand (wand :load filename)
    (let ((a (/ (get-image-width wand) (get-image-height wand))))
      (if (> a (/ width height))
          (scale-image wand width (truncate (/ width a)))
          (scale-image wand (truncate (* a height)) height))
      (write-image wand output))))
