#lang racket

(require "base.rkt")

(define (removewhile statement)
  (cond
    [(while0? statement) '...]
    [(if0? statement) statement (removewhile)]
    [(binop? statement) statement (removewhile)]
    [(seq? statement) statement (removewhile)]
    [(set? statement) statement (removewhile)]
    [(num? statement) statement (removewhile)]
    [(id? statement) statement (removewhile)]
  ))