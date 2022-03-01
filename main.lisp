(uiop:define-package #:ipickme
  (:nicknames #:ipickme/main)
  (:use #:cl)
  (:import-from #:alexandria #:when-let)
  (:import-from #:ipickme/image #:thumbnails)
  (:import-from #:ipickme/ui #:show)
  (:export #:start))

(in-package #:ipickme)

(defun start ()
  (when-let ((images (thumbnails)))
    (show images)
    (mapcar #'uiop:delete-file-if-exists images)))
