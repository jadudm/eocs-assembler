#lang racket

(require "asm-base.rkt"
         "asm-support.rkt"
         ;; For testing
         rackunit
         rackunit/text-ui 
         rackunit/gui
         )

(provide attach-instruction-locations)

;; SELF-CONTAINED TESTS
;; This module contains its own tests. The functions:
;;  * attach-to-a
;;  * attach-to-c
;;  * attach-to-label
;;  * attach-instruction-location
;; all have tests associated with them. Implementing
;; the first three makes the implementation of
;; the final function trivial.
;;
;; To run the tests, invoke the function (all-tests)
;; in the interactions pane after running the code.

;; TEST CONTROLS
;; If you want lots of noise (text mode)
(define NOISY false)
;; If you want the GUI for testing.
(define GUI true)

;; CONTRACT
;; attach-to-a :: A number -> A
;; PURPOSE
;; Takes an A instruction and an address, and returns the A
;; instruction with the instruction with the address inserted
;; into the addr field.
(define (attach-to-a instr addr)
  '...
  )

;; CONTRACT
;; attach-to-c :: C number -> C
;; PURPOSE
;; Takes an C instruction and an address, and returns the C
;; instruction with the instruction with the address inserted
;; into the addr field.
(define (attach-to-c instr addr)
  '...
  )

;; CONTRACT
;; attach-to-label :: label number -> label
;; PURPOSE
;; Takes an label instruction and an address, and returns the label
;; instruction with the instruction with the address inserted
;; into the addr field.
(define (attach-to-label instr addr)
  '...
  )

;; CONTRACT
;; ail :: (list-of instructions) number -> (list-of instructions)
;; PURPOSE
;; This function actually walks down the list, starting with 
;; address zero, attaching the address (and incrementing appropriately)
;; to each instruction.
(define (ail loi addr)
  (cond
    ;; You get the empty case for free.
    [(empty? loi) '()]    
    ;; Handle A, C, and label instructions
    ;; You should not need an 'else' case.
    ;; It only exists for tests.
    [else '...]
    ))

;; CONTRACT
;; attach-instruction-locations :: (list-of instructions) -> l-o-i
;; PURPOSE
;; Consumes a list of instruction structures (A, C, label) and returns
;; the list of instructions rebuilt. As we walk the list, attach an instruction
;; address to each A and C instruction (incrementing the line counter
;; as we proceed). Attach instruction addresses to labels, but do NOT increment
;; the instruction address as you go on---labels will ultimately be removed, and
;; therefore should not count as an instruction address.
(define (attach-instruction-locations loi)
  (reverse (ail (reverse loi) 0)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Test Suites
(define suite-a-instructions
  (test-suite
   "Testing A instructions"
   (let loop ([n 10])
     (unless (zero? n)
       (test-case
        (format "Testing with address ~a" n)
        (check-equal? (A n 'ANY) 
                      (attach-to-a (A -1 'ANY) n)))
       (loop (sub1 n))))
   ))

(define suite-c-instructions
  (test-suite
   "Testing C instructions"
   (let loop ([n 10])
     (unless (zero? n)
       (test-case
        (format "Testing with address ~a" n)
        (check-equal? (C n 'dest 'comp 'jump) 
                      (attach-to-c (C -1  'dest 'comp 'jump) n)))
       (loop (sub1 n))))
   ))

(define suite-label-instructions
  (test-suite
   "Testing label instructions"
   (let loop ([n 10])
     (unless (zero? n)
       (test-case
        (format "Testing with address ~a" n)
        (check-equal? (label n 'name) 
                      (attach-to-label (label -1  'name) n)))
       (loop (sub1 n))))
   ))

;; Support for testing a list of instructions
(define labels '())
(define (random-instructions addr)
  (let ([die (random 100)])
  (cond 
    [(< die 20)
     (let ([new-label (sym 'label)])
       (set! labels (cons new-label labels))
       (values (label addr new-label) (label -1 new-label)))]
    [(< die 60)
     (let ([d (sym 'D)] [c (sym 'C)] [j (sym 'J)])
       (values (C addr d c j) (C -1 d c j)))]
    [(< die 80)
     (let ([n (random 42)])
       (values (A addr n) (A -1 n)))]
    [(and (> (length labels) 0) (< die 100))
     (let ([lab (list-ref labels (random (length labels)))])
       (values (A addr lab) (A -1 lab)))]
    [else
     (random-instructions addr)]
    )))
       
(define (make-loi n max w/num w/onum)
  (cond
    [(= n max) (values w/num w/onum)]
    [else
     (let-values ([(with without) (random-instructions n)])
       (if (not (label? with))
           (make-loi (add1 n) max (cons with w/num) (cons without w/onum))
           (make-loi n max (cons with w/num) (cons without w/onum)))
           )]))

(define (make-list-of-instructions max)
  (set! labels '())
  (make-loi 0 max '() '()))

(define suite-list-of-instr
  (test-suite
   "Testing a list of instructions"
   (let loop ([n 10])
      (let ([leng (random 50)])
        (test-case
         (format "With ~a instructions" leng)
         (let-values ([(with without) (make-list-of-instructions leng)])
           (check-equal? with
                         (attach-instruction-locations without))
           )))
        (unless (zero? n)
          (loop (sub1 n)))
        )))



(define all-suites
  (test-suite
   "All Tests"
   suite-a-instructions
   suite-c-instructions
   suite-label-instructions
   suite-list-of-instr
   ))

(define (all-tests)
  (if GUI
      (test/gui all-suites)
      (printf "Failed ~a tests."
              (run-tests all-suites 
                         (if NOISY 'normal 'quiet)))))