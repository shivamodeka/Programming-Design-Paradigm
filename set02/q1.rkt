;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname q1) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; q1.rkt

(require "extras.rkt")
(require rackunit)
(check-location "02" "q1.rkt")
(provide
        make-lexer
        lexer-token
        lexer-input
        initial-lexer
        lexer-stuck?
        lexer-shift
        lexer-reset)

;; A lexer is represented by a struct
;; with the following fields
;; token : String is the token string of the lexer
;; input : String is the input string of the lexer

;; IMPLEMENTATION
(define-struct lexer (token input))

;; CONSTRUCTOR TEMPLATE
;; (make-lexer String String)


;; make-lexer : String String -> Lexer
;; GIVEN: two strings s1 and s2
;; RETURNS: a Lexer whose token string is s1
;; and whose input string is s2

;; lexer-token : Lexer -> String
;; RETURNS: its token string
;; EXAMPLE:
;;     (lexer-token (make-lexer "abc" "1234")) =>  "abc"

;; lexer-input : Lexer -> String
;; GIVEN: a Lexer
;; RETURNS: its input string
;; EXAMPLE:
;;     (lexer-input (make-lexer "abc" "1234")) =>  "1234"

;; OBSERVER TEMPLATE
(define (lexer-fn l)
  (...
   (lexer-token l)
   (lexer-input l)))

;; initial-lexer : String -> Lexer
;; GIVEN: an arbitrary string
;; RETURNS: a Lexer lex whose token string is empty
;; and whose input string is the given string
;; EXAMPLE:
;;     (initial-lexer "Shivam") => (make-lexer "" "Shivam")
;; STRATEGY : Combine simpler functions

(define (initial-lexer String)
  (make-lexer "" String))



;; lexer-stuck? : Lexer -> Boolean
;; GIVEN: a Lexer
;; RETURNS: false if and only if the given Lexer's input string
;;          is non-empty and begins with an English letter or digit;
;;          otherwise returns true.
;; EXAMPLES:
;;     (lexer-stuck? (make-lexer "abc" "1234"))  =>  false
;;     (lexer-stuck? (make-lexer "abc" "+1234"))  =>  true
;;     (lexer-stuck? (make-lexer "abc" ""))  =>  true
;; STRATEGY : Use observer template for lexer

(define (lexer-stuck? l)
 (or
  (string=? "" (lexer-input l))
  (not (or
        (string-alphabetic? (string-ith (lexer-input l) 0))
                                       (string-numeric? (string-ith (lexer-input l) 0))))))


;; lexer-shift : Lexer -> Lexer
;; GIVEN: a Lexer
;; RETURNS:
;;   If the given Lexer is stuck, returns the given Lexer.
;;   If the given Lexer is not stuck, then the token string
;;       of the result consists of the characters of the given
;;       Lexer's token string followed by the first character
;;       of that Lexer's input string, and the input string
;;       of the result consists of all but the first character
;;       of the given Lexer's input string.
;; EXAMPLES:
;;     (lexer-shift (make-lexer "abc" ""))
;;         =>  (make-lexer "abc" "")
;;     (lexer-shift (make-lexer "abc" "+1234"))
;;         =>  (make-lexer "abc" "+1234")
;;     (lexer-shift (make-lexer "abc" "1234"))
;;         =>  (make-lexer "abc1" "234")
;; STRATEGY : Use observer template for lexer

(define (lexer-shift l)
  
   (if (lexer-stuck? l) l (make-lexer (string-append (lexer-token l) (string-ith (lexer-input l) 0)) (substring (lexer-input l) 1 (string-length (lexer-input l))))
                                         ))

   


;; lexer-reset : Lexer -> Lexer
;; GIVEN: a Lexer
;; RETURNS: a Lexer whose token string is empty and whose
;;     input string is empty if the given Lexer's input string
;;     is empty and otherwise consists of all but the first
;;     character of the given Lexer's input string.
;; EXAMPLES:
;;     (lexer-reset (make-lexer "abc" ""))
;;         =>  (make-lexer "" "")
;;     (lexer-reset (make-lexer "abc" "+1234"))
;;         =>  (make-lexer "" "1234")
;; STRATEGY : Use observer template for lexer

(define (lexer-reset l)
  (if (string=? "" (lexer-input l))(make-lexer "" "") (make-lexer "" (substring (lexer-input l) 1 (string-length (lexer-input l)))))
  )



;; TESTS

(begin-for-test
  (check-equal?
   (initial-lexer "abc")
   (make-lexer "" "abc"))
  (check-equal?
   (lexer-stuck?(make-lexer "wwefw" ""))
   true)
  (check-equal?
   (lexer-stuck?(make-lexer "wwefw" "1234"))
   false)
  (check-equal?
   (lexer-stuck?(make-lexer "wwefw" "+1234"))
   true)
  (check-equal?
   (lexer-shift (make-lexer "abc" "1234"))
   (make-lexer "abc1" "234"))
  (check-equal?
   (lexer-shift (make-lexer "abc" "+1234"))
   (make-lexer "abc" "+1234"))
  (check-equal?
   (lexer-shift (make-lexer "abc" ""))
   (make-lexer "abc" ""))
  (check-equal?
   (lexer-reset (make-lexer "abc" ""))
   (make-lexer "" ""))
  (check-equal?
   (lexer-reset (make-lexer "abc" "1234"))
   (make-lexer "" "234"))
  )