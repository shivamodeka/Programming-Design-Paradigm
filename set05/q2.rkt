;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname q2) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;;;;;;; Constant Expressions ;;;;;;;


(require rackunit)
(require "extras.rkt")
(check-location "05" "q2.rkt")

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
         variables-defined-by
         variables-used-by
         constant-expression?
         constant-expression-value)
         

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

;; An OperationExpression is one of
;;      -- an Operation
;;      -- a Block whose body is an operation expression

;; CONSTRUCTOR TEMPLATE:

;; For Operation : (make-operation OperationName)
;; For Block     : (make-blocks Variable ArithmeticExpression
;;                  Operation)

;; OBSERVER TEMPLATE:

;; operation-expression-fn : OperationExpression -> ??

#|
(define (operation-expression-fn exp)
 (cond
        ((operation? exp) ...)
        ((block? exp) ...)))
|#

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; A ConstantExpression is an arithmetic expression that is either

;;      -- a Literal
;;      -- a Call whose operator is an operation expression and
;;                whose operands are all constant expressions
;;      -- a Block whose body is a constant expression

;; CONSTRUCTOR TEMPLATE:

;; For Literal : (make-literal Real)
;; For Call    : (make-calls OperationExpression ConstantExpression)
;; For Block   : (make-blocks Variable ArithmeticExpression
;;                  ConstantExpression)

;; OBSERVER TEMPLATE:

;; constant-expression-fn : ConstantExpression -> ??

#|
(define (constant-expression-fn exp)
 (cond
        ((literal? exp) ...)
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
true
"It should return a true")
  (check-equal?
   (variable? (block-rhs (block (var "y") (lit 3) (var "z"))))
false
"3 is not a variable")
  (check-equal?
   (block? (block (var "y") (lit 3) (var "z")))
   true
   "It should return a true"))
   

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
   true)
  "It should return a true")

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
   true)
  "It should return a true")


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
   true)
  "It should return a true")

;; operation?     : ArithmeticExpression -> Boolean
;; GIVEN: an arithmetic expression
;; RETURNS: true if and only the expression is a call
;; EXAMPLES:
;;     (variable? (block-body (block (var "y") (lit 3) (var "z"))))
;;         => true
;;     (variable? (block-rhs (block (var "y") (lit 3) (var "z"))))
;;         => false
;; STARTEGY : Use observer template for operation

(begin-for-test
  (check-equal?
  (operation? (op "*"))
   true)
  "It should return a true")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; variables-defined-by : ArithmeticExpression -> StringList
;; GIVEN: an arithmetic expression
;; RETURNS: a list of the names of all variables defined by
;;     all blocks that occur within the expression, without
;;     repetitions, in any order
;; EXAMPLE:
;;     (variables-defined-by
;;      (block (var "x")
;;             (var "y")
;;             (call (block (var "z")
;;                          (var "x")
;;                          (op "+"))
;;                   (list (block (var "x")
;;                                (lit 5)
;;                                (var "x"))
;;                         (var "x")))))
;;  => (list "x" "z") or (list "z" "x")
;; STRATRGY : Combine simpler functions

