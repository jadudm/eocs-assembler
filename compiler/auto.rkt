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

(define (make-case depth runs)
     (test-case
      (format "test for depth ~a" depth)
    (let loop ([n runs])
      (define current-program (program depth))
      (let ([op (open-output-file 
                 (format "inputTests/test~a.420" depth)
                 #:exists 'replace
                 )])
        (write current-program op)
        (newline op)
        (close-output-port op)
        )
      
      (driver (format "inputTests/test~a.420" depth))
      ;;current-program is in hack
      ;; driver takes a .420 and returns a .hack
      ;; emulate takes hack and returns the value at ram 0
      ;; interp takes hack and interprets the value -> should match with emulate
      (check-equal? (emulate (format "inputTests/test~a.hack" depth))
                    (interp current-program))
      (unless (zero? n)
        (loop (sub1 n)))
      )))

(define all-tests
  (test-suite
   "random tests for 420"
   (let loop ([n 15])
     (unless (zero? n)
       (make-case n 10)
       (loop (sub1 n))))))


(define GUI true)
(define NOISY 'quiet)
(require rackunit/text-ui rackunit/gui)

(if GUI
    (test/gui all-tests)
    (printf "Failed ~a tests."
            (run-tests all-tests 
                       (if NOISY 'normal 'quiet))))

