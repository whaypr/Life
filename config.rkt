#lang racket

(provide (all-defined-out))

;  ----------  +-----------+  ----------  ;
;  ----------  |  C O N F  |  ----------  ;
;  ----------  +-----------+  ----------  ;

; size
(define BRD-WIDTH 80)
(define BRD-HEIGHT 80)
(define BRD-SCALE 10)

;colors
(define BRD-BCG "black")
(define BOX-COLOR "orange")

(define TICK-DURATION 0.05) ; smaller number = higher speed
