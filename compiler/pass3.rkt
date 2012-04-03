;; Pass 3 of the compiler
;; Braden Licastro - anyone else welcome to join in!

;; Takes in nonrecursive code and outputs assembly.

#lang racket

(require "base.rkt")

; CONTRACT
;; input LOIDs -> String
(define (pass-to-asm input)
  (cond
    [(empty? input) "end/0"]
    [(num? (id-value input))
     (string-append (asm-num (first input)) (pass-to-asm (rest input)))
     ]
    [(simple? (id-value input))
     ]
    ))

; CONTRACT
;; input ID -> String
(define (asm-num input)
  (string-append "@" (id-value input) "\n"
                 "D=A\n"
                 "@" (id-sym input) "\n"
                 "M=D\n"))