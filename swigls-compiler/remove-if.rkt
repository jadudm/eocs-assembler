#lang racket

(require "base.rkt")

(provide removeif)

(define (removeif statement)
  (cond
    [(binop? statement)
     (binop (binop-op statement) 
            (removeif (binop-lhs statement))
            (removeif (binop-rhs statement)))]
    
    
    [(if0? statement)  (let ([false-label (gensym 'FALSE-LABEL)]
                             [endif-label (gensym 'ENDIF-LABEL)]
                             [test        (gensym 'TEST)]
                             )
                         (seq
                          (list
                           (set test (removeif (if0-test statement)))
                           (jump 'JNE (variable test) (variable false-label))
                           ;;(goto false-label)
                           (removeif (if0-truecase statement))
                           (goto endif-label)
                           (label false-label)
                           (removeif (if0-falsecase statement))
                           (goto endif-label)
                           (label endif-label))
                          )
                         )]
    
    [(seq? statement) (seq (map removeif (seq-expressions statement)))]
    [(set? statement) (set (set-ident statement) (removeif (set-e statement)))]
    [(num? statement) statement]
    [(variable? statement) statement]
    [(label? statement) statement]
    [(goto? statement) statement]
    [else (error (format "~a" statement))]
    ))