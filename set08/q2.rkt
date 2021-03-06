;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname q2) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require rackunit)
(require "extras.rkt")
(require "q1.rkt")
(check-location "08" "q2.rkt")

(provide tie
         defeat-winner
         defeat-loser
         defeat-list
         defeated
         defeated?
         outranks
         outranked-by
         power-ranking)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; REPRESENTATION OF POWER

;; A Power is represented as a struct
;; (make-power name outranked-by outranks nlp) with the folowing fields

;; name          : Competitor is the name of the contestant
;; outranked-by  : Nonneg-Int is the number of times the competitor
;;                            was outranked-by some other competitor
;; outranks      : Nonneg-Int is the number of times the competitor
;;                            outranked some other competitor
;; nlp           : Nonneg-Int is the non-losing percentage of the competitor

;; IMPLEMENTATION

(define-struct power (name outranked-by outranks nlp))

;; CONSTRUCTOR TEMPLATE:
;; (make-power Competitor Nonneg-Int Nonneg-Int Nonneg-Int)

;; OBSERVER TEMPLATE
;; power-fn : Power -> ??

#| (define (power-fn p)
      (... (power-name p)
           (power-outranked-by p)
           (power-outranks p)
           (power-nlp p)))
|#

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; REPRESENTATION OF POWERLIST

;; A PowerList is represented as a list of powers 

;; CONSTRUCTOR TEMPLATES:
;; empty
;; (cons p pl)
;; -- WHERE
;;    p  is a Power
;;    pl is a PowerList


;; OBSERVER TEMPLATE:

