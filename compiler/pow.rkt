#lang racket
(require racket/cmdline)
(require "driver.rkt")
;; TO COMPILE THIS
;; raco exe pow.rkt
(define (main)
   (command-line
    #:program "pow"
    
    #:args (filename) 
    (driver filename)))

(main)
(newline)