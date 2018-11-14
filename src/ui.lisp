
(in-package :society)

;;;; utility

(defun array-map (function &rest arrays)
  (flet ((make-displaced-array (array)
           (make-array (reduce #'+ (array-dimensions array))
                       :displaced-to array)))
    (let* ((displaced-array (mapcar #'make-displaced-array arrays))
           (result-array (make-array (array-dimensions (first arrays))))
           (displaced-result-array (make-displaced-array result-array)))
      ;;(declare (dynamic-extent displaced-array displaced-result-array))
      (apply #'map-into displaced-result-array function displaced-array)
      result-array
      )))

;;;; configs

(defconstant +die+ 0)
(defconstant +live+ 1)

(defparameter *world-height* 20)
(defparameter *world-width* 40)


(defun live? (cell)
  (eq cell +live+))

(defun die? (cell)
  (eq cell +die+))

(defparameter *rule*
  #'(lambda (self neighbor)
      (cond ((and (live? self) (or (= neighbor 2) (= neighbor 3)))
             +live+)
            ((and (die? self) (or (= neighbor 3)))
             +live+)
            (t +die+))))

;;;; rule


(defstruct world
  (rule #'(lambda (x) x))
  (space #2A())
  (height 0)
  (width 0) 
  )


(defun birth-of-spaces (height width)
  (make-array (list height width) 
              :initial-element +die+))


(defun random-space (space ratio)
  (array-map
   #'(lambda (x) 
       (declare (ignore x))
       (if (> (random 1.00) ratio)
                     +live+ +die+))
   space))
  



(defun birth-of-world (rule height width)
  (make-world 
   :rule rule
   :height height
   :width width
   :space (birth-of-spaces height width)
   ))




(defparameter *test-world* (birth-of-world *rule* *world-height* *world-width*))

(defun update-life (world)
  (let* ((height (world-height world))
         (width (world-width world))
         (rule (world-rule world))
         (old-space (world-space world))
         (!new-space (make-array (list height width))))
    (dotimes (y height)
      (dotimes (x width)
        (let* ((self (aref old-space y x))

               (above (mod (1- y) height))
               (horizon y)
               (lower (mod (1+ y) height))
               (left (mod (1- x) width))
               (vertical x)
               (right (mod (1+ x) width))
                    
               (neighbor 
                 (apply #'+ 
                        (mapcar #'(lambda (coord) ;; of neighbor
                                    (aref old-space (car coord) (cdr coord)))
                                (list (cons above left) (cons above vertical) (cons above right)
                                      (cons horizon left) (cons horizon right)
                                      (cons lower left) (cons lower vertical) (cons lower right))))))
          
          (setf (aref !new-space y x)
                (funcall rule self neighbor)
                )
          ))
      
      
      )))


  




;;;; UI


#|
(define-application-frame life ()
  ()
  (:pane 
   (canvas :application
           :width 300 :height 300
           :scroll-bars t
           :display-function 'draw-life-of-game))
  (:menu-bar t))
|#



