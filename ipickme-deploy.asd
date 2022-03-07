(asdf:defsystem #:ipickme-deploy
  :depends-on (#:ipickme)
  :defsystem-depends-on (:deploy)
  :build-operation "deploy-op"
  :build-pathname "ipickme-deploy/ipickme"
  :entry-point "ipickme:start")
