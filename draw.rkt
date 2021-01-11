#lang racket

(require 2htdp/universe
         2htdp/image
         "config.rkt"
         "gol.rkt"
         "demos.rkt")

;  ----------  +-----------+  ----------  ;
;  ----------  |  D R A W  |  ----------  ;
;  ----------  +-----------+  ----------  ;

; for inspiration for draw function thanks to:
; https://github.com/jeapostrophe/exp/blob/master/life.rkt

; draw function creating visualization of the current game state
(define (draw state)
  (define BOX (square BRD-SCALE "solid" BOX-COLOR))
  (for*/fold ([img (empty-scene
                    (* BRD-SCALE BRD-WIDTH)
                    (* BRD-SCALE BRD-HEIGHT))])
             ([i state])
             (place-image BOX
                          (+ (/ BRD-SCALE 2) 0.5 (* (car i) BRD-SCALE))
                          (+ (/ BRD-SCALE 2) 0.5 (* (cadr i) BRD-SCALE))
                          img)))

; shift object from the top left corner to have more space
(define shifted
  (map
   (lambda (x) (list (+ 10 (car x)) (+ 10 (cadr x))))
   d-glider-gun))

; main draw function operating whole process
(big-bang shifted
  [on-tick next-gen TICK-DURATION]
  [on-draw draw])
