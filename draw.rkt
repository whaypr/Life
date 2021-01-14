#lang racket

(require 2htdp/universe
         2htdp/image
         "config.rkt"
         "gol.rkt"
         "lexicon.rkt")

;  ----------  +-----------+  ----------  ;
;  ----------  |  D R A W  |  ----------  ;
;  ----------  +-----------+  ----------  ;

; create visualization of the current game state
(define (draw state)
  (define BOX (square BRD-SCALE "solid" BOX-COLOR))
  (for*/fold ([img (empty-scene
                    (* BRD-SCALE BRD-WIDTH)
                    (* BRD-SCALE BRD-HEIGHT)
                    BRD-BCG)])
             ([i state])
             (place-image BOX
                          (+ (/ BRD-SCALE 2) 0.5 (* (car i) BRD-SCALE))
                          (+ (/ BRD-SCALE 2) 0.5 (* (cadr i) BRD-SCALE))
                          img)))

; main draw function operating the whole process
(big-bang (append s-glider-gun (s-shift s-eater 50 36))
  [on-tick next-gen TICK-DURATION]
  [on-draw draw])
