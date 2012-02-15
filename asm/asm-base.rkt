#lang racket

(provide (all-defined-out))

;; Structures
(struct A (line value) 
  #:inspector (make-inspector))

(struct C (line dest comp jump)
  #:inspector (make-inspector))

(struct label (line name) 
  #:inspector (make-inspector))

(struct comment (text) 
  #:inspector (make-inspector))

;; Regular expressions
(define DCJ-REGEXP #rx"")
(define CJ-REGEXP #rx"")
(define DC-REGEXP #rx"")
(define C-REGEXP #rx"")
(define ANUM-REGEXP #rx"")
(define ASYM-REGEXP #rx"")
(define LABEL-REGEXP #rx"")

;; Macros
(define-syntax (each-with stx)
  (syntax-case stx ()
    [(each-with var body* ...)
     #`(let ([var (void)])
         (set! var body*) ...)]))