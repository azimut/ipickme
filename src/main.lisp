(uiop:define-package #:ipickme
  (:nicknames #:ipickme/main)
  (:use #:cl #:ipickme/ui)
  (:import-from #:uiop #:command-line-arguments #:delete-file-if-exists)
  (:import-from #:bordeaux-threads #:thread-alive-p)
  (:export #:start))

(in-package #:ipickme)

(defun images () (mapcar #'truename (command-line-arguments)))
(defun start ()
  (let* ((images (images)))
    (assert (> (length images) 0))
    #+slynk
    (show images)
    #-slynk
    (loop :with thread := (show images)
          :while (thread-alive-p thread)
          :do (sleep .5))))
