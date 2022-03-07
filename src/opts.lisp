(uiop:define-package #:ipickme/opts
  (:mix #:unix-opts #:cl)
  (:import-from #:serapeum #:->)
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

(-> options () (values Integer List))
(defun options ()
  (multiple-value-bind (options images) (get-opts)
    (when (null images)
      (exit-normal "no images provided"))
    (when (getf options :help)
      (exit-normal))
    (values (getf options :size)
            (mapcar #'truename images))))

(defun usage ()
  (describe
   :prefix "ipickme is an image picker for cli tools. Usage:"
   :args "[images]"))

(defun exit-normal (&optional msg)
  (when msg (format *standard-output* "~a~%" msg))
  (usage)
  (quit 0))

(defun exit-error (&optional msg)
  (when msg (format *error-output* "~a~%" msg))
  (usage)
  (quit 1))
