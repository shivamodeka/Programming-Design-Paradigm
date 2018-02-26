;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname q1) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require "extras.rkt")
(require rackunit)

(check-location "04" "q1.rkt")

(provide
 inner-product
 permutation-of?
 shortlex-less-than?
 permutations)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; inner-product : RealList RealList -> Real
;; GIVEN: two lists of real numbers
;; WHERE: the two lists have the same length
;; RETURNS: the inner product of those lists
;; EXAMPLES:
;;     (inner-product (list 2.5) (list 3.0))  =>  7.5
;;     (inner-product (list 1 2 3 4) (list 5 6 7 8))  =>  70
;;     (inner-product (list) (list))  =>  0
;; STRATEGY : Use HOF foldr and map on both lists

#;(define (inner-product lst1 lst2)
  (cond
    [(or (empty? lst1)(empty? lst2)) 0]
    [else (+ (* (first lst1) (first lst2))
        (inner-product (rest lst1) (rest lst2)))]))

(define (inner-product lst1 lst2)
  (foldr + 0 (map
              ;;Real Real -> Real
              ;;RETURNS: Product of two reals
              (lambda (n b) (* n b)) lst1 lst2)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; permutation-of? : IntList IntList -> Boolean
;; GIVEN: two lists of integers
;; WHERE: neither list contains duplicate elements
;; RETURNS: true if and only if one of the lists
;;     is a permutation of the other
;; EXAMPLES:
;;     (permutation-of? (list 1 2 3) (list 1 2 3)) => true
;;     (permutation-of? (list 3 1 2) (list 1 2 3)) => true
;;     (permutation-of? (list 3 1 2) (list 1 2 4)) => false
;;     (permutation-of? (list 1 2 3) (list 1 2)) => false
;;     (permutation-of? (list) (list)) => true
;; STRATEGY : Sort and compare the two lists

(define (permutation-of? lst1 lst2)
  (equal? (sort lst1 <) (sort lst2 <)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; shortlex-less-than? : IntList IntList -> Boolean
;; GIVEN: two lists of integers
;; RETURNS: true if and only either
;;          the first list is shorter than the second
;;          or both are non-empty, have the same length, and either
;;          the first element of the first list is less than
;;          the first element of the second list
;;          or the first elements are equal, and the rest of
;;          the first list is less than the rest of the
;;          second list according to shortlex-less-than?
;; EXAMPLES:
;;     (shortlex-less-than? (list) (list)) => false
;;     (shortlex-less-than? (list) (list 3)) => true
;;     (shortlex-less-than? (list 3) (list)) => false
;;     (shortlex-less-than? (list 3) (list 3)) => false
;;     (shortlex-less-than? (list 3) (list 1 2)) => true
;;     (shortlex-less-than? (list 3 0) (list 1 2)) => false
;;     (shortlex-less-than? (list 0 3) (list 1 2)) => true
;; STRATEGY : Test the conditions


(define (shortlex-less-than? lst1 lst2)
  (or
    (< (length lst1) (length lst2))    
    (and (and (cons? lst1) (cons? lst2))         
         (= (length lst1) (length lst2))          
         (or (< (first lst1) (first lst2))
             (and (= (first lst1) (first lst2))
                  (shortlex-less-than? (rest lst1) (rest lst2))))
          )))

;;TESTS
         

(begin-for-test
           (check-equal?
(shortlex-less-than? (list) (list)) false)
           (check-equal?
(shortlex-less-than? (list) (list 3)) true)
           (check-equal?
(shortlex-less-than? (list 3) (list))  false)
           (check-equal?
(shortlex-less-than? (list 3) (list 3)) false)
           (check-equal?
(shortlex-less-than? (list 3) (list 1 2)) true)
           (check-equal?
(shortlex-less-than? (list 3 0) (list 1 2)) false)
           (check-equal?
(shortlex-less-than? (list 0 3) (list 1 2)) true)

(check-equal?
 (inner-product (list 2.5) (list 3.0)) 7.5)
    (check-equal?
     (inner-product (list 1 2 3 4) (list 5 6 7 8)) 70)
          (check-equal?
           (inner-product (list) (list)) 0)

(check-equal?
 (permutation-of? (list 1 2 3) (list 1 2 3)) true)
         (check-equal?
          (permutation-of? (list 3 1 2) (list 1 2 3)) true)
         (check-equal?
          (permutation-of? (list 3 1 2) (list 1 2 4))false)
          (check-equal?
           (permutation-of? (list 1 2 3) (list 1 2))false)
          (check-equal?
           (permutation-of? (list) (list))true))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; permutations : IntList -> IntListList
;; GIVEN: a list of integers
;; WHERE: the list contains no duplicates
;; RETURNS: a list of all permutations of that list,
;;     in shortlex order
;; EXAMPLES:
;;     (permutations (list))  =>  (list (list))
;;     (permutations (list 9))  =>  (list (list 9))
;;     (permutations (list 3 1 2))
;;         =>  (list (list 1 2 3)
;;                   (list 1 3 2)
;;                   (list 2 1 3)
;;                   (list 2 3 1)
;;                   (list 3 2 1))
;; STRATEGY: Combine simpler functions

(define (permutations lst)
  (sort (permutation lst) shortlex-less-than?))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; permutation : IntList -> IntListList
;; GIVEN: a list of integers
;; WHERE: the list contains no duplicates
;; RETURNS: a list of all permutations of that list,
;;     in shortlex order
;; EXAMPLES:
;;     (permutation (list))  =>  (list (list))
;;     (permutation (list 9))  =>  (list (list 9))
;;     (permutation (list 3 1 2))
;;         =>  (list (list 1 2 3)
;;                   (list 2 1 3)
;;                   (list 1 3 2)
;;                   (list 2 3 1)
;;                   (list 3 2 1))
;; STRATEGY: Use HOF foldr on lst

#;(define (permutation lst)
  (cond
    [(empty? lst) (cons empty empty) ]
    [ else (insert-everywhere (first lst)
(permutation (rest lst)) ) ]))

(define (permutation lst)
  (foldr insert-everywhere (cons empty empty) lst))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; insert-everywhere : Integer IntListList -> IntListList
;; GIVEN: an integer and a list of inetegrs
;; RETURNS: an IntList with the given integer inserted everywhere
;; STRATEGY: Use HOF foldr on lst

#;(define (insert-everywhere s lst)
  (cond
    [(empty? lst) empty]
    [else (append (insert-everywhere-in-a-list s (first lst))
          (insert-everywhere s (rest lst))) ]))

(define (insert-everywhere s lst)
  (foldr append empty
         (map
          ;;IntList -> IntList
          ;;RETURNS: A list with the integer inserted everywhere in the list
          (lambda (n) (insert-everywhere-in-a-list s n)) lst)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; insert-everywhere-in-a-list : Integer IntList -> IntListList
;; GIVEN: an integer and a list of inetegrs
;; RETURNS: an IntList with the given integer inserted everywhere in the list
;; EXAMPLES: (insert-everywhere-in-a-list 1 (list 2 3))->
;; (list (list 1 2 3) (list 2 1 3) (list 2 3 1))
;; STARTEGY: Use observer template for IntListList

(define (insert-everywhere-in-a-list s lst)
  (cond
    [(empty? lst) (cons (insert-at-begining s lst) empty)]
    [else (append (cons (insert-at-begining s lst) empty)
                  (insert-in-between-items s lst)
                  (cons (insert-at-end s lst) empty))]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; insert-at-begining : Integer IntList -> IntList
;; GIVEN: an integer and a list of inetegrs
;; RETURNS: an IntList with the given integer inserted at the beginning
;;          of the list
;; STARTEGY: Use observer template for IntList

(define (insert-at-begining s lst)
  (cond
    [(empty? lst) (cons s empty)]
    [else (cons s lst)]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; insert-in-between-items : Integer IntList -> IntListList
;; GIVEN: an integer and a list of inetegrs
;; RETURNS: an IntList with the given integer inserted everywhere in the list
;; EXAMPLES: (insert-in-between-items 4 (list 1 2 3)) ->
;; (list (list 1 4 2 3) (list 1 2 4 3))
;; STARTEGY: Use observer template for IntListList

(define (insert-in-between-items s lst)
  (cond
    [(empty? (rest lst)) empty]
    [else (cons (cons (first lst)(cons s (rest lst)))
                (insert-at-front (first lst)
                                 (insert-in-between-items s (rest lst))))]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; insert-at-front : Integer IntListList -> IntListList
;; GIVEN: an integer and a list of inetegrs
;; RETURNS: an IntList with the given integer inserted at the beginning
;;          of the list
;; EXAMPLES: (insert-at-front 1 (list(list 2 3) (list 3 2))) ->
;; (list (list 1 2 3) (list 1 3 2))
;; STARTEGY: Use HOF map on lst

#;(define (insert-at-front s lst)
  (cond
    [(empty? lst) empty]
    [else (cons (cons s (first lst)) (insert-at-front s (rest lst)))]))

(define (insert-at-front s lst)
    (map
     ;;IntList -> IntList
     ;;RETURNS: A list with the integer at the front
     (lambda (n) (cons s n)) lst))
  

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; insert-at-end : Integer IntListList -> IntListList
;; GIVEN: an integer and a list of inetegrs
;; RETURNS: an IntList with the given integer inserted at the end
;;          of the list
;; EXAMPLES: (insert-at-front 1 (list(list 2 3) (list 3 2))) ->
;; (list (list 2 3 1) (list 3 2 1))
;; STARTEGY: Use observer template for IntListList

(define (insert-at-end s lst)
     (append lst (cons s empty)))


;;TESTS

(begin-for-test
  (check-equal?
   (permutations (list 3 1 2))
   (list (list 1 2 3)
         (list 1 3 2)
         (list 2 1 3)
         (list 2 3 1)
         (list 3 1 2)
         (list 3 2 1)))
  (check-equal?
   (permutations (list 3 1 2 4))
(list
 (list 1 2 3 4)
 (list 1 2 4 3)
 (list 1 3 2 4)
 (list 1 3 4 2)
 (list 1 4 2 3)
 (list 1 4 3 2)
 (list 2 1 3 4)
 (list 2 1 4 3)
 (list 2 3 1 4)
 (list 2 3 4 1)
 (list 2 4 1 3)
 (list 2 4 3 1)
 (list 3 1 2 4)
 (list 3 1 4 2)
 (list 3 2 1 4)
 (list 3 2 4 1)
 (list 3 4 1 2)
 (list 3 4 2 1)
 (list 4 1 2 3)
 (list 4 1 3 2)
 (list 4 2 1 3)
 (list 4 2 3 1)
 (list 4 3 1 2)
 (list 4 3 2 1)))
  (check-equal?
   (permutations (list))
(list '())))
  