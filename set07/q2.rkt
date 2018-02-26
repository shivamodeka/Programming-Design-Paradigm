;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname q2) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require rackunit)
(require "extras.rkt")
(require "q1.rkt")
(check-location "07" "q2.rkt")

(provide lit
         literal-value
         var
         variable-name
         op
         operation-name
         call
         call-operator
         call-operands
         block
         block-var
         block-rhs
         block-body
         literal?
         variable?
         operation?
         call?
         block?
         undefined-variables
         well-typed?)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; REPRESENTATION OF TYPE

;; An type is represented as a struct
;; (make-type var name) with the folowing field

;; var  : String is the name of ythe variable
;; name : String is the name of the type
;;        and is one of
;;        -- Int
;;        -- Op0
;;        -- Op1
;;        -- Error

;; IMPLEMENTATION
(define-struct type (var name))

;; CONSTRUCTOR TEMPLATE:
;; (make-type String String)

;; OBSERVER TEMPLATE
;; type-fn : ArithmeticExpression -> ??

#| (define (type-fn t)
      (... (type-var t)
           (type-name t)))
|#

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; A TypeList is represented as a list of variable types 

;; CONSTRUCTOR TEMPLATES:
;; empty
;; (cons t tl)
;; -- WHERE
;;    t  is a Type
;;    tl is a TypeList


;; OBSERVER TEMPLATE:

