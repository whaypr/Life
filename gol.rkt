#lang racket

(provide next-gen)

(require "config.rkt")

; is item a member of the list?
(define (member? item lst)
  (cond
    [(null? lst) #f]
    [(equal? item (car lst)) #t]
    [#t (member? item (cdr lst))]))

; a compare function for sorting coords
(define (list< lstA lstB)
  (cond
    [(equal? lstA lstB) #t]
    [(< (car lstA) (car lstB)) #t]
    [(> (car lstA) (car lstB)) #f]
    [#t (list< (cdr lstA) (cdr lstB))]))

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
  (define (newborns-inner lst item occ)
    (cond
      [(null? (cdr lst))
       (if (= occ 3)
           (cons item null)
           null)]
      [(equal? item (cadr lst))
       (if (>= occ 3)
           (newborns-inner (cdr lst) (cadr lst) 4)
           (newborns-inner (cdr lst) item (+ occ 1)))]
      [#t
       (if (= occ 3)
           (cons item (newborns-inner (cdr lst) (cadr lst) 1))
           (newborns-inner (cdr lst) (cadr lst) 1))]))
  (let ((lst (sort (nbors-all state) list<)))
    (if (null? lst)
        null
        (newborns-inner lst (car lst) 1))))

; -----------------------------------------

; return a list of living cells in the n-th generation
(define (next-gen state [steps 1])
  (if (= steps 0)
      state
      (next-gen (append (survivors state) (newborns state)) (- steps 1))))
