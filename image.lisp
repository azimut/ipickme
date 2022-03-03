(uiop:define-package #:ipickme/image
  (:use #:cl #:lisp-magick-wand #:series)
  (:import-from #:uiop #:command-line-arguments)
  (:import-from #:serapeum #:lret #:->)
  (:export #:thumbnails))

(in-package #:ipickme/image)

(eval-when (:compile-toplevel :execute :load-toplevel)
  (series::install))

(defun thumbnails ()
  (collect
    (mapping ((img (scan (images))) (idx (scan-range :from 0)))
      (create-thumbnail img idx 150 150))))

(defun images ()
  (mapcar #'truename
          ;;(command-line-arguments)
          (list "/home/sendai/testfield/rustonomicon.jpg"
                "/home/sendai/testfield/peerlessdad.jpg")))

(-> create-thumbnail (pathname fixnum fixnum fixnum) string)
(defun create-thumbnail (filename idx width height)
  (lret ((thumbname (format nil "~athumbnail-~2,'0d.png"
                            (directory-namestring filename)
                            idx)))
    (with-magick-wand (wand :load filename)
      (let ((a (/ (get-image-width wand) (get-image-height wand))))
        (if (> a (/ width height))
            (scale-image wand width (truncate (/ width a)))
            (scale-image wand (truncate (* a height)) height))
        (write-image wand thumbname)))))
