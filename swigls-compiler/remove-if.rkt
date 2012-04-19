#lang racket

(require "base.rkt")

(define (removeif statement)
  (cond
    [(while0? statement) (while0
                          (removeif (while0-test statement))
                          (removeif (while0-body statement))
                          )]
    [(binop? statement)
     (binop (binop-op statement) 
            (removeif (binop-lhs statement))
            (removeif (binop-rhs statement)))]

       
    [(if0? statement) (if0 (removeif if0-test) 
                          (removeif if0-truecase) 
                          (removeif if0-falsecase))]
   
    [(seq? statement) (seq (map removeif (seq-expressions statement)))]
    [(set? statement) (set (set-ident statement) (removeif (set-e statement)))]
    [(num? statement) statement]
    [(variable? statement) statement]
    ))