;;  pl-fn : PowerList -> ??
;;  (define (pl-fn pl)
;;    (cond
;;     [(empty? pl) ...]
;;     [else (...
;;            (first pl)
;;	    (pl-fn (rest pl)))]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; power-ranking : OutcomeList -> CompetitorList
;; GIVEN: a list of outcomes
;; RETURNS: a list of all competitors mentioned by one or more
;;     of the outcomes, without repetitions, with competitor A
;;     coming before competitor B in the list if and only if
;;     the power-ranking of A is higher than the power ranking
;;     of B.
;; EXAMPLE:
;;     (power-ranking
;;      (list (defeated "A" "D")
;;            (defeated "A" "E")
;;            (defeated "C" "B")
;;            (defeated "C" "F")
;;            (tie "D" "B")
;;            (defeated "F" "E")))
;;  => (list "C"   ; outranked by 0, outranks 4
;;           "A"   ; outranked by 0, outranks 3
;;           "F"   ; outranked by 1
;;           "E"   ; outranked by 3
;;           "B"   ; outranked by 4, outranks 2, 50%
;;           "D")  ; outranked by 4, outranks 2, 50%
;; STRATEGY: Combine simpler functions

(define (power-ranking lst)
  (fetch-names (power-ranks lst)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; fetch-names : PowerList -> CompetitorList
;; GIVEN: a list of outcomes
;; RETURNS: a list of all competitors mentioned by one or more
;;     of the outcomes, without repetitions, with competitor A
;;     coming before competitor B in the list if and only if
;;     the power-ranking of A is higher than the power ranking
;;     of B.
;; EXAMPLE:
;;    (fetch-names
;;     (list (make-power "C" 0 4 1)
;;           (make-power "A" 0 3 1)
;;           (make-power "F" 1 1 0.5)
;;           (make-power "E" 3 0 0)
;;           (make-power "B" 4 2 0.5)
;;           (make-power "D" 4 2 0.5))
;;  => (list "C"   
;;           "A"  
;;           "F"   
;;           "E"   
;;           "B"   
;;           "D")
;; STRATEGY: Use HOF foldr and lambda on template of power

(define (fetch-names lst)
  (foldr
   (lambda (n m)
     (cons (power-name n) m)) (list) lst))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; power-ranks : PowerList -> PowerList
;; GIVEN: a power list in random order
;; RETURNS: a power list of all competitors mentioned by one or more
;;     of the outcomes, without repetitions, with competitor A
;;     coming before competitor B in the list if and only if
;;     the power-ranking of A is higher than the power ranking
;;     of B.
;; EXAMPLE:
;;   (power-ranks
;;     (list (make-power "A" 0 3 1)
;;           (make-power "B" 4 2 0.5)
;;           (make-power "C" 0 4 1)
;;           (make-power "D" 4 2 0.5))
;;           (make-power "E" 3 0 0)
;;           (make-power "F" 1 1 0.5)
;;
;;  =>  (list (make-power "C" 0 4 1)
;;            (make-power "A" 0 3 1)
;;            (make-power "F" 1 1 0.5)
;;            (make-power "E" 3 0 0)
;;            (make-power "B" 4 2 0.5)
;;            (make-power "D" 4 2 0.5))
;; STRATEGY: Sort power list using power sort

(define (power-ranks lst)
  (sort (power-list lst) power-sort?))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; power-sort? : Power Power -> Boolean
;; GIVEN: Two Powers A and B
;; RETURNS: True iff the power-ranking of A is higher than the power ranking
;;          of B
;; EXAMPLES:
;;  (power-sort? (make-power "C" 0 4 1)
;;               (make-power "A" 0 3 1))
;;    => True
;;  (power-sort? (make-power "A" 0 3 1)
;;               (make-power "C" 0 4 1))
;;    => False
;; STRATEGY: Test the conditions for power ranking

(define (power-sort? a b)
  (or (< (power-outranked-by a) (power-outranked-by b))
  (and (= (power-outranked-by a) (power-outranked-by b))
       (> (power-outranks a) (power-outranks b)))
  (and (= (power-outranked-by a) (power-outranked-by b))
       (= (power-outranks a) (power-outranks b))
       (> (power-nlp a) (power-nlp b)))
  (and (= (power-outranked-by a) (power-outranked-by b))
       (= (power-outranks a) (power-outranks b))
       (= (power-nlp a) (power-nlp b))
       (string<? (power-name a) (power-name b)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; power-list : OutcomeList -> PowerList
;; GIVEN: a list of outcomes
;; RETURNS: a power list of all competitors mentioned by one or more
;;     of the outcomes, without repetitions
;; EXAMPLE:
;;     (power-list
;;      (list (defeated "A" "D")
;;            (defeated "A" "E")
;;            (defeated "C" "B")
;;            (defeated "C" "F")
;;            (tie "D" "B")
;;            (defeated "F" "E")))
;;
;;  => (list (make-power "A" 0 3 1)
;;           (make-power "B" 4 2 0.5)
;;           (make-power "C" 0 4 1)
;;           (make-power "D" 4 2 0.5))
;;           (make-power "E" 3 0 0)
;;           (make-power "F" 1 1 0.5)
;; STRATEGY: Combine simpler functions

(define (power-list o-lst)
  (generate-power-list (competitor-list o-lst) o-lst 0 (list)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; generate-power-list : CompetitorList OutcomeList
;;    Non-negInt PowerList -> PowerList
;; GIVEN: the competitor list, a list of outcomes a non negative integer
;;    and a power list
;; WHERE: PowerList contains all the powers of the competitors 
;;    till the competitor at position n in the CompetitorList
;; AND: n<= length of CompetitorList
;; RETURNS: a list of powers of all the given competitors
;; EXAMPLES:
;;     (generate-power-list (list "A" "B") 
;;                          (list (defeated "A" "D")
;;                                (defeated "A" "E")
;;                                (defeated "C" "B")
;;                                (defeated "C" "F")
;;                                (tie "D" "B")
;;                                (defeated "F" "E"))) 0 (list))
;;       =>     (list (make-power "A" 0 3 1) (make-power "B" 4 2 0.3)
;;
;; STRATEGY: Recur on c-lst
;;
;; HALTING MEASURE: (length c-lst) - n

(define (generate-power-list c-lst o-lst n p-lst)
  (if (= n (length c-lst))
      p-lst
      (append
       (generate-power (list-ref c-lst n) o-lst p-lst)
       (generate-power-list c-lst o-lst (+ 1 n) p-lst))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; generate-power : Competitor OutcomeList PowerList -> PowerList
;; GIVEN: a competitor , the list of outcomes and a power list
;; WHERE: PowerList contains all the powers of the competitors 
;;    till the given competitor in the CompetitorList
;; RETURNS: a list of power of the given competitor
;; EXAMPLES:
;;     (generate-power "A" 
;;                          (list (defeated "A" "D")
;;                                (defeated "A" "E")
;;                                (defeated "C" "B")
;;                                (defeated "C" "F")
;;                                (tie "D" "B")
;;                                (defeated "F" "E"))) 0 (list))
;;       =>     (list (make-power "A" 0 3 1))
;;
;; STRATEGY: Use observer template for Power

(define (generate-power comp o-lst p-lst)
  (cons (make-power comp (length (outranked-by comp o-lst))
                    (length (outranks comp o-lst))
                    (nlp comp o-lst)) p-lst))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; competitor-list : OutcomeList -> CompetitorList
;; GIVEN: the list of outcomes
;; RETURNS: a list of all the competitors in OutcomeList
;; EXAMPLES: 
;;               (competitor-list (list (defeated "A" "D")
;;                                (defeated "A" "E")
;;                                (defeated "C" "B")
;;                                (defeated "C" "F")
;;                                (tie "D" "B")
;;                                (defeated "F" "E"))) 0 (list))
;;       =>     (list "A" "D" "E" "C" "B" "F")
;;
;; STRATEGY: Use HOF foldl and lambda on OutcomeList 

(define (competitor-list o-lst)
  (foldl
   (lambda (n m)
     (cond
       [(and (not (member (defeat-winner n) m))
             (not (member (defeat-loser n) m)))
        (append m (list (defeat-winner n)) (list (defeat-loser n)))]
       [(not (member (defeat-winner n) m))
        (append m (list (defeat-winner n)))]
       [(not (member (defeat-loser n) m))
        (append m (list (defeat-loser n)))]
       [else m])) (list) (defeat-list o-lst)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; n-outcomes : Competitor OutcomeList -> Nonneg-Int
;; GIVEN: an arbitrary competitor A and a list of outcomes
;; RETURNS: the number of outcomes in which A defeats or ties another competitor
;; EXAMPLES:
;;    (n-outcomes "C" (list (defeated "A" "D")
;;                  (defeated "A" "E")
;;                  (defeated "C" "B")
;;                  (defeated "C" "F")
;;                  (tie "D" "B")
;;                  (defeated "F" "E")))
;;      =>  2
;; STRATEGY: Use HOF foldr and lambda on OutcomeList

(define (n-outcomes x lst)
  (foldr
   (lambda (n m)
     (cond
       [(defeat? n)
        (if (string=? x (defeat-winner n)) (+ 1 m) m)]
       [(ties? n)
        (if (or (string=? x (defeat-winner(ties-defeat n)))
                (string=? x (defeat-winner(ties-defeat-inv n))))
         (+ 1 m) m)])) 0 lst))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; total-outcomes : Competitor OutcomeList -> Nonneg-Int
;; GIVEN: an arbitrary competitor A and a list of outcomes
;; RETURNS: the number of outcomes that mention A
;; EXAMPLES:
;;    (total-outcomes "C" (list (defeated "A" "D")
;;                  (defeated "A" "E")
;;                  (defeated "C" "B")
;;                  (defeated "C" "F")
;;                  (tie "D" "B")
;;                  (defeated "F" "E")))
;;      =>  2
;; STRATEGY: Use HOF foldr and lambda OutcomeList

(define (total-outcomes x lst)
  (foldr
   (lambda (n m)
     (cond
       [(defeat? n)
        (if (or (string=? x (defeat-winner n)) (string=? x (defeat-loser n)))
            (+ 1 m) m)]
       [(ties? n)
        (if (or (string=? x (defeat-winner(ties-defeat n)))
                (string=? x (defeat-winner(ties-defeat-inv n))))
         (+ 1 m) m)])) 0 lst))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; nlp : Competitor OutcomeList -> Nonneg-Int
;; GIVEN: an arbitrary competitor A and a list of outcomes
;; RETURNS: the non-losing percentage of a competitor A
;;    which is the number of outcomes in which A defeats or ties
;;    another competitor divided by the number of outcomes that mention A
;; EXAMPLES:
;;    (nlp "C" (list (defeated "A" "D")
;;                  (defeated "A" "E")
;;                  (defeated "C" "B")
;;                  (defeated "C" "F")
;;                  (tie "D" "B")
;;                  (defeated "F" "E")))
;;      =>  1
;; STRATEGY: transcribe formula

(define (nlp x lst)
  (/ (n-outcomes x lst) (total-outcomes x lst)))



;;TESTS

(begin-for-test
  (check-equal?
   (competitor-list (list (defeated "A" "D")
                           (defeated "A" "E")
                           (defeated "C" "B")
                           (defeated "C" "F")
                           (defeated "D" "B")
                           (tie "F" "E")
                           (tie "G" "E")))
   (list "A" "D" "E" "C" "B" "F" "G")
   "Error in extract elements")
  
  (check-equal?
   (length (outranked-by "C" (list (defeated "A" "D")
                                   (defeated "A" "E")
                                   (defeated "C" "B")
                                   (defeated "C" "F")
                                   (tie "D" "B")
                                   (defeated "F" "E"))))
   0
    "Error in number of outranked-by")

  (check-equal?
   (length (outranks "C" (list (defeated "A" "D")
                               (defeated "A" "E")
                               (defeated "C" "B")
                               (defeated "C" "F")
                               (tie "D" "B")
                               (defeated "F" "E"))))
   4
    "Error in number of outranks")

  (check-equal?
   (nlp "C" (list (defeated "A" "D")
                  (defeated "A" "E")
                  (defeated "C" "B")
                  (defeated "C" "F")
                  (tie "D" "B")
                  (defeated "F" "E")))
   1
    "Error in non-loss percentage")

  (check-equal?  
   (power-ranking (list (defeated "A" "D")
                        (defeated "A" "E")
                        (defeated "C" "B")
                        (defeated "C" "F")
                        (tie "D" "B")
                        (defeated "F" "E")))
   (list "C" "A" "F" "E" "B" "D")
   "Power-ranking is incorrect"))