;;  tl-fn : TypeList -> ??
;;  (define (tl-fn tl)
;;    (cond
;;     [(empty? tl) ...]
;;     [else (...
;;            (first tl)
;;	    (tl-fn (rest tl)))]))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; well-typed? : ArithmeticExpression -> Boolean
;; GIVEN: an arbitrary arithmetic expression
;; RETURNS: true if and only if the expression is well-typed
;; EXAMPLES:
;;     (well-typed? (lit 17))  =>  true
;;     (well-typed? (var "x"))  =>  false
;;
;;     (well-typed?
;;      (block (var "f")
;;             (op "+")
;;             (block (var "x")
;;                    (call (var "f") (list))
;;                    (call (op "*")
;;                          (list (var "x"))))) => true
;;
;;     (well-typed?
;;      (block (var "f")
;;             (op "+")
;;             (block (var "f")
;;                    (call (var "f") (list))
;;                    (call (op "*")
;;                          (list (var "f"))))) => true
;;
;;     (well-typed?
;;      (block (var "f")
;;             (op "+")
;;             (block (var "x")
;;                    (call (var "f") (list))
;;                    (call (op "*")
;;                          (list (var "f"))))) => false
;; STRATEGY : Use more general function


(define (well-typed? ae)
  (not (string=? (check-type ae (list)) "error")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
;; check-type : ArithmeticExpression TypeList -> String
;; GIVEN: an arbitrary arithmetic expression and a type list
;; WHERE: the TypeList contains the names of defined variables
;;        and their types, above the expression
;; RETURNS: the type of the arithmetic expression
;; EXAMPLE: (check-type (lit 2) (list)) -> "Int"
;; STRATEGY: Use observer template for ArithmeticExpression

(define (check-type exp lst)
  (cond
    ((literal? exp) "Int")
    ((variable? exp) (check-var exp lst))
    ((operation? exp) (check-op exp))
    ((call? exp) (check-call exp lst))
    ((block? exp) (check-block exp lst))
    ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; check-op : Operation -> String
;; GIVEN: an arbitrary operation expression 
;; RETURNS: the type of the operation expression
;; EXAMPLE: (check-op (op "/")) -> "Op1"
;; STRATEGY: Use observer template for Operation

(define (check-op ae)
  (if (or (string=? "+" (operation-name ae))
          (string=? "*" (operation-name ae)))
      "Op0"
      "Op1"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; check-var : Variable TypeList -> String
;; GIVEN: an arbitrary variable and a type list
;; WHERE: the TypeList contains the names of defined variables
;;        and their types, above the variable
;; RETURNS: the type of the variable
;; EXAMPLE: (check-var (var "x") (list)) -> "error"
;; STRATEGY: Use observer template for TypeList

#;(define (check-var ae lst)
  (cond
    [(empty? lst) "error"]
    [else (if (string=? (variable-name ae) (type-var (first lst)))
              (type-name (first lst))
              (check-var ae (rest lst)))]))

(define (check-var ae lst)
  (foldr
   (lambda (n m) (if (string=? (variable-name ae) (type-var n))
                     (type-name n) m)) "error" lst))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; check-block : Block TypeList -> String
;; GIVEN: an arbitrary block and a type list
;; WHERE: the TypeList contains the names of defined variables
;;        and their types, above the block
;; RETURNS: the type of the block
;; EXAMPLE: (check-block(block (var "x")
;;                       (call (op "+")
;;                             (list (lit 2)))
;;                       (call (op "*")
;;                             (list)))) -> "Int"
;; STRATEGY: Use the observer template for block

(define (check-block ae lst)
  (if (string=? "error" (check-type (block-rhs ae) lst))
      "error"
   (check-type (block-body ae)
               (cons (make-type (variable-name (block-var ae))
                                (check-type (block-rhs ae) lst))
                     lst))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; check-call : Call TypeList -> String
;; GIVEN: an arbitrary call and a type list
;; WHERE: the TypeList contains the names of defined variables
;;        and their types, above the call
;; RETURNS: the type of the call
;; EXAMPLE: (check-call (call (op "*")(list (lit 2))) -> "Int"
;; STRATEGY: Use HOF andmap and lambda on cases for call

(define (check-call ae lst)
  (cond
    [(and (string=? (check-type (call-operator ae) lst) "Op0")
          (andmap (lambda (n) (string=? "Int" (check-type n lst)))
                  (call-operands ae)))
     "Int"]
    [(and (string=? (check-type (call-operator ae) lst) "Op1")
          (andmap (lambda (n) (string=? "Int" (check-type n lst)))
                  (call-operands ae))
          (> (length(call-operands ae)) 0))
     "Int"]
    [else "error"]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;TESTS
  
  (begin-for-test
    (check-equal?
     (well-typed?(block (var "f")
                        (op "+")
                        (block (var "x")
                               (call (var "f") (list))
                               (call (op "*")
                                     (list (var "x"))))))
     true
     "Should return true")
    
    (check-equal?
     (well-typed?(block (var "f")
                        (op "+")
                        (block (var "x")
                               (call (var "f") (list))
                               (call (op "*")
                                     (list (var "y"))))))
     false
     "Should return false")
    
    (check-equal?
     (well-typed? (var "x"))
     false
     "Should return false")
    
    (check-equal?
     (well-typed? (lit 17))
     true
     "Should return true")

    (check-equal?
     (well-typed?
      (block (var "f")
             (op "+")
             (block (var "x")
                    (call (var "f") (list))
                    (call (op "*")
                          (list (var "x"))))))
     true
     "Should return true")
    
    (check-equal?
     (well-typed?
      (block (var "f")
             (op "+")
             (block (var "f")
                    (call (var "f") (list))
                    (call (op "*")
                          (list (var "f"))))))
     true
     "Should return true")
    
    (check-equal?
     (well-typed?
      (block (var "f")
             (op "+")
             (block (var "x")
                    (call (var "f") (list))
                    (call (op "*")
                          (list (var "f"))))))
     false
     "Should return false")
    
    (check-equal?
     (well-typed?(block (var "f")
                        (block (var "x")
                               (call (op "+")
                                     (list (lit 2)))
                               (call (op "*")
                                     (list (var "x"))))
                        (call (op "*")
                              (list (var "f")))))
     true
     "Should return true")
    
    (check-equal?
     (well-typed?(block (var "f")
                        (block (var "x")
                               (call (op "+")
                                     (list (lit 2)))
                               (call (op "*")
                                     (list (var "x"))))
                        (call (op "/")
                              (list (var "f")))))
     true
     "Should return true")
    
    (check-equal?
     (well-typed?(block (var "x")
                        (call (op "+")
                              (list (var "x")))
                        (call (op "*")
                              (list (var "x")))))
     false
     "Should return false")
    
    (check-equal?
     (check-type (block (var "f")
                        (block (var "x")
                               (call (op "+")
                                     (list (var "x")))
                               (call (op "*")
                                     (list (var "x"))))
                        (call (op "/")
                              (list (var "f")))) (list))
     "error"
     "Should return error")
    
    (check-equal?
     (well-typed? (block (var "x")
                              (block (var "z")
                                     (lit 2)
                                     (var "z"))
                              (block (var "y")
                                     (var "x")
                                     (var "y"))
                              ))
     true
     "Should return true")
    
    (check-equal?
     (well-typed?(block (var "x")
                        (call (op "+")
                              (list (lit 2)))
                        (call (op "/")
                              (list))))
     false
     "Should return false")
    
    (check-equal?
     (well-typed?(block (var "x")
                        (call (op "+")
                              (list (lit 2)))
                        (call (op "*")
                              (list))))
     true
     "Should return true"))