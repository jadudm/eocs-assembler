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

       
    [(if0? statement) (if0
                       (let ([true-label  (gensym 'TRUE-LABEL)]
                             [false-label (gensym 'FALSE-LABEL)]
                             [endif-label (gensym 'ENDIF-LABEL)]
                             [FLAG        (gensym 'FLAG)]
                             )
                         (seq
                          (list
                           (label true-label)
                           (set FLAG (removeif (if0-test statement)))
                           (goto true-label)
                           (seq
                            (list
                             (removeif (if0-truecase statement))
                             (goto endif-label)
                             )
                            )
                           )
                          (label endif-label)
                          )
                         )
                       )]
   
    [(seq? statement) (seq (map removeif (seq-expressions statement)))]
    [(set? statement) (set (set-ident statement) (removeif (set-e statement)))]
    [(num? statement) statement]
    [(variable? statement) statement]
    ))