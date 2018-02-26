;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname q1) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;;;;;; Arithmetic Expressions ;;;;;;;;;

(require rackunit)
(require "extras.rkt")
(check-location "05" "q1.rkt")

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
         block?)
         

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; DATA DEFINITIONS

;; An OperationName is represented as one of the following strings:
;;     -- "+"      (indicating addition)
;;     -- "-"      (indicating subtraction)
;;     -- "*"      (indicating multiplication)
;;     -- "/"      (indicating division)
;;
;; OBSERVER TEMPLATE:
;; operation-name-fn : OperationName -> ??
#;
(define (operation-name-fn op)
  (cond ((string=? op "+") ...)
        ((string=? op "-") ...)
        ((string=? op "*") ...)
        ((string=? op "/") ...)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
          
;; An ArithmeticExpression is one of
;;     -- a Literal
;;     -- a Variable
;;     -- an Operation
;;     -- a Call
;;     -- a Block
;;
;; OBSERVER TEMPLATE:
;; arithmetic-expression-fn : ArithmeticExpression -> ??
#|
(define (arithmetic-expression-fn exp)
 (cond  ((literal? exp) ...)
        ((variable? exp) ...)
        ((operation? exp) ...)
        ((call? exp) ...)
        ((block? exp) ...)))
|#

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; REPRESENTATION OF LITERAL

;; A Literal is represented as a struct
;; (make-literal value) with the folowing field

;; value : Real   is a real number

;; IMPLEMENTATION
(define-struct literal (value))

;; CONSTRUCTOR TEMPLATE:
;; (make-literal Real)

;; OBSERVER TEMPLATE
#| (define (literal-fn l)
      (... (literal-value l)))
|#

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; REPRESENTATION OF VARIABLE

;; A Variable is represented as a struct
;; (make-variable name) with the folowing field

;; name : String   a name whose meaning will depend upon the context
;;                 in which it appears.

;; IMPLEMENTATION
(define-struct variable (name))

;; CONSTRUCTOR TEMPLATE:
;; (make-variable String)

;; OBSERVER TEMPLATE
#| (define (variable-fn v)
      (... (variable-name v)))
|#

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; REPRESENTATION OF OPERATION

;; An Operation is represented as a struct
;; (make-operation name) with the folowing field

;; name  : OperationName an arithmetic operation
;;         such as addition or division.


;; IMPLEMENTATION
(define-struct operation (name))

;; CONSTRUCTOR TEMPLATE:
;; (make-operation OperationName)

;; OBSERVER TEMPLATE
#| (define (operation-fn o)
      (... (operation-name o)))
|#

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; REPRESENTATION OF CALL

;; A Call is represented as a struct
;; (make-calls operator operands)

;; INTERPRETATION
;; operator   : ArithmeticExpression     is the operator expression of the call
;; operands   : ArithmeticExpressionList is the list of ArithmeticExpressions                  

;; IMPLEMENTATION:
(define-struct calls (operator operands))

;; CONSTRUCTOR TEMPLATES:

;; For Call:
;; (make-calls ArithmeticExpression ArithmeticExpressionList)

;; For ArithmeticExpressionList
;;   empty
;;   (cons ArithmeticExpression ArithmeticExpressionList)

;; OBSERVER TEMPLATES:

;; (define (calls-fn cl)
;;    (...
;;       (calls-operator cl)
;;       (aelist-fn (calls-operands cl))))


;; aelist-fn : ArithmeticExpressionList -> ??
;; (define (aelist-fn ol)
;;  (cond
;;    [(empty? ol) ...]
;;    [else (... (calls-fn (first ol)
;;               (aelist-fn (rest ol)))]))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; REPRESENTATION OF BLOCK

;; A Block is represented as a struct
;; (make-blocks var rhs body)

;; INTERPRETATION

;; var     : Variable               the variable defined by the block

;; rhs     : ArithmeticExpression   the expression whose value will become 
;;                                  the value of the variable defined by
;;                                  the block

;; body    : ArithmeticExpression   the expression whose value will become 
;;                                  the value of the block expression

;; IMPLEMENTATION:
(define-struct blocks (var rhs body))

;; CONSTRUCTOR TEMPLATE
;; (make-blocks Variable ArithmeticExpression ArithmeticExpression)

;; OBSERVER TEMPLATE
#| (define (blocks-fn b)
      (...
         (blocks-var b)
         (blocks-rhs b)
         (blocks-body b)))
|#

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; lit : Real -> Literal
;; GIVEN: a real number
;; RETURNS: a literal that represents that number
;; EXAMPLE: (see the example given for literal-value,
;;          which shows the desired combined behavior
;;          of lit and literal-value)
;; STARTEGY : Use observer template for literal on r

