#lang racket

(require "base.rkt")
(provide removeif)
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
    
    
    [(if0? statement)  (let ([false-label (gensym 'FALSE-LABEL)]
                             [endif-label (gensym 'ENDIF-LABEL)]
                             [test        (gensym 'TEST)]
                             )
                         (seq
                          (list
                           (set test (removeif (if0-test statement)))
                           (jump 'JNE (variable test) (variable false-label))
                           ;;(goto false-label)
                           (seq
                            (list
                             (removeif (if0-truecase statement))
                             (goto endif-label)
                             )
                            )
                           (label false-label)
                           (seq
                            (list
                             (removeif (if0-falsecase statement))
                             (goto endif-label)
                             )
                            )
                           (label (variable endif-label)))
                          )
                        )]
    
    [(seq? statement) (seq (map removeif (seq-expressions statement)))]
    [(set? statement) (set (set-ident statement) (removeif (set-e statement)))]
    [(num? statement) statement]
    [(variable? statement) statement]
    ))