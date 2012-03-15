#lang racket

(require rackunit
         "asm-base.rkt"
         "asm-support.rkt")

(provide init-symbol-table
         add-labels-to-table
         add-memory-addresses-to-table
         )

;; Originally, the assembler was written in a purely
;; functional style. Truly, this would be better, for 
;; a variety of reasons. It was rewritten in an imperative
;; style (with mutation); as a result, the following
;; code is for manipulating the symbol table, which we 
;; represent with a hash table.
(define SYMBOL-TABLE (make-hash))

;; CONTRACT
;; init-symbol-table
;; PURPOSE
;; Loads default symbols into the table.
(define (init-symbol-table)
  (map (λ (pair)
         (table-add! (first pair) (second pair)))
       `((SP 0) (LCL 1) (ARG 2) (THIS 3) (THAT 4)
                ,@(map (λ (n)
                         (list (string->symbol (format "R~a" n)) n))
                       (list 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15))
                (SCREEN 16384) (KBD 24576))))

;; CONTRACT
;; table-add! :: symbol number -> void
;; PURPOSE
;; Adds a new label or memory address to the table.
;; Prevents the addition of the same label or address
;; multiple times.
(define (table-add! sym location)
  (if (in-table? sym)
      (error (format "Cannot add symbol '~a' to the lookup table more than once."
                     sym))
      (hash-set! SYMBOL-TABLE sym location)))

;; CONTRACT
;; table-lookup :: symbol -> number
;; PURPOSE
;; Returns the address associated with the given symbol.
(define (table-lookup label)
  (hash-ref SYMBOL-TABLE label 
            (λ () 
              (error (format "No label found for '~a'" label)))))

;; CONTRACT
;; in-table? :: symbol -> boolean
;; PURPOSE
;; Returns true if we find the symbol in the table,
;; false otherwise.
(define (in-table? label)
  (hash-ref SYMBOL-TABLE
            label 
            (λ () false)))


;; CONTRACT
;; add-labels-to-table :: (list-of instructions) address -> (list-of instructions)
;; PURPOSE
;; Walks through a list of instructions, adding labels to the 
;; lookup table. Increments the address as we go. Remember
;; that a label should not cause the address to go up, as 
;; labels will ultimately be removed. Return the list of instructions
;; as-is.
(define (add-labels-to-table loi)
  (cond
    ;; We don't care what comes 
    ;; back in the empty case.
    [(empty? loi) '()]
    ;; Handle labels
    [(label? (first loi)) '...]
    ;; Pass everything else through unscathed
    [else '...]))


;; CONTRACT
;; add-memory-addresses-to-table :: (list-of instructions) addr -> (l-o instr)
;; PURPOSE
;; Walks through the table. When we find a symbolic memory reference,
;; (for example, @i), place the variable name into the symbol table, in
;; addition to the address where it is stored. Remember, this will
;; be a function that processes A instructions... but only those A 
;; instructions that have a value field that is symbolic.
;;
;; Rebuild the list of instructions as you go.
(define (add-memory-addresses-to-table loi next-mem)
  (cond
    [(empty? loi) '()]
    ;; ...
    ))

;; CONTRACT
;; rewrite-with-addresses :: (list-of instructions) -> (list-of instructions)
;; PURPOSE
;; Takes a list of instructions and rewrites the instruction stream
;; so that no symbolic references remain. 
(define (rewrite-with-addresses loi)
  '...)


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

(define random-instruction
  (let ([labels '()])
    (lambda (addr)
      (let ([die (random 100)])
        (cond 
          [(< die 20)
           (let ([new-label (sym 'label)])
             (set! labels (cons new-label labels))
             (label addr new-label))]
          [(< die 40)
           (C addr (sym 'D) (sym 'C) (sym 'J))]
          [(< die 60)
           (A addr (random 42))]
          [(< die 80)
           (let ([symbols '(juliet alpha delta uniform)])
             (A addr (sym (list-ref symbols (random (length symbols))))))]
          [(and (> (length labels) 0) (< die 100))
           (A addr (list-ref labels (random (length labels))))]
          [else
           (random-instruction addr)]
          )))))

(define make-loi
  ;; stream :: the full list of instructions
  ;; stripped :: generated with correct addressing
  (let ([stream '()]  
        [stripped '()]
        [label-table (make-hash)]
        [mem-table (make-hash)]
        [addr START-ADDRESS])
    (lambda (n max)
      (cond
        [(= n max) 
         ;; Combine the hash tables
         (let ([combined (make-hash)])
           (hash-for-each label-table (lambda (k v)
                                        (hash-set! combined k v)))
           (hash-for-each mem-table (lambda (k v)
                                      (hash-set! combined k v)))
           
           (values stream stripped label-table mem-table combined))]
        [else
         (let ([i (random-instruction n)])
           (cond
             [(label? i)
              ;; Put labels in the stream
              (set! stream (snoc i stream))
              ;; But not in the stripped stream
              ;; However, add them to the symbol table
              (hash-set! label-table (label-name i) n)
              (make-loi n max)]
             [(A? i)
              ;; Add A instructions to the stream
              (set! stream (snoc i stream))
              ;; Handle the stripped list.
              ;; And if it is symbolic, look it up in the table.
              (cond
                ;; If it is a label, it will be in the table at this point.
                [(in-table? (A-value i))
                 (set! stripped (snoc (A (table-lookup (A-value i))
                                         (A-value i))
                                      stripped))]
                ;; If it isn't in the table, and it is symbolic, we should
                ;; add it to the table and give it an address.
                [(symbol? (A-value i))
                 (hash-set! mem-table (A-value i) addr)
                 (set! stripped (snoc (A addr (A-value i)) stripped))
                 (set! addr (add1 addr))]
                ;; Otherwise, we just add it to the stripped list
                [else
                 (set! stripped (snoc i stripped))])
              (make-loi (add1 n) max)]
             [(C? i) 
              (set! stream (snoc i stream))
              (set! stripped (snoc i stripped))
              (make-loi (add1 n) max)])
           )]))))

(define (make-list-of-instructions max)
  ;; Refresh the symbol table
  (set! SYMBOL-TABLE (make-hash))
  (make-loi 0 max))

(define (hash-same? h1 h2)
  (let ([same? true])
    (hash-for-each h1
                   (lambda (k v)
                     (unless (equal? (hash-ref h1 k (λ () 'h1))
                                     (hash-ref h2 k (λ () 'h2)))
                       (set! same? false))))
    (hash-for-each h2
                   (lambda (k v)
                     (unless (equal? (hash-ref h1 k (λ () 'h1))
                                     (hash-ref h2 k (λ () 'h2)))
                       (set! same? false))))
    same?))

(define (case-label-table)
  (let loop ([n 50])
    (let-values ([(stream stripped
                          label-table 
                          mem-table
                          combined-table)
                  (make-list-of-instructions 50)])
      (test-case
       "Building the label table."
       (set! SYMBOL-TABLE (make-hash))
       (add-labels-to-table stream)
       (check-true (hash-same? SYMBOL-TABLE label-table))
       ))))

(define (case-mem-table)
  (let loop ([n 50])
    (let-values ([(stream stripped
                          label-table 
                          mem-table
                          combined-table)
                  (make-list-of-instructions 50)])
      (test-case
       "Building the memory table."
       (set! SYMBOL-TABLE (make-hash))
       ;; Does the test need to compare the combined table,
       ;; or can we build only the memory table?
       ;; What happens when they see a label? Badness... they'll think
       ;; it is a memory address. So, the previous pass must run first.
       ;; Poor design on my part, need to revise for next time, perhaps.
       (add-labels-to-table stream)
       (add-memory-addresses-to-table stream START-ADDRESS)
       (check-true (hash-same? SYMBOL-TABLE combined-table))
       ))))

(define (case-rewritten)
  (let loop ([n 50])
    (let-values ([(stream stripped
                          label-table 
                          mem-table
                          combined-table)
                  (make-list-of-instructions 50)])
      (test-case
       "Rewriting the instruction stream."
       (set! SYMBOL-TABLE (make-hash))
       (add-labels-to-table stream)
       (add-memory-addresses-to-table stream START-ADDRESS)
       (check-equal? stripped
                     (rewrite-with-addresses stream))
       ))))



(define suite-test-tables
  (test-suite
   "Testing symbol table construction."
   (case-label-table)
   (case-mem-table)
   (case-rewritten)
   ))




(require rackunit/text-ui rackunit/gui)

(if GUI
    (test/gui suite-test-tables)
    (printf "Failed ~a tests."
            (run-tests suite-test-tables
                       (if NOISY 'normal 'quiet))))