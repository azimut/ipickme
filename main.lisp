(uiop:define-package #:ipickme
  (:nicknames #:ipickme/main)
  (:use #:cl #:ipickme/image #:ipickme/ui)
  (:import-from #:uiop #:delete-file-if-exists)
  (:import-from #:alexandria #:when-let)
  (:export #:start))

(in-package #:ipickme)

(defun start ()
  (when-let ((images (thumbnails)))
    (show images)
    (mapc #'delete-file-if-exists images)))
