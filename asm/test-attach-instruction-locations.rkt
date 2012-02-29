#lang racket

;; INCOMPLETE
;; This is not yet complete.
;; Testing this will be slightly more difficult
;; than it appears at first glance. May require
;; restructuring and/or rethinking.

(require rackunit 
         "asm-support.rkt"
         "asm-base.rkt")


;; If you want your tests to fail in a 
;; noisy way, set this to true. There are 
;; several thousand tests, so I would only
;; use this to check where/what you fail on.
;;
;; Note that in NOISY mode, the test suite will
;; stop on the first test that fails and it will
;; not continue.
(define NOISY false)

;; Decide if you want textual or GUI-based results.
;; The text results only tell you how many tests you
;; failed. The GUI lets you browse all of the results.
(define GUI false)

(define labels '())
(define (random-instruction addr)
  (let ([die (random 100)])
  (cond 
    [(< die 20)
     (let ([new-label (sym 'label)])
       (set! labels (cons new-label labels))
       (label addr new-label))]
    [(< die 60)
     (C addr (sym 'D) (sym 'C) (sym 'J))]
    [(< die 80)
     (A addr (random 42))]
    [(and (> (length labels) 0) (< die 100))
     (A addr (list-ref labels (random (length labels))))]
    [else
     (random-instruction addr)]
    )))
       
(define (make-loi n max)
  (cond
    [(= n max) '()]
    [else
     (let ([i (random-instruction n)])
       (if (not (label? i))
           (cons i (make-loi (add1 n) max))
           (cons i (make-loi n max))
           ))]))

(define (make-list-of-instructions max)
  (set! labels '())
  (make-loi 0 max))



(define suite-test-addressing
  (test-suite
   "Testing the attaching of addresses to instructions."

   ))
    



(require rackunit/text-ui rackunit/gui)

(if GUI
    (test/gui suite-test-addressing)
    (printf "Failed ~a tests."
            (run-tests suite-test-addressing 
                       (if NOISY 'normal 'quiet))))

