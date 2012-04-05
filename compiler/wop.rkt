#lang racket
(require racket/cmdline)
(require "../asm-interp/main.rkt"
         )

;; TO COMPILE THIS
;; raco exe wop.rkt

(define (main)
   (command-line
    #:program "wop"
    
    #:args (filename) 
    (display (emulate filename))
    (newline)
    ))

(main)