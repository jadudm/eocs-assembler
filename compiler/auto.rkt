#lang racket

(require rackunit
         "../asm/asm-base.rkt"
         "../asm/asm-support.rkt"
         "base.rkt"
         "helpers.rkt")

;;write a small interpreter 
(define (interp exp)
  (match exp
    [`(+ ,exp1 ,exp2)
     (+ (interp exp1) (interp exp2))]
    [`(- ,exp1 ,exp2)
     (- (interp exp1) (interp exp2))]
    [(? number?)
     exp]
    ))



;;random expression generator
