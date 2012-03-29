;; Pass 3 of the compiler
;; Braden Licastro - anyone else welcome to join in!

;; Takes in nonrecursive code and outputs assembly.

#lang racket

(require "base.rkt")

(define (pass-to-asm input string)
  (cond
    [(empty? input) null]
    [(num? (id-value input))
     ]
    [(simple? (id-value input))
     ]