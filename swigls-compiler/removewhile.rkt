#lang racket

(require "base.rkt")

(define (removewhile statement)
  (cond
    [(while0? statement) (seq 
                          (label (gensym 'TOP))
                                 (if0 (gensym 'FLAG)
                                      (seq (removewhile while0-body)
                                           (goto 'TOP))
                                      (goto 'END))
                          (label (gensym 'END)))
                         (removewhile statement)
                         ]
    [(if0? statement) statement (removewhile statement)]
    [(binop? statement) statement (removewhile statement)]
    [(seq? statement) statement (removewhile statement)]
    [(set? statement) statement (removewhile statement)]
    [(num? statement) statement (removewhile statement)]
  ))