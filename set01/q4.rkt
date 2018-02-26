;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname q4) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; q4.rkt

(require "extras.rkt")
(require rackunit)
(check-location "01" "q4.rkt")
(provide flopy)

;; DATA DEFINITIONS
;; FLOPS (Floating point operations per second) is represented as a PosReal
;; FLOPY (Floating point operations per year) is represented as a PosReal

; flopy : FLOPS -> FLOPY
; GIVEN : the speed of a microprocessor in FLOPS
; RETURN : the number of floating point operations it can perform in one 365-day year

; EXAMPLES
; (flopy 1) = 31536000
; (flopy 25) = 788400000
; (flopy 40) = 1261440000

;; DESIGN STRATEGY : transcribe formula

(define (flopy x)
  (* x 60 60 24 365))

;; TESTS

(begin-for-test
  (check-equal?
   (flopy 40)
   1261440000)
  )

