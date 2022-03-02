(uiop:define-package #:ipickme/image
  (:use #:cl #:lisp-magick-wand)
  (:export #:thumbnails)
  (:import-from #:serapeum #:lret))

(in-package #:ipickme/image)

(eval-when (:compile-toplevel :execute :load-toplevel)
  (series::install))

(defun thumbnails ()
  (collect
    (mapping ((img (scan (images)))
              (idx (scan-range :from 0)))
      (assert (probe-file img))
      (create-thumbnail img idx 150 150))))

(defun images ()
  ;;(uiop:command-line-arguments)
  (list "/home/sendai/testfield/rustonomicon.jpg"
        "/home/sendai/testfield/peerlessdad.jpg"))

(defun create-thumbnail (filename idx width height)
  (lret ((thumbname (format nil "thumbnail-~2,'0d.png" idx)))
    (with-magick-wand (wand :load filename)
      (let ((a (/ (get-image-width wand) (get-image-height wand))))
        (if (> a (/ width height))
            (scale-image wand width (truncate (/ width a)))
            (scale-image wand (truncate (* a height)) height))
        (write-image wand thumbname)))))
