(asdf:defsystem #:ipickme
  :class :package-inferred-system
  :description "Describe ipickme here"
  :author "azimut <azimut.github@protonmail.com>"
  :license  "MIT"
  :version "0.0.1"
  :depends-on (#:lisp-magick-wand
               #:ltk
               #:series
               #:serapeum
               #:ipickme/main))

(asdf:defsystem #:ipickme/standalone
  :depends-on (#:ipickme)
  :defsystem-depends-on ("cffi-grovel")
  :build-operation :static-program-op
  :build-pathname "bin/ipickme-standalone/ipickme"
  :entry-point "ipickme:start")

(asdf:defsystem #:ipickme/deploy
  :depends-on (#:ipickme)
  :defsystem-depends-on (:deploy)
  :build-operation "deploy-op"
  :build-pathname "ipickme-deploy/ipickme"
  :entry-point "ipickme:start")
