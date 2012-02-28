#lang racket

(require rackunit 
         "asm-support.rkt")


;; If you want your tests to fail in a 
;; noisy way, set this to true. There are 
;; several thousand tests, so I would only
;; use this to check where/what you fail on.
;;
;; Note that in NOISY mode, the test suite will
;; stop on the first test that fails and it will
;; not continue.
(define NOISY false)

;; Decide if you want textual or GUI-based results.
;; The text results only tell you how many tests you
;; failed. The GUI lets you browse all of the results.
(define GUI true)

;; There is no need to edit code beyond this point.

(define a0 '(0 1 -1 D A !D !A -D -A D+1 A+1 D-1 A-1 D+A D-A A-D D&A D\|A))
(define a1 '(M !M -M M+1 M-1 D+M D-M M-D D&M D\|M))
(define comp (append a0 a1))
(define dest '(null M D MD A AM AD AMD))
(define jump '(null JGT JEQ JGE JLT JNE JLE JMP))

(printf "Testing ASM support code.~n")



;; The complete test suite.
(define suite-extract-functions
  (test-suite
   "Testing extraction functions."
   
   ;; TEST SUITE
   (test-suite
    "Testing 'xxx=yyy;zzz' instructions."
    (for-each (λ (d)
                (for-each (λ (c)
                            (for-each (λ (j)
                                        (let ([inst (format "~a=~a;~a" d c j)])
                                          (test-case
                                           inst
                                           (check-equal? d (extract-dest inst))
                                           (check-equal? c (extract-comp inst))
                                           (check-equal? j (extract-jump inst)))))
                                      jump))
                          comp))
              dest))
   
   ;; TEST SUITE
   (test-suite
    "Testing 'xxx=yyy' instructions."
    (for-each (λ (d)
                (for-each (λ (c)
                            (let ([inst (format "~a=~a" d c)])
                              (test-case
                               inst
                               (check-equal? d (extract-dest inst))
                               (check-equal? c (extract-comp inst)))))
                          comp))
              dest))
   
   ;; TEST SUITE
   (test-suite
    "Testing 'yyy;zzz' instructions."
    (for-each (λ (c)
                (for-each (λ (j)
                            (let ([inst (format "~a;~a" c j)])
                              (test-case
                               inst
                               (check-equal? c (extract-comp inst))
                               (check-equal? j (extract-jump inst)))))
                          jump))
              comp))
   
   ;; TEST SUITE
   (test-suite
    "Testing 'yyy' instructions."
    (for-each (λ (c)
                (let ([inst (format "~a" c)])
                  (test-case
                   inst
                   (check-equal? c (extract-comp inst)))))
              comp))
   
   ;; TEST SUITE
   (test-suite
    "Testing random bits."
    (test-case
     "string->number-or-symbol"
     (check-equal? 3 (string->number-or-symbol "3"))
     (check-equal? 'elements (string->number-or-symbol "elements"))))
    
   ))


(require rackunit/text-ui rackunit/gui)

(if GUI
    (test/gui suite-extract-functions)
    (printf "Failed ~a tests."
            (run-tests suite-extract-functions 
                       (if NOISY 'normal 'quiet))))

