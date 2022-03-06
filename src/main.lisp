(uiop:define-package #:ipickme
  (:nicknames #:ipickme/main)
  (:use #:cl #:ipickme/ui #:ipickme/opts)
  (:import-from #:bordeaux-threads #:thread-alive-p)
  (:export #:start))

(in-package #:ipickme)

(defun start ()
  (multiple-value-bind (size images) (options)
    #+slynk
    (show images size)
    #-slynk
    (loop :with thread := (show images size)
          :while (thread-alive-p thread)
          :do (sleep .5))))
