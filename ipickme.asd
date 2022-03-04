(asdf:register-system-packages
 :cl-cffi-gtk
 '(:gtk :gdk :gdk-pixbuf :gobject :glib :gio :pango :cairo))

(asdf:defsystem #:ipickme
  :class :package-inferred-system
  :description "Describe ipickme here"
  :author "azimut <azimut.github@protonmail.com>"
  :license  "MIT"
  :version "0.0.1"
  :depends-on (#:ipickme/main))
