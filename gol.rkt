#lang racket

(provide next-gen)

(require "config.rkt")

; is item a member of the list?
(define (member? item lst)
  (cond
    [(null? lst) #f]
    [(equal? item (car lst)) #t]
    [#t (member? item (cdr lst))]))

; number of occurences of the item in the list
(define (occur item list)
  (cond
    [(null? list) 0]
    [(equal? item (car list)) (+ 1 (occur item (cdr list)))] ; if in, add 1 and move to another list member
    [#t (occur item (cdr list))])) ; if not, just move

;  ----------  +-----------+  ----------  ;
;  ----------  |  G  O  L  |  ----------  ;
;  ----------  +-----------+  ----------  ;

; state represents list of living cells
; cell is a list of x and y coords

(define surr-matrix '(
   (-1 -1) (0 -1) (1 -1)
   (-1  0)        (1  0)
   (-1  1) (0  1) (1  1)
))

; cell surroundings
(define (surr cell)
  (map
   (lambda (x) (list (modulo (+ (car cell) (car x)) BRD-WIDTH) (modulo (+ (cadr cell) (cadr x)) BRD-HEIGHT))) ; modulo makes the boundary periodic
   surr-matrix))

; cell neighbors (living cells around)
(define (nbors cell state)
  (define (nbors-inner nbors state)
    (cond
      [(or (null? nbors) (null? state)) null]
      [(member? (car nbors) state) (cons (car nbors) (nbors-inner (cdr nbors) state))]
      [#t (nbors-inner (cdr nbors) state)]))
  (nbors-inner (surr cell) state))

; all neighbors of all living cells (duplicates are desirable)
(define (nbors-all orig-state)
  (define (nbors-all-inner state)
    (if (null? state)
        null
        (append
         (filter (lambda (x) (not (member? x orig-state))) (surr (car state))) ; take surroundings of cell on head and add all dead cells from it
         (nbors-all-inner (cdr state)))))
  (nbors-all-inner orig-state))

; -----------------------------------------

; return a list of currently alive cells which will also remain alive in the next generation
(define (survivors orig-state)
  (define (survivors-inner state)
    (cond
      [(null? state) null]
      [(let ((around (length (nbors (car state) orig-state)))) (or (= around 2) (= around 3)))
       (cons (car state) (survivors-inner (cdr state)))]
      [#t (survivors-inner (cdr state))]))
  (survivors-inner orig-state))

; return a list of currently dead cells which will become alive in the next generation
(define (newborns state)
  (define (newborns-inner cells)
    (if (null? cells)
        null
        (filter (lambda (c) (= (occur c cells) 3)) cells)))
  (remove-duplicates (newborns-inner (nbors-all state)))) ; each new cell will occur only once

; -----------------------------------------

; return a list of living cells in the n-th generation
(define (next-gen state [steps 1])
  (if (= steps 0)
      state
      (next-gen (append (survivors state) (newborns state)) (- steps 1))))
