;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname q3) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; q3.rkt

(require "extras.rkt")
(require rackunit)
(check-location "01" "q3.rkt")
(provide kelvin-to-fahrenheit)

;; DATA DEFINITIONS
;; A Kelvin is represented as a Real
;; A Fahrenheit is represented as a Real

; kelvin-to-fahrenheit : Kelvin -> Fahrenheit
; GIVEN : A temperature in Kelvin
; RETURN : Equivalent temperature in Fahrenheit

; EXAMPLES
; (kelvin-to-fahrenheit 0) = -459.67
; (kelvin-to-fahrenheit 100) = -279.67
; (kelvin-to-fahrenheit 273.15) = 32

;; DESIGN STRATEGY : transcribe formula

(define (kelvin-to-fahrenheit k)
  (- (* k (/ 9 5)) 459.67))

;; TESTS

(begin-for-test
  (check-equal?
   (kelvin-to-fahrenheit 0)
   -459.67)
  (check-equal?
   (kelvin-to-fahrenheit 100)
   -279.67)
  (check-equal?
   (kelvin-to-fahrenheit 273.15)
   32))

