(uiop:define-package #:ipickme
  (:nicknames #:ipickme/main)
  (:use #:cl #:ipickme/image #:ipickme/ui)
  (:import-from #:uiop #:command-line-arguments #:delete-file-if-exists)
  (:import-from #:bordeaux-threads #:thread-alive-p)
  (:export #:start))

(in-package #:ipickme)

(defun images () (mapcar #'truename (command-line-arguments)))
(defun start ()
  (let* ((images (images))
         (thumbnails (create-thumbnails images)))
    (assert (> (length thumbnails) 0))
    #+slynk
    (show images thumbnails)
    #-slynk
    (loop :with thread := (show images thumbnails)
          :while (thread-alive-p thread)
          :do (sleep .5)
          :finally (mapcar #'delete-file-if-exists thumbnails))))
