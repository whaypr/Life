#lang racket

(require test-engine/racket-tests
         "gol.rkt"
         "lexicon.rkt")

;  ----------  +-----------+  ----------  ;
;  ----------  |   TESTS   |  ----------  ;
;  ----------  +-----------+  ----------  ;

(check-expect (next-gen '()) '())
(check-expect (next-gen s-block 10) s-block)
(check-expect (list->set (next-gen s-blinker 2))
              (list->set s-blinker))
(check-expect (list->set (next-gen s-glider 15))
              (list->set '((5 5) (6 4) (6 5) (4 4) (5 6))))

(test)
