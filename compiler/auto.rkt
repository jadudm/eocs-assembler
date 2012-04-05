#lang racket

(require rackunit
         "../asm/asm-base.rkt"
         "../asm/asm-support.rkt"
         "base.rkt"
         "helpers.rkt"
         "../asm-interp/main.rkt"
         "driver.rkt")

;; CONTRACT
;; interp :: expression -> number
;; PURPOSE
;; Interprets the value of a plus
;; or minus expression
(define (interp exp)
  (match exp
    [`(+ ,exp1 ,exp2)
     (+ (interp exp1) (interp exp2))]
    [`(- ,exp1 ,exp2)
     (- (interp exp1) (interp exp2))]
    [(? number?) exp]
    ))



;;random expression generator

;; CONTRACT
;; number :: number
;; PURPOSE
;; Creates a random number from 0 to 49 for use in 
;; generating random expressions
(define (number max) 
  (random max (current-pseudo-random-generator))
)

(define op null)
  
;; CONTRACT
;; random-operand :: void
;; PURPOSE
;; Sets op to a random valid operator
(define (random-operator)
  (case (number 2)
    [(1)
     '+]
    [(0)
     '-]
))

;; CONTRACT
;; random-simple :: expr
;; PURPOSE
;; Generates a random simple expression
(define (random-simple)
  
  `(,(random-operator) ,(number 50) ,(number 50))
)

;; CONTRACT
;; program :: number -> expr
;; PURPOSE
;; Generates an n-deep expression  
(define (program n)
  (cond 
    [(zero? n) (number 50)]
    [else
     (define which (number 100))
     (cond
       [(< which 30) (number 50)]
       [(>= which 30)
        `(,(random-operator) 
          ,(program (sub1 n))
          ,(program (sub1 n))
               )])
     ]))

(define-check (check-files f1 f2)
  (check-equal?
   (file->list f1)
   (file->list f2)))


;;(define current-program (program 1))
;;(print current-program)
;;(print current-program)

;  ;;;;;;; ;;;;;   ;;;; ;;;;;;;  ;;;; 
;     ;    ;      ;;  ;    ;    ;;  ; 
;     ;    ;      ;        ;    ;     
;     ;    ;      ;;       ;    ;;    
;     ;    ;;;;;   ;;      ;     ;;   
;     ;    ;        ;;     ;      ;;  
;     ;    ;          ;    ;        ; 
;     ;    ;          ;    ;        ; 
;     ;    ;         ;;    ;       ;; 
;     ;    ;;;;;  ;;;;     ;    ;;;;  
(define (run-tests)
(test-suite
 "random tests for 420"
 (test-case
  "test for depth 1"
  (define current-program (program 1))
  (driver current-program) ;;gives me assembly in foo.hack
  ;;run returns the value at RAM 0 = interpreted expression
  ;;tie together driver and emulator
  (check-equal? (run "foo.hack") (interp current-program)))))


