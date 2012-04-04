;; Trent Dale - thehumancompiler
;; Pass 1

#lang racket

(printf "thehumancompiler is working. Please wait...")

(require "base.rkt")
(provide pass1)

;; PURPOSE
;; Take in an expression and produce num and binop structs
;; CONTRACT
;; pass-to-struct : exp -> struct
(define (pass1 e)
  (cond
    [(number? e) (num e)]
    [(symbol? (first e)) (binop (first e) 
                                (pass1 (second e)) 
                                (pass1 (third e)))]
    )
  )