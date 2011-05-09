;;;; -*- Mode: lisp; indent-tabs-mode: nil -*-
;;; bezcurve.lisp --- Lisp version of bezcurve.c (Red Book examples)
;;;
;;; This program uses evaluators to draw a Bezier curve.

(in-package #:cl-glut-examples)

(defvar control-points (make-array '(4 3) :initial-contents
				   '((-4 -4 0) (-2 4 0)
				     (2 -4 0) (4 4 0))))

(defclass bezcurve-window (glut:window)
  ()
  (:default-initargs :width 500 :height 500 :title "bezcurve.lisp"
                     :mode '(:single :rgb)))

(defmethod glut:display ((w bezcurve-window))
  (gl:clear :color-buffer-bit)
  (gl:color 1 1 1)

  (gl:with-primitive :line-strip 
    (loop for i from 0 to 30
       do (gl:eval-coord-1 (/ i 30))))

   ;; The following code displays the control points as dots.
  (gl:point-size 5)
  (gl:color 1 1 0)

  (gl:with-primitive :points
    (loop for i from 0 below 4
         for l = (* 3 i)
       do (gl:vertex 
           (row-major-aref control-points l)
           (row-major-aref control-points (+ 1 l))
           (row-major-aref control-points (+ 2 l)))))
  (gl:flush))

(defun init-bezcurve ()
  (gl:clear-color 0 0 0 0)
  (gl:shade-model :flat)
  (gl:map1 :map1-vertex-3 0 1 control-points)
  (gl:enable :map1-vertex-3))

(defmethod glut:reshape ((w bezcurve-window) width height)
  (gl:viewport 0 0 width height)
  (gl:matrix-mode :projection)
  (gl:load-identity)

  (if (<= width height)
      (gl:ortho -5 5 (/ (* -5 height) width)
		(/ (* 5 height) width) -5 5)
      (gl:ortho (/ (* -5 width) height) (/ (* 5 width) height)
		-5 5 -5 5))
  (gl:matrix-mode :modelview)
  (gl:load-identity))

(defmethod glut:keyboard ((w bezcurve-window) key x y)
  (declare (ignore x y))
  (when (eql key #\Esc)
    (glut:destroy-current-window)))

(defun rb-bezcurve ()
  (setf glut:*run-main-loop-after-display* nil)
  (glut:display-window (make-instance 'bezcurve-window))
  (init-bezcurve)
  (glut:main-loop))