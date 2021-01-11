#lang racket

(require 2htdp/universe
         2htdp/image
         "gol.rkt"
         "demos.rkt")

;  ----------  +-----------+  ----------  ;
;  ----------  |  D R A W  |  ----------  ;
;  ----------  +-----------+  ----------  ;

; for inspiration for draw function thanks to:
; https://github.com/jeapostrophe/exp/blob/master/life.rkt

; draw function creating visualization of the current game state
(define (draw state)
  (define SCALE 10)
  (define BOX (square SCALE "solid" "black"))
  (for*/fold ([img (empty-scene
                    (* SCALE 50)
                    (* SCALE 50))])
             ([i state])
             (place-image BOX
                          (+ (/ SCALE 2) 0.5 (* (car i) SCALE))
                          (+ (/ SCALE 2) 0.5 (* (cadr i) SCALE))
                          img)))

; shift object from the top left corner to have more space
(define shifted (map (lambda (x) (list (+ 10 (car x)) (+ 10 (cadr x)))) d-glider-gun))

; main draw function operating whole process
(big-bang shifted
  [on-tick next-gen 0.1]
  [on-draw draw])
