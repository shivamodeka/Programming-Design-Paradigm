;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname q2) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require rackunit)
(require "extras.rkt")

(require 2htdp/universe)
(require 2htdp/image)

(check-location "03" "q2.rkt")

(provide simulation
            initial-world
            world-ready-to-serve?
            world-after-tick
            world-after-key-event
            world-ball
            world-racket
            ball-x
            ball-y
            racket-x
            racket-y
            ball-vx
            ball-vy
            racket-vx
            racket-vy
            world-after-mouse-event
            racket-after-mouse-event
            racket-selected?)


;;; simulation : PosReal -> World
          ;;; GIVEN: the speed of the simulation, in seconds per tick
          ;;;     (so larger numbers run slower)
          ;;; EFFECT: runs the simulation, starting with the initial world
          ;;; RETURNS: the final state of the world
          ;;; EXAMPLES:
          ;;;     (simulation 1) runs in super slow motion
          ;;;     (simulation 1/24) runs at a more realistic speed

(define (simulation simulation-speed)
  (big-bang (initial-world simulation-speed)
            (on-tick world-after-tick simulation-speed )
            (on-draw world-to-scene)
            (on-key world-after-key-event)
            (on-mouse world-after-mouse-event)))

;;; initial-world : PosReal -> World
          ;;; GIVEN: the speed of the simulation, in seconds per tick
          ;;;     (so larger numbers run slower)
          ;;; RETURNS: the ready-to-serve state of the world
          ;;; EXAMPLE: (initial-world 1)

(define (initial-world y)
  
   (make-world (make-ball INITIAL-X-POS INITIAL-Y-POS 0 0)
                (make-racket INITIAL-X-POS INITIAL-Y-POS 0 0 false 0 0)
                WHITE
                0
                y
                true false)
   )

;; CONSTANTS

(define BALL (circle 3 "solid" "black"))
(define RACKET (rectangle 47 7 "solid" "green"))
(define DOT (circle 4 "solid" "blue"))
(define INITIAL-X-POS 330)
(define INITIAL-Y-POS 384)
(define HALF-LENGTH 23.5)

