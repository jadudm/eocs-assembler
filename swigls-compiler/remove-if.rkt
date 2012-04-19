#lang racket

(require "base.rkt")

(define (removeif statement)
  (cond
    [(while0? statement)]
    [(binop? statement)
     (binop (binop-op statement) 
            (removewhile (binop-lhs statement))
            (removewhile (binop-rhs statement)))]

       
    [(if0? statement) (if0 (removewhile if0-test) 
                          (removewhile if0-truecase) 
                          (removewhile if0-falsecase))]
   
    [(seq? statement) (seq (map removewhile (seq-expressions statement)))]
    [(set? statement) (set (set-ident statement) (removewhile (set-e statement)))]
    [(num? statement) statement]
    [(variable? statement) statement]
    ))