

(defpackage :society-asd
  (:use :cl-user :asdf))
(in-package :society-asd)


(defsystem "society"
  :name "society"
  :author "i-makinori"
  :version "0"
  :license "MIT"
  :description "society-simulator"
  :depends-on 
  (:lispbuilder-sdl)
  :components 
  ((:file "package")
   (:module "src"
            :components
            ((:file "test")
             ))
   (:module "t"
            :components
            ())
   ))

