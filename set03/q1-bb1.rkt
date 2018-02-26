--------------------
q1 > Test #9

name:        check-equal?
location:    q1-bb.rkt:117:4
expression:  (check-equal? (ball-x (world-ball (world-after-n-ticks WORLD-RALLY-STATE 32))) 424 "ball in x axis should be at 424 after 32 ticks")
params:      '(426 424)
message:     "ball in x axis should be at 424 after 32 ticks"
actual:      426
expected:    424
--------------------
--------------------
q1 > Test #10

name:        check-equal?
location:    q1-bb.rkt:124:4
expression:  (check-equal? (ball-vx (world-ball (world-after-n-ticks WORLD-RALLY-STATE 32))) -3 "ball's velocity in vx should be -3 after 32 ticks")
params:      '(3 -3)
message:     "ball's velocity in vx should be -3 after 32 ticks"
actual:      3
expected:    -3
--------------------
--------------------
q1 > Test #12

name:        check-equal?
location:    q1-bb.rkt:138:4
expression:  (check-equal? (ball-y (world-ball (world-after-n-ticks WORLD-RALLY-STATE 43))) 3 "ball's position in y should be 3 after 43 ticks")
params:      '(-3 3)
message:     "ball's position in y should be 3 after 43 ticks"
actual:      -3
expected:    3
--------------------
--------------------
q1 > Test #14

name:        check-equal?
location:    q1-bb.rkt:152:4
expression:  (check-equal? (ball-vy (world-ball (world-after-n-ticks WORLD-RALLY-STATE 43))) 9 "ball's velocity in vy should be 9 after 43 ticks")
params:      '(-9 9)
message:     "ball's velocity in vy should be 9 after 43 ticks"
actual:      -9
expected:    9
--------------------
--------------------
q1 > Test #17

name:        check-equal?
location:    q1-bb.rkt:173:4
expression:  (check-equal? (racket-vy (world-racket (world-after-n-ticks WORLD-RACKET-WITH-6SPEED-63TICK 1))) 0 "racket's velocity vy should be 0 after 64 ticks as collision takes place")
params:      '(-6 0)
message:     "racket's velocity vy should be 0 after 64 ticks as collision takes place"
actual:      -6
expected:    0
--------------------
16 success(es) 5 failure(s) 0 error(s) 21 test(s) run
extras.rkt Wed Sep 14 08:52:19 2016
q1.rkt appears to be in a correctly named folder. Running tests...
Running tests from q1.rkt...
All tests passed (40 tests).
5