(define (variables-defined-by ae)
  (remove-dup (find-variables ae)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; find-variables : ArithmeticExpression -> StringList
;; GIVEN: an arithmetic expression
;; RETURNS: a list of the names of all variables defined by
;;     all blocks that occur within the expression, without
;;     repetitions, in any order
;; EXAMPLE:
;;     (variables-defined-by
;;      (block (var "x")
;;             (var "y")
;;             (call (block (var "z")
;;                          (var "x")
;;                          (op "+"))
;;                   (list (block (var "x")
;;                                (lit 5)
;;                                (var "x"))
;;                         (var "x")))))
;;  => (list "x" "z" "x")
;; STRATEGY : cases on the template of call and block

(define (find-variables ae)
  (cond
    [(block? ae)
     (if (and (variable? (block-rhs ae))
              (string=? (variable-name(block-var ae))
                        (variable-name(block-rhs ae))))
         (append
           (find-variables (block-rhs ae))
                           (find-variables (block-body ae)))
     (append (cons (variable-name(block-var ae)) empty)
           (find-variables (block-rhs ae))
                           (find-variables (block-body ae))))]
    [(call? ae)
     (append (find-variables(call-operator ae))
             (calls-variable (call-operands ae)))]
    [else (list)]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; calls-variable : ArithmeticExpression -> StringList
;; GIVEN: an arithmetic expression
;; RETURNS: a list of the names of all variables defined by
;;     all blocks that occur within the expression, without
;;     repetitions, in any order
;; EXAMPLES : see tests below
;; STRATEGY : cases on the template of call

(define (calls-variable ae)
  (cond
    [(empty? ae) empty]
    [(block? (first ae))
             (append(find-variables (first ae))(calls-variable (rest ae)))]
    
    [else (append(find-variables (first ae))(calls-variable (rest ae)))]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; remove-dup : StringList -> StringList
;; GIVEN: a string list with duplicates
;; RETURNS: a string list like the previous string list but without duplicates
;; EXAMPLES : (remove-dup (list "x" "z" "x")) => (list "z" "x")
;; STRATEGY : using template of a list

(define (remove-dup l)
  (cond
    [(empty? l) empty]
    [(member (first l) (rest l))
     (remove-dup (rest l))]
    [else (cons (first l)(remove-dup (rest l)))]))

;;;;;;;;;;;;;;;;;;;;; TESTS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
         

(begin-for-test
  (check-equal?
   (variables-defined-by
      (block (var "x")
             (var "y")
             (call (block (var "z")
                          (var "x")
                          (op "+"))
                   (list (block (var "x")
                                (lit 5)
                                (var "x"))
                         (var "x")))))
   (list "z" "x")
   "Expression is not properly defined")
  (check-equal?
   (variables-defined-by
      (block (var "x")
             (var "y")
             (call (block (var "z")
                          (var "x")
                          (op "+"))
                   (list (block (var "x")
                                (lit 5)
                                (var "x"))
                         (block (var "y")
                                (lit 5)
                                (call (block (var "a")
                          (var "x")
                          (op "+"))
                   (list (block (var "b")
                                (lit 5)
                                (var "x"))
                         (block (var "c")
                                (lit 5)
                                (var "x")))))))))
  (list "z" "x" "y" "a" "b" "c")
   "Expression is not properly defined"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; variables-used-by : ArithmeticExpression -> StringList
;; GIVEN: an arithmetic expression
;; RETURNS: a list of the names of all variables used in
;;     the expression, including variables used in a block
;;     on the right hand side of its definition or in its body,
;;     but not including variables defined by a block unless
;;     they are also used
;; EXAMPLE:
;;     (variables-used-by
;;      (block (var "x")
;;             (var "y")
;;             (call (block (var "z")
;;                          (var "x")
;;                          (op "+"))
;;                   (list (block (var "x")
;;                                (lit 5)
;;                                (var "x"))
;;                         (var "x")))))
;;  => (list "x" "y") or (list "y" "x")
;; STRATRGY : Combine simpler functions

(define (variables-used-by ae)
  (remove-dup (find-all-variables ae)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; find-all-variables : ArithmeticExpression -> StringList
;; GIVEN: an arithmetic expression
;; RETURNS: a list of the names of all variables used in
;;     the expression, including variables used in a block
;;     on the right hand side of its definition or in its body,
;;     but not including variables defined by a block unless
;;     they are also used
;; EXAMPLE:
;;     (variables-defined-by
;;      (block (var "x")
;;             (var "y")
;;             (call (block (var "z")
;;                          (var "x")
;;                          (op "+"))
;;                   (list (block (var "x")
;;                                (lit 5)
;;                                (var "x"))
;;                         (var "x")))))
;;  => (list "y" "x" "x")
;; STRATEGY : cases on the template of call and block

(define (find-all-variables ae)
  (cond
    [(variable? ae)
     (list (variable-name ae))]
    [(block? ae)
     (if (variable? (block-rhs ae))
     (cons (variable-name(block-rhs ae)) (find-all-variables (block-body ae)))
     (append (find-all-variables (block-rhs ae))(find-all-variables (block-body ae))))]
    [(call? ae)
     (append (find-all-variables(call-operator ae))
             (call-variables (call-operands ae)))]
    [else (list)]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; call-variables : ArithmeticExpression -> StringList
;; GIVEN: an arithmetic expression
;; RETURNS: a list of the names of all variables used in
;;     the expression, including variables used in a block
;;     on the right hand side of its definition or in its body,
;;     but not including variables defined by a block unless
;;     they are also used
;; STRATEGY : cases on the template of call

(define (call-variables ae)
  (cond
    [(empty? ae) empty]
    [(variable? (first ae))
                (append(find-all-variables (first ae))
                       (call-variables (rest ae)))]
    [(block? (first ae))
             (append(find-all-variables (first ae))(call-variables (rest ae)))]
    
    [else (call-variables (rest ae))]))

;;;;;;;;;;;;;;;;;;;;;;;;;; TESTS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(begin-for-test
  (check-equal?
   (variables-used-by
           (block (var "x")
              (var "y")
                     (call (block (var "z")
                                 (var "x")
                                  (op "+"))
                           (list (block (var "x")
                                       (lit 5)
                                          (var "x"))
                                (var "x")(var "a")(lit 5)(var "c")(var "d")))))
   (list "y" "x" "a" "c" "d")
    "Expression is not properly defined"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; constant-expression? : ArithmeticExpression -> Boolean
;; GIVEN: an arithmetic expression
;; RETURNS: true if and only if the expression is a constant
;;     expression
;; EXAMPLES:
;;     (constant-expression?
;;      (call (var "f") (list (lit -3) (lit 44))))
;;         => false
;;     (constant-expression?
;;      (call (op "+") (list (var "x") (lit 44))))
;;         => false
;;     (constant-expression?
;;      (block (var "x")
;;             (var "y")
;;             (call (block (var "z")
;;                          (call (op "*")
;;                                (list (var "x") (var "y")))
;;                          (op "+"))
;;                   (list (lit 3)
;;                         (call (op "*")
;;                               (list (lit 4) (lit 5)))))))
;;         => true
;; STRATEGY : Combine simpler functions

(define (constant-expression? ae)
  (cond
    [(literal? ae) true]
    [(call? ae)
     (and (operation-expression? (call-operator ae))
          (not (member false(check-call (call-operands ae)))))]
    [(block? ae)
     (constant-expression? (block-body ae))]
    [else false]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; operation-expression? : ArithmeticExpression -> Boolean
;; GIVEN: an arithmetic expression
;; RETURNS: true if and only if the expression is an opertion
;;          expression
;; EXAMPLES: see tests below
;; STARTEGY : using template of operation expression

(define (operation-expression? ae)
  (cond
    [(operation? ae) true]
    [(block? ae)
     (operation-expression? (block-body ae))]
    ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; check-call : ArithmeticExpressionList -> ArithmeticExpressionList
;; GIVEN : list of call operands
;; RETURNS : a list containing boolean for each of the list items
;; EXAMPLES : (check-call (lit 2) (lit 3)) => (true true)
;;            (check-call (lit 2) (var "x")) => (true false)
;; STRATEGY : use template for constant expression 

(define (check-call l)
  (cond
    [(empty? l) empty]
    [else (cons(constant-expression? (first l))
      (check-call (rest l)))]))

;;;;;;;;;;;;;;;;;;;;; TESTS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(begin-for-test
  (check-equal?
   (constant-expression?
                (block (var "x")
                       (var "y")
                       (call (block (var "z")
                                    (call (op "*")
                                          (list (var "x") (var "y")))
                                    (op "+"))
                             (list (lit 3)
                                   (call (op "*")
                                         (list (lit 4) (lit 5)))))))
   true
   "Should return a true")
  (check-equal?
   (constant-expression?
                (block (var "x")
                       (var "y")
                       (call (block (var "z")
                                    (call (op "*")
                                          (list (var "x") (var "y")))
                                    (op "+"))
                             (list (lit 3)
                                   (call (op "*")
                                         (list (var "q") (lit 5)))))))
   false)
  "This is not a constant expression")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; constant-expression-value : ArithmeticExpression -> Real
;; GIVEN: an arithmetic expression
;; WHERE: the expression is a constant expression
;; RETURNS: the numerical value of the expression
;; EXAMPLES:
;;     (constant-expression-value
;;      (call (op "/") (list (lit 15) (lit 3))))
;;         => 5
;;     (constant-expression-value
;;      (block (var "x")
;;             (var "y")
;;             (call (block (var "z")
;;                          (call (op "*")
;;                                (list (var "x") (var "y")))
;;                          (op "+"))
;;                   (list (lit 3)
;;                         (call (op "*")
;;                               (list (lit 4) (lit 5)))))))
;;         => 23
;; STRATEGY :  Combine simpler functions

(define (constant-expression-value ae)
  (check-values (compute-val ae)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; compute-val : ArithmeticExpression -> ArithmeticExpressionList
;; GIVEN: an arithmetic expression
;; WHERE: the expression is a constant expression
;; RETURNS: List of the expression
;; EXAMPLES:
;;     (constant-expression-value
;;      (call (op "/") (list (lit 15) (lit 3))))
;;         => 5
;;     (constant-expression-value
;;      (block (var "x")
;;             (var "y")
;;             (call (block (var "z")
;;                          (call (op "*")
;;                                (list (var "x") (var "y")))
;;                          (op "+"))
;;                   (list (lit 3)
;;                         (call (op "*")
;;                               (list (lit 4) (lit 5)))))))
;;         => (list "+" 3 (list "*" 4 5))
;; STRATEGY :  Combine simpler functions

(define (compute-val ae)
  (cond
    [(literal? ae) (literal-value ae)]
    [(call? ae)
     (cons (operation-expression-value (call-operator ae))
          (check-call-value (call-operands ae)))]
    [(block? ae)
     (compute-val (block-body ae))]
    ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; operation-expression-value : ArithmeticExpression -> OperationName
;; GIVEN: an arithmetic expression
;; RETURNS: value of the operation expression
;; EXAMPLES: see tests below
;; STARTEGY : using template of operation expression

(define (operation-expression-value ae)
  (cond
    [(operation? ae) (operation-name ae)]
    [(block? ae)
     (operation-expression-value (block-body ae))]
    ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; check-call-value : ArithmeticExpressionList -> ArithmeticExpressionList
;; GIVEN : list of call operands
;; RETURNS : a list containing values for each of the list items
;; EXAMPLES : (check-call (lit 2) (lit 3)) => (list 2 3)
;; STRATEGY : use template for constant expression 

(define (check-call-value l)
  (cond
    [(empty? l) empty]
    [else (cons(compute-val (first l))
      (check-call-value (rest l)))]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; check-values : ArithmeticExpressionList -> ArithmeticExpressionList
;; GIVEN : An List containing values
;; RETURNS : Simplified list
;; EXAMPLES : (check-values (list "+" 3 (list "*" 4 5))) => (list "+" 3 20)
;; STRATEGY : use template for list

(define (check-values l)
  (cond
   [(string? (first l))
     (check-value l)
     ]
    [else (check-values (first l))]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; check-value : ArithmeticExpressionList -> Real
;; GIVEN : An List containing values
;; RETURNS : value of the list
;; EXAMPLES : (check-value (list "+" 3 2) => 5
;; STRATEGY : use cases on the operator string 


(define (check-value l)
  (cond
    [(string=? "+" (first l))
     (n-sum (rest l))]
    [(string=? "-" (first l))
     (n-sub (rest l))]
    [(string=? "*" (first l))
     (n-mul (rest l))]
    [(string=? "/" (first l))
     (n-div (rest l))]
     ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; n-sum : ArithmeticExpressionList -> Real
;; GIVEN : An ArithmeticExpressionList containing values
;; RETURNS : sum of the values in the list
;; EXAMPLES : (n-sum (list "+" 3 2) => 5
;; STRATEGY : transcribe formula 

(define (n-sum l)
  (cond
    [(empty? l) 0]
    [else (if (number? (first l))
         (+ (first l) (n-sum (rest l)))
         (+(check-values l)(n-sum (rest l))))]))

;; n-sub : ArithmeticExpressionList -> Real
;; GIVEN : An ArithmeticExpressionList containing values
;; RETURNS : difference of the values in the list
;; EXAMPLES : (n-sub (list "-" 3 2) => 1
;; STRATEGY : transcribe formula

(define (n-sub l)
  (cond
    [(empty? l) 0]
    [else (if (number? (first l))
         (- (first l) (n-sub (rest l)))
         (-(check-values l)(n-sub (rest l))))]))

;; n-mul : ArithmeticExpressionList -> Real
;; GIVEN : An ArithmeticExpressionList containing values
;; RETURNS : product of the values in the list
;; EXAMPLES : (n-mul (list "*" 3 2) => 6
;; STRATEGY : transcribe formula 

(define (n-mul l)
  (cond
    [(empty? l) 1]
    [else (if (number? (first l))
         (* (first l) (n-mul (rest l)))
         (*(check-values l)(n-mul (rest l))))]))

;; n-div : ArithmeticExpressionList -> Real
;; GIVEN : An ArithmeticExpressionList containing values
;; RETURNS : division of the values in the list
;; EXAMPLES : (n-div (list "/" 10 2) => 5
;; STRATEGY : transcribe formula 

(define (n-div l)
  (cond
    [(empty? l) 1]
    [else (if (number? (first l))
         (/ (first l) (n-div (rest l)))
         (/(check-values l)(n-div (rest l))))]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;; TESTS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(begin-for-test
  (check-equal?
(constant-expression-value
                (block (var "x")
                       (var "y")
                       (call (block (var "z")
                                    (call (op "*")
                                          (list (var "x") (var "y")))
                                    (op "+"))
                             (list (lit 3)
                                   (call (op "*")
                                         (list (lit 4) (lit 5)))))))
23
"value returned is not correct")
  (check-equal?
   (constant-expression-value
             (call (op "/") (list (lit 15) (lit 3))))
   5
   "value returned is not correct")
  (check-equal?
   (check-values(list "*" 1 (list "+" 3 (list "/" 15 (list "-" 7 4)))))
   8
   "value returned is not correct")
  (check-equal?
   (check-values(list "-" 1 (list "+" 3 (list "/" 15 (list "-" 7 4)))))
   -7
   "value returned is not correct")
  (check-equal?
   (check-values(list "/" 100 (list "+" 3 (list "/" 15 (list "-" 7 4)))))
   12.5
   "value returned is not correct")
  (check-equal?
   (check-values (list "+" 2 3 4 5))
   14
   "value returned is not correct"))



(define (undefined-variables ae)
  (remove-defined (variables-defined-by ae) (variables-used-by ae)))

(define (remove-defined vlst lst)
  (cond
    [(empty? lst) empty]
    [else (if (member (first lst) vlst)
              (remove-defined vlst (rest lst))
              (cons (first lst)
                    (remove-defined vlst (rest lst))))]))