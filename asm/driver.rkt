#lang racket

(require 
 ;; Data structures
 "asm-base.rkt"
 ;; Helper functions
 "asm-support.rkt"
 ;; Passes
 "pass-file-to-los.rkt"
 "pass-parse.rkt"
 ;; For pretty printing.
 racket/pretty)

(define (driver file)
  (each-with result
             ;; First convert to a list of strings
             (file->list-of-strings file)
             ;; Then parse
             (parse result)
             ;; And return the result
             result))
