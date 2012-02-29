#lang racket

(require "asm-base.rkt"
         "asm-support.rkt")

(provide add-labels-to-table
         add-memory-addresses-to-table
         assign-addresses
         )

;; Originally, the assembler was written in a purely
;; functional style. Truly, this would be better, for 
;; a variety of reasons. It was rewritten in an imperative
;; style (with mutation); as a result, the following
;; code is for manipulating the symbol table, which we 
;; represent with a hash table.
(define SYMBOL-TABLE (make-hash))

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
(define (add-labels-to-table loi addr)
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
;; assign-addresses :: (list-of instructions) -> (list-of instructions)
;; PURPOSE
;; This pass walks through each instruction, rewriting it as we go.
;; If we find a symbol A instruction, we should replace the symbolic
;; value with the numberic value stored in the symbol table.
;; Otherwise, we should keep the instruction as-is.
(define (assign-addresses loi)
  (cond
    [(empty? loi) '()]
    ;; ...
    [else
     (cons (first loi)
           (assign-addresses (rest loi) ))]
                             ))