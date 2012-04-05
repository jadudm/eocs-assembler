#lang racket

(require "base.rkt"
         "helpers.rkt"
         "pass1.rkt"
         "pass2.rkt"
         "pass3.rkt"
         "../asm-interp/main.rkt"
         )

(define (driver file)
  (let ([sexp (read (open-input-file file))])
    (let ([str (pass-to-asm (pass2 (pass1 sexp)))])
      (display str)
    
    )))

    
