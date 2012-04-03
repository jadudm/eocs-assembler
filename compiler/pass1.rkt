;; Trent Dale - thehumancompiler
;; Pass 1

#lang racket

(printf "thehumancompiler is working. Please wait...")

(require "base.rkt")
(provide pass-to-struct
         
         )

;; PURPOSE
;; Take in an expression and produce num and binop structs
;; CONTRACT
;; pass-to-struct : exp -> struct
(define (pass-to-struct e)
  (cond
    [(number? e) (num e)]
    [(symbol? (first e)) (binop (first e) 
                                (pass-to-struct (second e)) 
                                (pass-to-struct (third e)))]
    )
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; PURPOSE
;; Take in the structures of pass-to-struct and produce structs with simple structs
;; CONTRACT
;; pass-add-simple : struct -> struct with simples
(define (pass-add-simple e)
  (cond
    [(num? e) e]
    [(binop? e) (simple (id-sym e) 
                        (pass-add-simple (binop-lhs e)) 
                        (pass-add-simple (binop-rhs e)))
                 ]
    ))