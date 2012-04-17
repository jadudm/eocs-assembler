#lang racket

(require "base.rkt")

(define (removewhile statement)
  (cond
    [(while0? statement) (seq 
                          (label (gensym 'TOP)
                                 (if0 (gensym 'FLAG)
                                      (seq (removewhile while0-body)
                                           (goto TOP))
                                      (goto (label END))))
                          (label (gensym 'END)))]
    [(if0? statement) statement (removewhile)]
    [(binop? statement) statement (removewhile)]
    [(seq? statement) statement (removewhile)]
    [(set? statement) statement (removewhile)]
    [(num? statement) statement (removewhile)]
    [(id? statement) statement (removewhile)]
  ))