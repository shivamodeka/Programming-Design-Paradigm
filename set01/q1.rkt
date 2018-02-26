;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname q1) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; q1.rkt

(require "extras.rkt")
(require rackunit)
(check-location "01" "q1.rkt")
(provide pyramid-volume)

;; A pyramid is represented by a struct
;; with the following fields
;; x : PosReal is the length of the side of the square in m
;; h : PosReal is the height of the pyramid in m

;; IMPLEMENTATION
(define-struct pyramid (x h))

;; CONSTRUCTOR TEMPLATE
;; (make-pyramid PosReal PosReal)

;;OBSERVER TEMPLATE
(define (pyramid-fn p)
  (...
   (pyramyd-x p)
   (pyramid-h p)))

; pyramid-volume : PosReal PosReal -> PosReal
; GIVEN : values x and h in units of meters
; RETURN : the volume in cubic meters of a pyramid of height h whose square bottom has sides of length x

; EXAMPLES
; (pyramid-volume (make-pyramid 3 3) = 9
; (pyramid-volume (make-pyramid 1 3) = 1
; (pyramid-volume (make-pyramid 3 1) = 3

;; DESIGN STRATEGY: Use observer template for pyramid on p

(define (pyramid-volume p)
  (/ (* (pyramid-x p) (pyramid-x p) (pyramid-h p)) 3))

;; TESTS

(begin-for-test
  (check-equal?
   (pyramid-volume (make-pyramid 3 3))
   9)
  (check-equal?
   (pyramid-volume (make-pyramid 1 3))
   1)
  (check-equal?
   (pyramid-volume (make-pyramid 3 1))
   3))
