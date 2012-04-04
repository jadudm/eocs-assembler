;; Pass 3 of the compiler
;; Braden Licastro - anyone else welcome to join in!

;; Takes in nonrecursive code and outputs assembly.

#lang racket

(require "base.rkt")

; CONTRACT
;; input LOIDs -> String
(define (pass-to-asm input)
  (cond
    [(empty? input) (prog-end)]
    [(num? (id-value input))
     (string-append (asm-num (first input)) (pass-to-asm (rest input)))
     ]
    [(simple? (id-value input))
     (string-append (asm-simple (first input)) (pass-to-asm (rest input)))
     ])
  )

; CONTRACT
;; input Num ID -> String
(define (asm-num input)
  (string-append "@" (id-value input) "\n"
                 "D=A\n"
                 "@" (id-sym input) "\n"
                 "M=D\n"))

; CONTRACT
;; input Sim ID -> String
(define (asm-sim input)
  (string-append "@" (simple-lhs (id-value input)) "\n"
                 (cond
                   [(num? (simple-lhs (id-value input)))
                   "D=A\n"]
                   [else
                    "D=M\n"])
                  "@" (simple-rhs (id-value input)) "\n"
                  (cond
                   [(num? (simple-rhs (id-value input)))
                   ""]
                   [else
                    "A=M\n"])
                  (cond 
                    [(equals '+ (simple-op (id-value input))) "D=D+A\n"]
                    [(equals '- (simple-op (id-value input))) "D=D-A\n"])
                  "@" (id-sym input) "\nM=D\n"
                  ))
                 
; CONTRACT
;; input Nothing -> String
(define (prog-end)
   "(END)\n@END\n0,JMP"
  )