;; dimensions of the canvas
(define CANVAS-WIDTH 425)
(define CANVAS-HEIGHT 649)
(define EMPTY-CANVAS (empty-scene CANVAS-WIDTH CANVAS-HEIGHT))
(define YELLOW-CANVAS (empty-scene CANVAS-WIDTH CANVAS-HEIGHT "yellow"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; DATA DEFINITIONS

;; REPRESENTATION OF WORLD:

;; A World is represented as a (make-world ball racket ready-to-serve? simulation-speed)

;; INTERPRETATION:

;; ball            : BALL     the ball in the world
;; racket          : Racket   the racket in the world
;; wall-color      : Color    is the color of the wall. Either white or yellow.
;; timer           : PosReal  is the resiprocal of the simulation speed
;; simulation-speed: PosReal  is the simulation speed of the world
;; ready-to-serve? : Boolean  is the world ready to serve?
;; is-rally:       : Boolean  is the world in rally state?

;; IMPLEMENTATION:
(define-struct world (ball racket wall-color timer simulation-speed ready-to-serve? is-rally?))

;; CONSTRCTOR TEMPLATE:
;; (make-world Ball Racket Color PosReal PosReal Boolean Boolean)

;; OBSERVER TEMPLATE:
;; world-fn : World -> ??
(define (world-fn w)
  (...
   (world-ball w)
   (world-racket w)
   (world-wall-color w)
   (world-timer w)
   (world-simulation-speed w)
   (world-ready-to-serve? w)
   (world-is-rally? w)
   ))

;; EXAMPLES
;;(make-world (make-cat 300 300 0 0)(make-racket 300 300 0 0 false) WHITE 0 1/24 TRUE FALSE)
;;(make-world (make-cat 384 189 -3 9)(make-racket 300 300 8 -5 false) WHITE 0 1/24 FALSE TRUE)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; REPRESENTATION OF BALL:

;; A Ball is represented as (make-ball x y vx vy)

;; INTERPRETATION:

;; x, y   : Integer      the position of the center of the ball
;;                             in the scene 
;; vx, vy : Integer      the velocity of the center of the ball
;;                             in the scene 

;; IMPLEMENTATION
(define-struct ball (x y vx vy))

;; CONSTRUCTOR TEMPLATE:
;; (make-ball Integer Integer Integer Integer)

;; OBSERVER TEMPLATE:
;; template:
;; ball-fn : Ball -> ??
(define (ball-fn w)
 (... (ball-x w)
      (ball-y w) 
      (ball-vx w)
      (ball-vy w)))

;; EXAMPLES
;; (make-cat 300 300 0 0)
;; (make-cat 330 384 3 -9)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; REPRESENTATION OF RACKET

;; A Racket is represented as (make-racket x y vx vy selected?)

;; INTERPRETATION:

;; x, y   : Integer      the position of the center of the racket
;;                             in the scene 
;; vx, vy : Integer      the velocity of the center of the racket
;;                             in the scene
;; selected?: Boolean    whether the racket is selected

;; IMPLEMENTATION
(define-struct racket (x y vx vy selected? px py))

;; CONSTRUCTOR TEMPLATE:
;; (make-racket Integer Integer Integer Integer Boolean)

;; OBSERVER TEMPLATE:
;; template:
;; racket-fn : racket -> ??
(define (racket-fn w)
 (... (racket-x w)
      (racket-y w) 
      (racket-vx w)
      (racket-vy w)
      (racket-selected? w)
      (racket-px w)
      (racket-py w)))

;; EXAMPLES
;; (make-racket 300 300 0 0 false)
;; (make-racket 330 384 3 -9 true)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; REPRESENTATION OF COLOR

;; a Color is represented by one of the strings
;; -- "white"
;; -- "yellow" 
;; INTERP: self-evident
;; EXAMPLES:
(define WHITE "white")
(define YELLOW "yellow")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Help functions for key event

;; is-space-key-event? : KeyEvent -> Boolean
;; GIVEN: a KeyEvent
;; RETURNS: true iff the KeyEvent is space

(define (is-space-key-event? ke)
  (key=? ke " "))

;; is-up-key-event? : KeyEvent -> Boolean
;; GIVEN: a KeyEvent
;; RETURNS: true iff the KeyEvent is up

(define (is-up-key-event? ke)
  (key=? ke "up"))

;; is-down-key-event? : KeyEvent -> Boolean
;; GIVEN: a KeyEvent
;; RETURNS: true iff the KeyEvent is down

(define (is-down-key-event? ke)
  (key=? ke "down"))

;; is-left-key-event? : KeyEvent -> Boolean
;; GIVEN: a KeyEvent
;; RETURNS: true iff the KeyEvent is left

(define (is-left-key-event? ke)
  (key=? ke "left"))

;; is-right-key-event? : KeyEvent -> Boolean
;; GIVEN: a KeyEvent
;; RETURNS: true iff the KeyEvent is right

(define (is-right-key-event? ke)
  (key=? ke "right"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; world-after-key-event : World KeyEvent -> World
;;; GIVEN  : a world and a key event
;;; RETURNS: the world that should follow the given world
;;;          after the given key event
;;; on space, rally-toggled?
;;; on-up, world-after-up
;;; on-down, world-aftre-down
;;; on-left, world-after-left
;;; on-right, world-after-right
;;; ignore rest
;;; EXAMPLES: see tests below
;;; STRATEGY : Cases on the key event

(define (world-after-key-event w kev)
  (cond [ (is-space-key-event? kev)
    (rally-toggled w)]
        [ (is-up-key-event? kev)
          (world-after-up w)]
        [ (is-down-key-event? kev)
          (world-after-down w)]
        [ (is-left-key-event? kev)
          (world-after-left w)]
        [ (is-right-key-event? kev)
          (world-after-right w)]
        [else w]

        )
  )



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; world-after-up : World -> World
;; RETURNS: a world with the racket's vy component decreased by 1 iff the world is in rally state
;; STRATEGY: Use constructor template for World on w

(define (world-after-up w)
  (if (world-is-rally? w)
   (make-world
       (world-ball w)
        (racket-after-up(world-racket w))
        WHITE
        0
        (world-simulation-speed w)
                false
                true
        )
   w))

;; racket-after-up : Racket -> Racket
;; RETURNS: a racket with the racket's vy component decreased by 1
;; STRATEGY: Use constructor template for Racket on r

(define (racket-after-up r)
  (make-racket (racket-x r) (racket-y r) (racket-vx r)(- (racket-vy r) 1) (racket-selected? r) 0 0))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; world-after-down : World -> World
;; RETURNS: a world with the racket's vy component increased by 1 iff the world is in rally state
;; STRATEGY: Use constructor template for World on w

(define (world-after-down w)
  (if (world-is-rally? w)
   (make-world
       (world-ball w)
        (racket-after-down(world-racket w))
        WHITE
        0
        (world-simulation-speed w)
                false
                true
        )
   w))

;; racket-after-down : Racket -> Racket
;; RETURNS: a racket with the racket's vy component increased by 1
;; STRATEGY: Use constructor template for Racket on r


(define (racket-after-down r)
  (make-racket (racket-x r) (racket-y r) (racket-vx r)(+ (racket-vy r) 1) (racket-selected? r) 0 0))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; world-after-left : World -> World
;; RETURNS: a world with the racket's vx component decreased by 1 iff the world is in rally state
;; STRATEGY: Use constructor template for World on w

(define (world-after-left w)
  (if (world-is-rally? w)
   (make-world
       (world-ball w)
        (racket-after-left(world-racket w))
        WHITE
        0
        (world-simulation-speed w)
                false
                true
        )
   w))

;; racket-after-left : Racket -> Racket
;; RETURNS: a racket with the racket's vx component decreased by 1
;; STRATEGY: Use constructor template for Racket on r

(define(racket-after-left r)
  (make-racket (racket-x r) (racket-y r) (- (racket-vx r) 1)(racket-vy r) (racket-selected? r) 0 0))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; world-after-right : World -> World
;; RETURNS: a world with the racket's vx component increased by 1 iff the world is in rally state
;; STRATEGY: Use constructor template for World on w

(define (world-after-right w)
  (if (world-is-rally? w)
   (make-world
       (world-ball w)
        (racket-after-right(world-racket w))
        WHITE
        0
        (world-simulation-speed w)
                false
                true
        )
   w))

;; racket-after-right : Racket -> Racket
;; RETURNS: a racket with the racket's vx component increased by 1
;; STRATEGY: Use constructor template for Racket on r


(define(racket-after-right r)
  (make-racket (racket-x r) (racket-y r) (+ (racket-vx r) 1)(racket-vy r) (racket-selected? r) 0 0))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; rally-toggled : World -> World
;; RETURNS: a world just like the given one, but with is-rally? toggled
;; STRATEGY: Use constructor template for World on w

(define (rally-toggled w)
  (if (world-ready-to-serve? w)
      (make-world
       (ball-after-serve (world-ball w))
        (world-racket w)
        WHITE
        (world-timer w)
        (world-simulation-speed w)
        false
        true)
      (world-paused w)))

;; ball-after-serve : Ball -> Ball
;; RETURNS: a ball with the ball's vx and vy components set to 3 and -9 respectively
;; STRATEGY: Use constructor template for Ball on b


(define (ball-after-serve b)
    (make-ball (ball-x b) (ball-y b) 3 -9))


;; ball-paused : Ball -> Ball
;; RETURNS: a stopped ball
;; STRATEGY: Use constructor template for Ball on b


(define (ball-paused b)
  (make-ball (ball-x b) (ball-y b) 0 0))

;; racket-paused : racket -> racket
;; RETURNS: a stopped racket
;; STRATEGY: Use constructor template for Racket on r

(define (racket-paused r)
  (make-racket (racket-x r) (racket-y r) 0 0 false 0 0))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; world-after-tick : World -> World
;; GIVEN: any world that's possible for the simulation
;; RETURNS: the world that should follow the given world
;;          after a tick
;; If the world is in rally, it is changed, 
;; If the world is paused, it changes
;; otherwise it stays the same
;; EXAMPLES:
;; (world-after-tick world-in-rally) = world-in-rally
;; (world-after-tick world-paused) = world-paused
;; STRATEGY: Cases on the state of the world

(define (world-after-tick w)
  (cond [(world-is-rally? w)
   (world-in-rally w)]
        [(and (not (world-is-rally? w)) (not (world-ready-to-serve? w)))
         (world-paused w)]
         
   [else w]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; world-in-rally: World -> World
;; GIVEN: a world in rally state
;; RETURNS: the world that should follow the given world
;;          after a tick
;; EXAMPLES:
;; (world-in-rally world-inbound) = world-inbound
;; (world-in-rally world-with-ball-outbound) = world-paused
;; STRATEGY: Cases on the position of ball and racket

(define(world-in-rally w)
  (if (or (ball-outbound? (world-ball w)) (racket-outbound? (world-racket w)))
      (world-paused w)
  (world-inbound w)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; world-inbound: World -> World
;; GIVEN: a world in rally state and is not outbound
;; RETURNS: the world that should follow the given world
;;          after a tick
;; EXAMPLES:
;; (world-inbound world-rally) = world-in-rally
;; STRATEGY: template of World on w

(define (world-inbound w)
  (make-world
       (ball-after-tick(world-ball w)(world-racket w))
        (racket-after-tick(world-ball w)(world-racket w))
        (world-wall-color w)
        (world-timer w)
        (world-simulation-speed w)
        false
        true))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; ball-outbound? Ball -> Boolean
;; GIVEN: a ball
;; RETURNS: true iff the ball hits the bottom wall

(define (ball-outbound? b)
   (>= (+(ball-y b)(ball-vy b)) 649))

;; racket-outbound? Racket -> Boolean
;; GIVEN: a racket
;; RETURNS: true iff the racket hits the front wall


(define (racket-outbound? r)
   (<= (+ (racket-y r) (racket-vy r)) 0))
     

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; world-paused: World -> World
;; GIVEN: a world w
;; RETURNS: a world that stays paused for 3 seconds
;;          and the world-wall changes to yellow
;;          and returns to ready-to-serve state after 3 seconds
;; EXAMPLES:
;; (world-paused w) = world-paused-3-seconds
;; STRATEGY: template of World on w


(define (world-paused w)
  (if (< (world-timer w) (* 3  (/ 1 (world-simulation-speed w))))
     (world-in-pause w)
     (world-after-pause w)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; world-after-pause: World -> World
;; GIVEN: a world in pause state
;; RETURNS: a world in ready-to-serve state
;; EXAMPLES:
;; (world-after-pause w) = (make-world
;;                         (make-ball 330 384 0 0)
;;                         (make-racket 330 384 0 0 false)
;;                          "white"
;;                          0
;;                          0.05
;;                          #true
;;                          #false)
;; STRATEGY: template of World on w

(define (world-after-pause w)
  (make-world (make-ball INITIAL-X-POS INITIAL-Y-POS 0 0)
                (make-racket INITIAL-X-POS INITIAL-Y-POS 0 0 false 0 0)
                WHITE
                0
  (world-simulation-speed w)
                true false))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; world-in-pause: World -> World
;; GIVEN: a world w
;; RETURNS: a world in pause state
;; EXAMPLES:
;; (world-in-pause w) = (make-world (make-ball 384 222 0 0)
;;                      (make-racket 330 384 0 0 false) "yellow"
;;                      120 0.05 #false #false)
;; STRATEGY: template of World on w

(define (world-in-pause w)
  (make-world
  (ball-paused(world-ball w))
  (racket-paused(world-racket w))
  YELLOW
  (+ (world-timer w) 1)
                (world-simulation-speed w)
  false
  false))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; ball-after-tick: Ball Racket -> Ball
;; GIVEN: a ball and racket
;; RETURNS: ball after the tick
;; EXAMPLES:
;; (ball-after-tick b r) = (ball-after-collision b r)
;; (ball-after-tick b r) = (right-wall b)
;; (ball-after-tick b r) = (left-wall b)
;; (ball-after-tick b r) = (front-wall b)
;; (ball-after-tick b r) = (no collision b)
;; STRATEGY: cases on the position of the ball
  
(define (ball-after-tick b r)
  (cond
    [(>= (+ (ball-x b)(ball-vx b)) 425)
     (right-wall b)]
    [(>= 0 (+ (ball-y b) (ball-vy b)))
     (front-wall b)]
    [(>= 0 (+ (ball-x b)(ball-vx b)))
     (left-wall b)]    
    [(check-collision? b r)
     (ball-after-collision b r)]     
   [else (no-collision b)]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; no-collision : Ball -> Ball
;; GIVEN: a ball
;; RETURNS: a ball which has not collided
;; EXAMPLES:
;; no-collision(make-ball 402 168 3 -9) = (make-ball 405 159 3 -9)
;; STRATEGY: template of ball on b

(define (no-collision b)
  (make-ball
   (+ (ball-x b) (ball-vx b)) (+ (ball-y b) (ball-vy b)) (ball-vx b) (ball-vy b)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; front-wall : Ball -> Ball
;; GIVEN: a ball
;; RETURNS: a ball after collision with the front wall
;; EXAMPLES:
;; front-wall(make-ball 402 0 3 -9) = (make-ball 405 9 3 9)
;; STRATEGY: template of ball on b

(define (front-wall b)
  (make-ball
      (+ (ball-x b) (ball-vx b)) (* -1 (+ (ball-y b) (ball-vy b)))  (ball-vx b) (* -1 (ball-vy b))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; ball-after-collision : Ball -> Ball
;; GIVEN: a ball
;; RETURNS: a ball after collision with the racket
;; EXAMPLES:
;; ball-after-collision(make-ball 402 300 3 9) = (make-ball 405 293 3 -6)
;; STRATEGY: template of ball on b and template of racket on r

(define (ball-after-collision b r)
  (make-ball
      (+ (ball-x b) (ball-vx b)) (+ (ball-y b) (ball-vy b)) (ball-vx b)
       (- (racket-vy r) (ball-vy b)) ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; right-wall : Ball -> Ball
;; GIVEN: a ball
;; RETURNS: a ball after collision with the right wall
;; EXAMPLES:
;; right-wall(make-ball 426 45 3 -9) = (make-ball 1 36 -3 -9)
;; STRATEGY: template of ball on b


(define (right-wall b)
  (make-ball
      (- 425 (- (+ (ball-x b) (ball-vx b)) 425)) (+ (ball-y b) (ball-vy b)) (* -1 (ball-vx b)) (ball-vy b)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; left-wall : Ball -> Ball
;; GIVEN: a ball
;; RETURNS: a ball after collision with the left wall
;; EXAMPLES:
;; left-wall(make-ball 0 45 3 -9) = (make-ball 3 36 -3 -9)
;; STRATEGY: template of ball on b

(define (left-wall b)
  (make-ball
      (* -1 (+ (ball-x b) (ball-vx b))) (+ (ball-y b) (ball-vy b)) (* -1 (ball-vx b)) (ball-vy b)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; check-collision? : Ball Racket -> Boolean
;; GIVEN: A ball and racket
;; RETURNS: true iff the ball collides with the racket
;; EXAMPLES:
;; check-collision? (make-ball 330 384 3 -9) (make-racket 330 384 0 0 true) = true
;; STRATEGY: Mathematical calculation

(define (check-collision? b r)
  (and (<= (- (racket-x r) HALF-LENGTH) (ball-x b) (+ (racket-x r) HALF-LENGTH))
       (<= (- (racket-x r) HALF-LENGTH) (+ (ball-x b) (ball-vx b)) (+ (racket-x r) HALF-LENGTH))
       (<= (ball-y b) (racket-y r))
       (> (+ (ball-y b) (ball-vy b)) (racket-y r))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; racket-after-tick: Racket -> Racket
;; GIVEN: A racket
;; RETURNS: A racket following the previous racket after the tick
;; EXAMPLES: (make-racket 330 384 1 0)= (make-racket 331 384 1 0 false)
;; STRATEGY: template of racket on r

(define (racket-after-tick b r)
  (if (racket-selected? r)
      (make-racket (racket-x r) (racket-y r) (racket-vx r) (racket-vy r) (racket-selected? r) (racket-px r) (racket-py r))
 (cond
   [(<= (+(racket-x r) (racket-vx r)) HALF-LENGTH)
     (make-racket
    HALF-LENGTH (+ (racket-y r) (racket-vy r)) 0 (racket-vy r) (racket-selected? r) 0 0)]
   [(<= (+(racket-y r) (racket-vy r)) 0)
     (make-racket
    (racket-x r) (racket-y r) 0 0 (racket-selected? r) 0 0)]
   [(>= (+(racket-x r) (racket-vx r)) 401.5)
  (make-racket
   401.5 (+ (racket-y r) (racket-vy r)) 0 (racket-vy r) (racket-selected? r) 0 0)]
   [(check-collision? b r)
    (if (< (racket-vy r) 0)
        (make-racket (+ (racket-x r) (racket-vx r)) (+ (racket-y r) (racket-vy r)) (racket-vx r) 0 (racket-selected? r) 0 0)
        (make-racket
   (+ (racket-x r) (racket-vx r)) (+ (racket-y r) (racket-vy r)) (racket-vx r) (racket-vy r) (racket-selected? r) 0 0))]
   [else (make-racket
   (+ (racket-x r) (racket-vx r)) (+ (racket-y r) (racket-vy r)) (racket-vx r) (racket-vy r) (racket-selected? r) 0 0)]
)
 ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; world-after-mouse-event : World Integer Integer MouseEvent -> World
;; GIVEN: a world, the x- and y-positions of the mouse, and a mouse
;; event. 
;; RETURNS: the world that should follow the given mouse event
;; EXAMPLES:  See slide on life cycle of dragged racket
;; STRATEGY: Cases on world-state

(define (world-after-mouse-event w mx my mev)
  (if (world-is-rally? w)
      (make-world (world-ball w)
                  (racket-after-mouse-event (world-racket w) mx my mev)
                  (world-wall-color w)
                  (world-timer w)
                  (world-simulation-speed w)
   (world-ready-to-serve? w)
   (world-is-rally? w)
   )
      w))

;(begin-for-test
 ; 
  ; (check-equal?
  ; (world-after-mouse-event (make-world (make-ball 330 384 0 0) (make-racket 330 384 0 0 false) WHITE 0 0.05 true false) 325 360 "button-down")
  ; (make-world (make-ball 330 384 0 0) (make-racket 330 384 0 0 false) WHITE 0 0.05 true false))
;
 ;  (check-equal?
 ;  (world-after-mouse-event (make-world (make-ball 330 384 0 0) (make-racket 330 384 0 0 false) WHITE 0 0.05 false true) 325 360 "button-down")
 ;  (make-world (make-ball 330 384 0 0) (make-racket 330 384 0 0 true) WHITE 0 0.05 false true))
;
;   (check-equal?
;   (world-after-mouse-event (make-world (make-ball 330 384 0 0) (make-racket 330 384 0 0 false) WHITE 0 0.05 false true) 400 400 "button-down")
;   (make-world (make-ball 330 384 0 0) (make-racket 330 384 0 0 false) WHITE 0 0.05 false true))
;
;   (check-equal?
;   (world-after-mouse-event (make-world (make-ball 330 384 0 0) (make-racket 330 384 0 0 false) WHITE 0 0.05 false true) 325 360 "drag")
;   (make-world (make-ball 330 384 0 0) (make-racket 330 384 0 0 false) WHITE 0 0.05 false true))
;
;   (check-equal?
;   (world-after-mouse-event (make-world (make-ball 330 384 0 0) (make-racket 330 384 0 0 false) WHITE 0 0.05 false true) 325 360 "button-up")
 ;  (make-world (make-ball 330 384 0 0) (make-racket 330 384 0 0 false) WHITE 0 0.05 false true))

  ; (check-equal?
  ; (world-after-mouse-event (make-world (make-ball 330 384 0 0) (make-racket 330 384 0 0 false) WHITE 0 0.05 false true) 325 360 "move")
  ; (make-world (make-ball 330 384 0 0) (make-racket 330 384 0 0 false) WHITE 0 0.05 false true))

   ;(check-equal?
   ;(world-after-mouse-event (make-world (make-ball 330 384 0 0) (make-racket 330 384 0 0 true) WHITE 0 0.05 false true) 325 360 "button-up")
   ;(make-world (make-ball 330 384 0 0) (make-racket 330 384 0 0 false) WHITE 0 0.05 false true))

   ;(check-equal?
   ;(world-after-mouse-event (make-world (make-ball 330 359 0 0) (make-racket 330 384 0 0 true) WHITE 0 0.05 false true) 325 360 "button-up")
   ;(make-world (make-ball 330 359 0 0) (make-racket 330 384 0 0 false) WHITE 0 0.05 false true))

   ;(check-equal?
   ;(world-after-mouse-event (make-world (make-ball 330 384 0 0) (make-racket 330 384 0 0 true) WHITE 0 0.05 false true) 325 360 "drag")
   ;(make-world (make-ball 330 384 0 0) (make-racket 325 360 0 0 true) WHITE 0 0.05 false true)))

;; racket-after-mouse-event : Racket Integer Integer MouseEvent -> Racket
;; GIVEN: a racket, the x- and y-positions of the mouse, and a mouse
;; event. 
;; RETURNS: the racket that should follow the given mouse event
;; EXAMPLES:  See slide on life cycle of dragged racket
;; STRATEGY: Cases on MouseEvent

(define (racket-after-mouse-event r mx my mev)
  (cond
    [(mouse=? mev "button-down") (racket-after-button-down r mx my)]
    [(mouse=? mev "drag") (racket-after-drag r mx my)]
    [(mouse=? mev "button-up")(racket-after-button-up r mx my)]
    [else r]))


;; racket-after-button-down : Racket Integer Integer -> Racket
;; GIVEN: a racket and the location of the button-down
;; RETURNS: the racket following a button-down at the given location.
;; if the button-down is inside the racket, returns a racket just like the
;; given one, except that it is selected.
;; STRATEGY: Cases on whether the mouse event is in the racket, then use
;; template for racket on w 

(define (racket-after-button-down r mx my)
  (if (in-racket? r mx my)
      (make-racket (racket-x r) (racket-y r) 
                  (racket-vx r) (racket-vy r) true mx my)
      r))

;; racket-after-drag : racket Integer Integer -> racket
;; GIVEN: a racket and the location of the drag event
;; RETURNS: the racket following a drag at the given location.
;; if the racket is selected, then return a racket just like the given
;; one, except that it is now centered on the mouse position.
;; STRATEGY: Cases on whether racket is selected.

(define (racket-after-drag r mx my)
  (if (racket-selected? r)
      (make-racket
       (+ (racket-x r) (- mx (racket-px r)))
       (+ (racket-y r) (- my (racket-py r)))
       (racket-vx r)
       (racket-vy r)
       true
       mx
       my)
      r))

;; racket-after-button-up : racket Integer Integer -> racket
;; RETURNS: the racket following a button-up at the given location.
;; if the racket is selected, return a racket just like the given one,
;; except that it is no longer selected.
;; STRATEGY: cases on whether racket is selected

(define (racket-after-button-up r mx my)
  (if (racket-selected? r)
      (make-racket (racket-x r) (racket-y r) 
                  (racket-vx r) (racket-vy r) false (racket-px r) (racket-py r))
      r))
  

;; in-racket? : Racket Integer Integer -> Racket
;; RETURNS: true iff the given coordinate is inside the bounding box of
;; the racket.
;; EXAMPLES: see tests below
;; strategy: use observer template on r

(define (in-racket? r x y)
  (and
    (<= 
      (- (racket-x r) 25)
      x
      (+ (racket-x r) 25))
    (<= 
      (- (racket-y r) 25)
      y
      (+ (racket-y r) 25))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; scene-with-ball : Ball Scene -> Scene
;; RETURNS: a scene like the given one, but with the given ball painted
;; on it.
(define (scene-with-ball b s)
  (place-image
    BALL
    (ball-x b) (ball-y b)
    s))


;; scene-with-racket : Racket Scene -> Scene
;; RETURNS: a scene like the given one, but with the given racket painted
;; on it.
(define (scene-with-racket r s)
  (place-image
    RACKET
    (racket-x r) (racket-y r)
    s))

;; scene-with-dot : Racket Scene -> Scene

(define (scene-with-dot r s)
  (place-image
    DOT
    (racket-px r) (racket-py r)
    s))

;; world-to-scene : World -> Scene
;; RETURNS: a Scene that portrays the given world.
;; EXAMPLE: (world-to-scene paused-world-at-20) should return a canvas with
;; two cats, one at (150,20) and one at (300,28)
;; STRATEGY: Place each cat in turn.

(define (world-to-scene w)
  (if (racket-is-selected? (world-racket w))
      (scene-with-dot
       (world-racket w)
      (scene-with-ball
    (world-ball w)
    (scene-with-racket
      (world-racket w)
      (empty-scene CANVAS-WIDTH CANVAS-HEIGHT (world-wall-color w)))))
  (scene-with-ball
    (world-ball w)
    (scene-with-racket
      (world-racket w)
      (empty-scene CANVAS-WIDTH CANVAS-HEIGHT (world-wall-color w))))))

;(begin-for-test
  
 ;  (check-equal?
   ;(world-to-scene (make-world (make-ball 330 384 3 -9) (make-racket 330 384 0 0 true) WHITE 0 0.05 true false))
  ; (place-image
   ; DOT
   ; 330 384
   ;(place-image
   ; BALL
   ; 330 384(place-image
   ; RACKET
   ; 330 384
   ; (empty-scene CANVAS-WIDTH CANVAS-HEIGHT WHITE))))))

;; racket-is-selected? : Racket -> Boolean

(define (racket-is-selected? r)
  (racket-selected? r))

