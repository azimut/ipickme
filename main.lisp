(uiop:define-package #:ipickme
  (:nicknames #:ipickme/main)
  (:use #:cl #:ipickme/image #:ipickme/ui)
  (:import-from #:bordeaux-threads #:thread-alive-p)
  (:export #:start))

(in-package #:ipickme)

(defun start ()
  (multiple-value-bind (originals thumbnails) (thumbnails)
    (assert (> (length originals) 0))
    #+slynk
    (show originals thumbnails)
    #-slynk
    (loop :with thread := (show originals thumbnails)
          :while (thread-alive-p thread)
          :do (sleep .5))))
