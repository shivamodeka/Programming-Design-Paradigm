;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname q2) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; q2.rkt

(require "extras.rkt")
(require rackunit)
(check-location "01" "q2.rkt")
(provide furlongs-to-barleycorns)

;; DATA DEFINITIONS
;; A Furlong is represented as a PosReal
;; A Barleycorn is represented as a PosReal

; furlongs-to-barleycorns : Furlong -> Barleycorn
; GIVEN : A length in Furlongs
; RETURN : Equivalent length in Barleycorn

; EXAMPLES
; (furlongs-to-barleycorns 1) = 23760
; (furlongs-to-barleycorns 3) = 71280
; (furlongs-to-barleycorns 8) = 190080

;; DESIGN STRATEGY : transcribe formula

(define (furlongs-to-barleycorns f)
  (* f 10 4 16.5 12 3))

;; TESTS

(begin-for-test
  (check-equal?
   (furlongs-to-barleycorns 1)
   23760)
  (check-equal?
   (furlongs-to-barleycorns 3)
   71280)
  (check-equal?
   (furlongs-to-barleycorns 8)
   190080))

