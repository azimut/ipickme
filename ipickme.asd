(asdf:register-system-packages
 :cl-cffi-gtk
 '(:gtk :gdk :gdk-pixbuf :gobject :glib :gio :pango :cairo))

(asdf:defsystem #:ipickme
  :class :package-inferred-system
  :description "Describe ipickme here"
  :author "azimut <azimut.github@protonmail.com>"
  :license  "MIT"
  :version "0.0.1"
  :pathname "src"
  :depends-on (#:ipickme/main))

(asdf:defsystem #:ipickme/deploy
  :depends-on (#:ipickme)
  :defsystem-depends-on (:deploy)
  :build-operation "deploy-op"
  :build-pathname "ipickme-deploy/ipickme"
  :entry-point "ipickme:start")
