#lang racket

(provide  
 init-symbol-table
 add-labels-to-table
 add-memory-addresses-to-table)


;; We will use a hash table to store the
;; symbols and their memory locations as 
;; key-value pairs. The symbol will be the
;; key, and the value will be its location in memory.
(define SYMBOL-TABLE (make-hash))

;; CONTRACT
;; get-table
;; PURPOSE
;; Gets the symbol table.
(define (get-table)
  SYMBOL-TABLE)

;; CONTRACT
;; in-table? :: key -> boolean
;; PURPOSE
;; Returns true if the key is in the table.
(define (in-table? key)
  (hash-ref SYMBOL-TABLE key (λ () false)))

;; CONTRACT
;; lookup :: key -> number
;; PURPOSE
;; Returns the memory address associated with
;; the given key.
(define (lookup key)
  (hash-ref SYMBOL-TABLE key
            (λ ()
              (error (format "~a not in symbol table." key)))))

;; CONTRACT
;; insert :: key number -> number
;; PURPOSE
;; Inserts a key and address into the table.
;; Returns the value inserted.
(define (insert key addr)
  (hash-set! SYMBOL-TABLE key addr)
  addr)

;; CONTRACT
;; init-symbol-table
;; PURPOSE
;; Loads default symbols into the table.
(define (init-symbol-table)
  (map (λ (pair)
         (insert (first pair) (second pair)))
       `((SP 0) (LCL 1) (ARG 2) (THIS 3) (THAT 4)
         ,@(map (λ (n)
                  (list (string->symbol (format "R~a" n)) n))
                (list 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15))
         (SCREEN 16384) (KBD 24576))))

;; CONTRACT
;; add-labels-to-table :: (list-of instructions) number -> (list-of instructions)
;; PURPOSE
;; Takes a list of instructions and adds each label to the table.
(define (add-labels-to-table loi addr)
  '...)

;; CONTRACT
;; add-memory-addresses-to-table :: (list-of instructions) number -> (list-of add-memory-addresses-to-table)
;; PURPOSE
;; Takes a list of instructions and adds each memory address to the table.
(define (add-memory-addresses-to-table loi addr)
  '...)