(define (lit r)
  (make-literal r))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; literal-value : Literal -> Real
;; GIVEN: a literal
;; RETURNS: the number it represents
;; EXAMPLE: (literal-value (lit 17.4)) => 17.4
;; STARTEGY : Use observer template for literal on l

(begin-for-test
  (check-equal?
   (literal-value (lit 17.4)) 17.4
   "Literal value should be 17.4"))
  

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; var : String -> Variable
;; GIVEN: a string
;; WHERE: the string begins with a letter and contains
;;     nothing but letters and digits
;; RETURNS: a variable whose name is the given string
;; EXAMPLE: (see the example given for variable-name,
;;          which shows the desired combined behavior
;;          of var and variable-name)
;; STARTEGY : Use observer template for variable on v

(define (var v)
  (make-variable v))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; variable-name : Variable -> String
;; GIVEN: a variable
;; RETURNS: the name of that variable
;; EXAMPLE: (variable-name (var "x15")) => "x15"
;; STARTEGY : Use observer template for variable on v

(begin-for-test
  (check-equal?
   (variable-name (var "x15")) "x15"
   "Vareable value should be x15"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; op : OperationName -> Operation
;; GIVEN: the name of an operation
;; RETURNS: the operation with that name
;; EXAMPLES: (see the examples given for operation-name,
;;           which show the desired combined behavior
;;           of op and operation-name)
;; STARTEGY : Use observer template for Operation on o

(define (op o)
  (make-operation o))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; operation-name : Operation -> OperationName
;; GIVEN: an operation
;; RETURNS: the name of that operation
;; EXAMPLES:
;;     (operation-name (op "+")) => "+"
;;     (operation-name (op "/")) => "/"
;; STARTEGY : Use observer template of Operation on op

(begin-for-test
  (check-equal?
   (operation-name (op "+")) "+"
   "Operation name should be +")
  (check-equal?
   (operation-name (op "/")) "/"
   "Operation name should be /"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; call : ArithmeticExpression ArithmeticExpressionList -> Call
;; GIVEN: an operator expression and a list of operand expressions
;; RETURNS: a call expression whose operator and operands are as
;;     given
;; EXAMPLES: (see the examples given for call-operator and
;;           call-operands, which show the desired combined
;;           behavior of call and those functions)
;; STARTEGY : Use observer template of calls on c

(define (call c d)
  (make-calls c d))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; call-operator : Call -> ArithmeticExpression
;; GIVEN: a call
;; RETURNS: the operator expression of that call
;; EXAMPLE:
;;     (call-operator (call (op "-")
;;                         (list (lit 7) (lit 2.5))))
;;         => (op "-")
;; STARTEGY : Use observer template of calls on c

(define (call-operator c)
  (calls-operator c))

(begin-for-test
  (check-equal?
   (call-operator (call (op "-")
                        (list (lit 7) (lit 2.5))))
   (op "-")
   "Call operator should return -"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; call-operands : Call -> ArithmeticExpressionList
;; GIVEN: a call
;; RETURNS: the operand expressions of that call
;; EXAMPLE:
;;     (call-operands (call (op "-")
;;                          (list (lit 7) (lit 2.5))))
;;         => (list (lit 7) (lit 2.5))
;; STARTEGY : Use observer template of calls on c

(define (call-operands c)
  (calls-operands c))

(begin-for-test
  (check-equal?
   (call-operands (call (op "-")
                        (list (lit 7) (lit 2.5))))
   (list (lit 7) (lit 2.5))
   "Call operand should return (list (lit 7) (lit 2.5))"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; block : Variable ArithmeticExpression ArithmeticExpression
;;             -> ArithmeticExpression
;; GIVEN: a variable, an expression e0, and an expression e1
;; RETURNS: a block that defines the variable's value as the
;;     value of e0; the block's value will be the value of e1
;; EXAMPLES: (see the examples given for block-var, block-rhs,
;;           and block-body, which show the desired combined
;;           behavior of block and those functions)
;; STARTEGY : Use observer template of block on b

(define (block a b c)
  (make-blocks a b c))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; block-var : Block -> Variable
;; GIVEN: a block
;; RETURNS: the variable defined by that block
;; EXAMPLE:
;;     (block-var (block (var "x5")
;;                       (lit 5)
;;                       (call (op "*")
;;                             (list (var "x6") (var "x7")))))
;;         => (var "x5")
;; STARTEGY : Use observer template of block on b

(define (block-var b)
  (blocks-var b))

(begin-for-test
  (check-equal?
   (block-var (block (var "x5")
                     (lit 5)
                     (call (op "*")
                           (list (var "x6") (var "x7")))))
                        (var "x5")
   "Block-var should return x5"))

;; block-rhs : Block -> ArithmeticExpression
;; GIVEN: a block
;; RETURNS: the expression whose value will become the value of
;;     the variable defined by that block
;; EXAMPLE:
;;     (block-rhs (block (var "x5")
;;                       (lit 5)
;;                       (call (op "*")
;;                             (list (var "x6") (var "x7")))))
;;         => (lit 5)
;; STARTEGY : Use observer template of block on b

(define (block-rhs b)
  (blocks-rhs b))

(begin-for-test
  (check-equal?
   (block-rhs (block (var "x5")
                     (lit 5)
                     (call (op "*")
                           (list (var "x6") (var "x7")))))
                        (lit 5)
   "Block-rhs should return 5"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; block-body : Block -> ArithmeticExpression
;; GIVEN: a block
;; RETURNS: the expression whose value will become the value of
;;     the block expression
;; EXAMPLE:
;;     (block-body (block (var "x5")
;;                        (lit 5)
;;                        (call (op "*")
;;                              (list (var "x6") (var "x7")))))
;;         => (call (op "*") (list (var "x6") (var "x7")))
;; STARTEGY : Use observer template for block on b

(define (block-body b)
  (blocks-body b))

(begin-for-test
  (check-equal?
   (block-body (block (var "x5")
                     (lit 5)
                     (call (op "*")
                           (list (var "x6") (var "x7")))))
                        (call (op "*") (list (var "x6") (var "x7")))
   "Block-rhs should return (make-calls (make-operation *)
    (list (make-variable x6) (make-variable x7)))"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; block?     : ArithmeticExpression -> Boolean
;; GIVEN: an arithmetic expression
;; RETURNS: true if and only the expression is a block
;; EXAMPLES:
;;     (variable? (block-body (block (var "y") (lit 3) (var "z"))))
;;         => true
;;     (variable? (block-rhs (block (var "y") (lit 3) (var "z"))))
;;         => false
;; STARTEGY : Use observer template for block on b

(define (block? a)
  (blocks? a))

(begin-for-test
  (check-equal?
   (variable? (block-body (block (var "y") (lit 3) (var "z"))))
true)
  (check-equal?
   (variable? (block-rhs (block (var "y") (lit 3) (var "z"))))
false)
  (check-equal?
   (block? (block (var "y") (lit 3) (var "z")))
   true))
   

;; call?     : ArithmeticExpression -> Boolean
;; GIVEN: an arithmetic expression
;; RETURNS: true if and only the expression is a call
;; EXAMPLES:
;;     (call? (block-body (block (var "y") (lit 3) (call (op "*")
;;                        (list (var "x6") (var "x7"))))))
;;         => true
;;     (variable? (block-rhs (block (var "y") (lit 3) (var "z"))))
;;         => false
;; STARTEGY : Use observer template for call on c

(define (call? c)
  (calls? c))

(begin-for-test
  (check-equal?
  (call? (block-body (block (var "y") (lit 3) (call (op "*")
                       (list (var "x6") (var "x7"))))))
   true))

;; literal?     : ArithmeticExpression -> Boolean
;; GIVEN: an arithmetic expression
;; RETURNS: true if and only the expression is a call
;; EXAMPLES:
;;     (variable? (block-body (block (var "y") (lit 3) (var "z"))))
;;         => true
;;     (variable? (block-rhs (block (var "y") (lit 3) (var "z"))))
;;         => false
;; STARTEGY : Use observer template for literal

(begin-for-test
  (check-equal?
  (literal? (block-rhs (block (var "y") (lit 3) (call (op "*")
                       (list (var "x6") (var "x7"))))))
   true))


;; variable?     : ArithmeticExpression -> Boolean
;; GIVEN: an arithmetic expression
;; RETURNS: true if and only the expression is a call
;; EXAMPLES:
;;     (variable? (block-body (block (var "y") (lit 3) (var "z"))))
;;         => true
;;     (variable? (block-rhs (block (var "y") (lit 3) (var "z"))))
;;         => false
;; STARTEGY : Use observer template for variable

(begin-for-test
  (check-equal?
  (variable? (block-var (block (var "y") (lit 3) (call (op "*")
                       (list (var "x6") (var "x7"))))))
   true))

;; operation?     : ArithmeticExpression -> Boolean
;; GIVEN: an arithmetic expression
;; RETURNS: true if and only the expression is a call
;; EXAMPLES:
;;     (variable? (block-body (block (var "y") (lit 3) (var "z"))))
;;         => true
;;     (variable? (block-rhs (block (var "y") (lit 3) (var "z"))))
;;         => false
;; STARTEGY : Use observer template for operation on c

(begin-for-test
  (check-equal?
  (operation? (op "*"))
   true))