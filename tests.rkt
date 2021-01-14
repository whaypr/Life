#lang racket

(require test-engine/racket-tests
         "gol.rkt"
         "lexicon.rkt")

;  ----------  +-----------+  ----------  ;
;  ----------  |   TESTS   |  ----------  ;
;  ----------  +-----------+  ----------  ;

(check-expect (next-gen '()) '())
(check-expect (next-gen d-block 10) d-block)
(check-expect (list->set (next-gen d-blinker 2))
              (list->set d-blinker))
(check-expect (list->set (next-gen d-glider 15))
              (list->set '((5 5) (6 4) (6 5) (4 4) (5 6))))

(test)
