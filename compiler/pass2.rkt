;; Pass 2

#lang racket
(require "base.rkt"
         "../asm/asm-support.rkt")
(provide pass2)

;; PURPOSE
;; Take in the structures from the previous pass
;; and produce a list of structures (broken down into the simple forms)
;; CONTRACT
;; pass2 : struct -> list of structs

#|
(+ 3 5) -> (simple + (num 3) (num 5)) -> (prog
                                            (id a 3)
                                            (id b 5)
                                            (id c (+ a b)))

(+ 3 (+ 2 3)) -> (binop + 3 (simple + (num 2) (num 3))
                          |
                          -> (prog
                                (id a 2)        (*)
                                (id b 3)        (**)
                                (id c (+ a b))  (***)
                                (id d 3)
                                (id e (+ c d)))
|#

  
(define (last ls)
  (first (reverse ls)))

(define (pass2 structure)
  (cond
    [(binop? structure) (let ([lhs (pass2 (binop-lhs structure))]
                              [rhs (pass2 (binop-rhs structure))])
                          (append
                           lhs
                           rhs
                           (list
                            (id (sym 'bin) (binop (binop-op structure)
                                                     (id-sym (last lhs))
                                                     (id-sym (last rhs))
                                                     )))))]
                                                     
                                                     
    [(num? structure) (list (id (sym 'num) (num-value structure)))]
    ))