(uiop:define-package #:ipickme/opts
  (:mix #:unix-opts #:cl)
  (:import-from #:uiop #:quit)
  (:export #:options))

(in-package #:ipickme/opts)

(define-opts
  (:name :help :short #\h :long "help" :description "prints this help text")
  (:name :size
   :default 150
   :short #\s
   :long "size"
   :description "square size of the buttons"
   :arg-parser (lambda (_) (and (plusp (parse-integer _))
                           (parse-integer _)))))

(defun usage ()
  (describe
   :prefix "ipickme is an image picker for cli tools. Usage:"
   :args "[images]"))

(defun options ()
  (multiple-value-bind (options images)
      (get-opts)
    (when (null images)
      (usage)
      (quit 1))
    (when (getf options :help)
      (usage)
      (quit 0))
    (values (getf options :size)
            (mapcar #'truename images))))
