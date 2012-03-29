;; Trent Dale - thehumancompiler
;; Pass 1

#lang racket

(printf "thehumancompiler is working. Please wait...")

(require "base.rkt")

;; PURPOSE
;; Take in an expression and produce num and binop structs
;; CONTRACT
;; pass1.1 : exp -> struct
(define (pass-to-struct e)
  (cond
    [(empty? (first e)) '()]
    [(number? (first e)) (num (first e)) (pass-to-struct (rest e))]
    [(symbol? (first e)) (binop (first e) (pass-to-struct (rest e)) (pass-to-struct (rest e)))]
    )
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; PURPOSE
;; Take in the structures of pass 1.1 and produce structs with simple structs
;; CONTRACT
;; pass1.2 : struct -> struct with simples
(define (pass-add-simple e)
  (cond
    [(empty? (first e)) '()]
    [