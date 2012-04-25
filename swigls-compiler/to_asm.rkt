;; Braden Licastro
;; Takes in code and outputs assembly.

#lang racket

(require "base.rkt")

(provide pass-to-asm)

; CONTRACT
;; input LOIDs -> String
(define (pass-to-asm input)
  (cond
    [(empty? input) (prog-end)]
    [(number? (id-value (first input)))
     (string-append (asm-num (first input)) (pass-to-asm (rest input)))
     ]
    [(binop? (id-value (first input)))
     (string-append (asm-binop (first input)) (pass-to-asm (rest input)))
     ]
    [(label? (first input))
     (string-append (asm-label(first input)) (pass-to-asm (rest input)))
     ]
    [(goto? (first input))
     (string-append (asm-goto (first input)) (pass-to-asm (rest input)))
     ]
    [(jump? (first input))
     (string-append (asm-jump (first input)) (pass-to-asm (rest input)))
     ]
    ))

; CONTRACT
;; input Num ID -> String
(define (asm-num input)
  (string-append "@" (stringify (id-value input)) "\n"
                 "D=A\n"
                 "@" (stringify (id-sym input)) "\n"
                 "M=D\n"))

; CONTRACT
;; input Sim ID -> String
(define (asm-binop input)
  (string-append "@" (stringify (binop-lhs (id-value input))) "\n"
                 "D=M\n"
                 "@" (stringify (binop-rhs (id-value input))) "\n"
                 "A=M\n"
                 (cond 
                   [(equal? '+ (binop-op (id-value input))) "D=D+A\n"]
                   [(equal? '- (binop-op (id-value input))) "D=D-A\n"])
                 "@" (stringify (id-sym input)) "\nM=D\n"
                 ))

; CONTRACT
;; input Label -> String
(define (asm-label input)
  (string-append "(" (stringify (label-sym input)) ")")
  )

; CONTRACT
;; input GoTo -> String
(define (asm-goto input)
  (string-append "@" (stringify (goto-sym input)) "\n"
                 "0;JMP\n")
  )

; CONTRACT
;; input Jump -> String
(define (asm-jump input)
  (cond
    [(variable? (jump-FLAG input))
     (string-append "@" (stringify (variable-value (jump-FLAG input))) "\n"
                    "0;JMP\n")]
    [(num? (jump-FLAG input))
     (string-append "@" (stringify (num-value (jump-FLAG input))) "\n"
                    "A;" (stringify (jump-jumpsym input)) "\n")]
    )

; CONTRACT
;; input NumberorSymbol -> String
(define (stringify input)
  (cond
    [(number? input)(number->string input)]
    [else
     (symbol->string input)]))

; CONTRACT
;; input Nothing -> String
(define (prog-end)
  "@0\nM=D\n"
  )