;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname q2) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; q2.rkt

(require "extras.rkt")
(require rackunit)
(check-location "02" "q2.rkt")
(provide
        initial-state
        next-state
        is-red?
        is-green?)

;; DATA DEFINITIONS

;; A ChineseTrafficSignal is represented as a struct
;; with the following fields
;; in-state : PosInt is the iitial state of the traffic signal
;; state : Int is the next state of the traffic signal
;; is-red? : Boolean returns true iff the signal is red
;; is-green? : Boolean returns green iff the signal is green

;; IMPLEMENTATION
(define-struct cts (in-state state is-red? is-green?))

;; CONSTRUCTOR TEMPLATE
;; (make-cts PosInt Int Boolean Boolean)

;;OBSERVER TEMPLATE
(define (cts-fn l)
  (...
   (cts-in-state l)
   (cts-state l)
   (cts-is-red? l)
   (cts-is-green? l)))


;; initial-state : PosInt -> ChineseTrafficSignal
;; GIVEN: an integer n greater than 3
;; RETURNS: a representation of a Chinese traffic signal
;;          at the beginning of its red state, which will last
;;          for n seconds
;; EXAMPLE:
;;     (is-red? (initial-state 4))  =>  true
;; DESIGN STRATEGY: Use observer template for cts on l


(define (initial-state n)
  (make-cts n n true false)
 )



;; next-state : ChineseTrafficSignal -> ChineseTrafficSignal
;; GIVEN: a representation of a traffic signal in some state
;; RETURNS: the state that traffic signal should have one
;;          second later
;; DESIGN STRATEGY: Use observer template for cts on l


(define (next-state l)
  (cond
    [(= (cts-state l) (- 4 (cts-in-state l)))(make-cts (cts-in-state l)(- (cts-state l) 1) false false)]

     [(= (cts-state l) (- 3 (cts-in-state l)))(make-cts (cts-in-state l)(- (cts-state l) 1) false true)]
     
     [(= (cts-state l) (- 2 (cts-in-state l)))(make-cts (cts-in-state l)(- (cts-state l) 1) false false)]
    
     [(= (cts-state l) (- 1 (cts-in-state l)))(make-cts (cts-in-state l)(cts-in-state l) true false)]
     
     [(> (cts-state l) 1) (make-cts (cts-in-state l)(- (cts-state l) 1) true false)]

     [(< (cts-state l) 1) (make-cts (cts-in-state l)(- (cts-state l) 1) false true)]
     
  [else (make-cts (cts-in-state l)(- (cts-state l) 1) false true)]

    ))


 



;; is-red? : ChineseTrafficSignal -> Boolean
;; GIVEN: a representation of a traffic signal in some state
;; RETURNS: true if and only if the signal is red
;; EXAMPLES:
;;     (is-red? (next-state (initial-state 4)))  =>  true
;;     (is-red?
;;      (next-state
;;       (next-state
;;        (next-state (initial-state 4)))))  =>  true
;;     (is-red?
;;      (next-state
;;       (next-state
;;        (next-state
;;         (next-state (initial-state 4))))))  =>  false
;;     (is-red?
;;      (next-state
;;       (next-state
;;        (next-state
;;         (next-state
;;          (next-state (initial-state 4)))))))  =>  false
;; DESIGN STRATEGY: Use observer template for cts on l

(define (is-red? l)
  (cts-is-red? l))


;; is-green? : ChineseTrafficSignal -> Boolean
;; GIVEN: a representation of a traffic signal in some state
;; RETURNS: true if and only if the signal is green
;; EXAMPLES:
;;     (is-green?
;;      (next-state
;;       (next-state
;;        (next-state
;;         (next-state (initial-state 4))))))  =>  true
;;     (is-green?
;;      (next-state
;;       (next-state
;;        (next-state
;;         (next-state
;;          (next-state (initial-state 4)))))))  =>  false
;; DESIGN STRATEGY: Use observer template for cts on l

(define (is-green? l)
  (cts-is-green? l))

;; TESTS

(begin-for-test
  (check-equal?(initial-state 4)(make-cts 4 4 #true #false))


  (check-equal?(next-state (initial-state 4))(make-cts 4 3 #true #false))


  (check-equal?(is-red?
                (next-state
                 (next-state
                  (next-state
                   (next-state (initial-state 4)))))) false)


  (check-equal?(is-red? (next-state (initial-state 4))) true)



  (check-equal?(is-green?
                (next-state
                 (next-state
                  (next-state
                   (next-state (initial-state 4)))))) true )


  (check-equal?(is-green?
               
                (next-state
                 (next-state
                  (next-state
                   (next-state
                    (next-state (initial-state 4))))))) false)



  (check-equal?(is-green?
(next-state;red
  (next-state;false
   (next-state;true
    (next-state ;false
     (next-state  ;green
      (next-state
       (next-state
        (next-state
         (next-state
          (next-state 
           (next-state ;green
            (next-state
             (next-state
              (next-state
               (next-state
                (next-state
                 (next-state
                  (next-state
                   (next-state
                    (next-state (initial-state 10)))))))))))))))))))))) false)


  (check-equal?(is-green?

  (next-state;false
   (next-state;true
    (next-state ;false
     (next-state  ;green
      (next-state
       (next-state
        (next-state
         (next-state
          (next-state 
           (next-state ;green
            (next-state
             (next-state
              (next-state
               (next-state
                (next-state
                 (next-state
                  (next-state
                   (next-state
                    (next-state (initial-state 10))))))))))))))))))))) false)


  (check-equal?(is-green?

   (next-state;true
    (next-state ;false
     (next-state  ;green
      (next-state
       (next-state
        (next-state
         (next-state
          (next-state 
           (next-state ;green
            (next-state
             (next-state
              (next-state
               (next-state
                (next-state
                 (next-state
                  (next-state
                   (next-state
                    (next-state (initial-state 10)))))))))))))))))))) true)


  (check-equal?(is-green?

    (next-state ;false
     (next-state  ;green
      (next-state
       (next-state
        (next-state
         (next-state
          (next-state 
           (next-state ;green
            (next-state
             (next-state
              (next-state
               (next-state
                (next-state
                 (next-state
                  (next-state
                   (next-state
                    (next-state (initial-state 10))))))))))))))))))) false)


  (check-equal?(is-green?

     (next-state  ;green
      (next-state
       (next-state
        (next-state
         (next-state
          (next-state 
           (next-state ;green
            (next-state
             (next-state
              (next-state
               (next-state
                (next-state
                 (next-state
                  (next-state
                   (next-state
                    (next-state (initial-state 10)))))))))))))))))) true)


  (check-equal?(is-green?

      (next-state
       (next-state
        (next-state
         (next-state
          (next-state 
           (next-state ;green
            (next-state
             (next-state
              (next-state
               (next-state
                (next-state
                 (next-state
                  (next-state
                   (next-state
                    (next-state (initial-state 10))))))))))))))))) true)


  (check-equal?(is-green?

      
            (next-state
             (next-state
              (next-state
               (next-state
                (next-state
                 (next-state
                  (next-state
                   (next-state
                    (next-state (initial-state 10))))))))))) false)


  (check-equal?(is-red?

      
            (next-state
             (next-state
              (next-state
               (next-state
                (next-state
                 (next-state
                  (next-state
                   (next-state
                    (next-state (initial-state 10))))))))))) true))