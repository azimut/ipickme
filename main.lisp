(uiop:define-package #:ipickme
  (:nicknames #:ipickme/main)
  (:use #:cl #:ipickme/image #:ipickme/ui)
  (:import-from #:alexandria #:when-let*)
  (:import-from #:bordeaux-threads #:thread-alive-p)
  (:export #:start))

(in-package #:ipickme)

(defun start ()
  (when-let* ((images (thumbnails))
              (thread (show images)))
    (loop :while (thread-alive-p thread)
          :do (sleep .5))))
