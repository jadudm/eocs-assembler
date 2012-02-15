#lang racket
(require rackunit 
         "asm-base.rkt"
         "pass-parse.rkt")

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

;; Symbols for building test cases.
(define a0 '(0 1 -1 D A !D !A -D -A D+1 A+1 D-1 A-1 D+A D-A A-D D&A D\|A))
(define a1 '(M !M -M M+1 M-1 D+M D-M M-D D&M D\|M))
(define comp (append a0 a1))
(define dest '(null M D MD A AM AD AMD))
(define jump '(null JGT JEQ JGE JLT JNE JLE JMP))

(define label-syms '(#\_ #\$ #\.))
(define (generate-random-label)
  (let ([loc (list (integer->char (+ 65 (random 26))))])
    (let loop ([n 10])
      (unless (zero? n)
        (case (random 3)
          ;; A letter
          [(0) (set! loc 
                     (cons (integer->char
                            (+ 65 (random 26)))
                           loc))]
          ;; A number
          [(1) (set! loc 
                     (cons (integer->char
                            (+ 48 (random 10)))
                           loc))]
          ;; A symbol
          [(2) (set! loc 
                     (cons (list-ref label-syms 
                                     (random (length label-syms)))
                           loc))])
        (loop (sub1 n))))
    (list->string (reverse loc))))
      

(printf "Testing ASM parser.~n")
(define total 0)

;; The complete test suite.
(define suite-parse-one-line
  (test-suite
   "Testing parse-one-line."
   
   ;; TEST SUITE
   (test-suite
    "Testing 'xxx=yyy;zzz' instructions."
    (for-each 
     (λ (d)
       (for-each 
        (λ (c)
          (for-each (λ (j)
                      (let ([inst (format "~a=~a;~a" d c j)])
                        (test-case 
                         inst
                         (check-equal? (parse-one-line inst)
                                       (C 'no-line d c j))
                         )))
                    jump))
        comp))
     dest))
   
   ;; TEST CASE
   (test-suite
    "Testing 'xxx=yyy' instructions."
    (for-each 
     (λ (d)
       (for-each 
        (λ (c)
          (let ([inst (format "~a=~a" d c)])
            (test-case
             inst
             (check-equal? (parse-one-line inst)
                          (C 'no-line d c 'no-jump)))
            ))
        comp))
     dest))
   
   ;; TEST CASE
   (test-suite
    "Testing 'yyy;zzz' instructions."
    (for-each 
     (λ (c)
       (for-each 
        (λ (j)
          (let ([inst (format "~a;~a" c j)])
            (test-case
             inst
             (check-equal? (parse-one-line inst)
                           (C 'no-line 'no-dest c j))
             )))
        jump))
     comp))
   
   ;; TEST CASE
   (test-suite
    "Testing 'yyy' instructions."
    (for-each 
     (λ (c)
          (let ([inst (format "~a" c)])
            (test-case
             inst
             (check-equal? (parse-one-line inst)
                           (C 'no-line 'no-dest c 'no-jump))
             )))
     comp))
   
   ;; TEST SUITE
   (test-suite
    "Testing labels."
    (let loop ([n 1000])
      (unless (zero? n)
        (let ([lab (generate-random-label)])
          (test-case
           (format "Label: ~a" lab)
           (check-equal? (parse-one-line (format "(~a)" lab))
                         (label 'no-line (string->symbol lab)))))
        (loop (sub1 n)))))
     
   ;; TEST SUITE
   (test-suite
    "Testing random bits."
    (test-case
     "Blank lines"
     (check-equal? (parse-one-line "") 'blank-line)))
    ))

(require rackunit/text-ui rackunit/gui)

(if GUI
    (test/gui suite-parse-one-line)
    (printf "Failed ~a tests."
            (run-tests suite-parse-one-line 
                       (if NOISY 'normal 'quiet))))

