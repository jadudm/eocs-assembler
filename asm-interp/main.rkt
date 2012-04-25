#lang racket

(require rackunit
        srfi/1)

(provide emulate)

;; Machine State
(define state (make-hash))

(define (set-d! v)
  (hash-set! state 'D v))

(define (set-a! v)
  (hash-set! state 'A v))

(define (set-ram! addr v)
  (hash-set! state addr v))

(define (get-d)
  (hash-ref state 'D))

(define (get-a)
  (hash-ref state 'A))

(define (get-ram addr)
  (hash-ref state addr (λ () 0)))

(define (mem)
  (hash-ref state (get-a) (λ () 0)))

(define (set-mem! v)
  (hash-set! state (get-a) v))

(define (show-state)
  (printf "D       {~a}~nA       {~a}~n" (get-d) (get-a))
  (let loop ([addr 0])
    (unless (>= addr 17)
      (if (< addr 10)
          (printf "RAM[~a]  {~a}~n" addr (get-ram addr))
          (printf "RAM[~a] {~a}~n" addr (get-ram addr)))
      (loop (add1 addr)))))

(define (init-state)
  (set-d! 0)
  (set-a! 0)
  (reset-symbol-table)
  )

;; Code state
(define code (make-hash))

(define (read-instructions file)
  (let ([ip (open-input-file file)]
        [c 0])
    (let loop ([line (read-line ip)]
               )
      (unless (eof-object? line)
        (hash-set! code c line)
        (set! c (add1 c))
        (loop (read-line ip))))
    (close-input-port ip)
    c
    ))

(define (get-code i)
  (hash-ref code i))

;; Symbol table
(define table (make-hash))
(define sym-location 1)
(define (lookup sym)
  (if (hash-ref table sym (λ () false))
      (hash-ref table sym)
      (error "No symbol found: ~a~n" sym)))
(define (new-symbol sym)
  (let ([current sym-location])
    (hash-set! table sym current)
    (set! sym-location (add1 sym-location))
    current
  ))
(define (new-label sym loc)
  (hash-set! table sym loc)
  loc)
(define (reset-symbol-table)
  (set! table (make-hash)))

(define (interp-c i)
  (match i
    ["0" 0]
    ["1" 1]
    ["-1" -1]
    ["D" (get-d)]
    ["A" (get-a)]
    ;; The bitwise operations will need to be fixed.
    ;; They will not stay within a 16-bit number.
    ["!D" (bitwise-not (get-d))]
    ["!A" (bitwise-not (get-a))]
    ["-D" (- (get-d))]
    ["-A" (- (get-a))]
    ["D+1" (add1 (get-d))]
    ["A+1" (add1 (get-a))]
    ["D-1" (sub1 (get-d))]
    ["A-1" (sub1 (get-a))]
    ["D+A" (+ (get-d) (get-a))]
    ["D-A" (- (get-d) (get-a))]
    ["A-D" (- (get-a) (get-d))]
    ["D&A" (bitwise-and (get-d) (get-a))]
    ["D|A" (bitwise-ior (get-d) (get-a))]
    ["M" (mem)]
    ["!M" (bitwise-not (mem))]
    ["-M" (- (mem))]
    ["M+1" (add1 (mem))]
    ["M-1" (sub1 (mem))]
    ["D+M" (+ (get-d) (mem))]
    ["D-M" (- (get-d) (mem))]
    ["M-D" (- (mem) (get-d))]
    ["D&M" (bitwise-and (get-d) (mem))]
    ["D|M" (bitwise-ior (get-d) (mem))]
    [else
     (error "No clause matched.")]))

(define (interp-dc i)
  (match i
    ["null" (λ (v) v)]
    ["M" (λ (v) (set-mem! v))]
    ["D" (λ (v) (set-d! v))]
    ["MD" (λ (v) (set-mem! v) (set-d! v))]
    ["A" (λ (v) (set-a! v))]
    ["AM" (λ (v) (set-mem! v) (set-a! v))]
    ["AD" (λ (v) (set-a! v) (set-d! v))]
    ["AMD" (λ (v) (set-mem! v) (set-a! v) (set-d! v))]))

(define (interp-d i)
  (match i
    ["M" (mem)]
    ["D" (get-d)]
    ["A" (get-a)]
    ))

(define DCJ "^(.*?)=(.*?);(.*?)$")
(define DC "^(.*?)=(.*?)$")
(define CJ "^(.*?);(.*?)$")
(define D "^([DMA])$")
(define LAB "^\\((.*?)\\)$")
(define CONST "^@([a-zA-Z_]+[0-9a-zA-Z_-]+?)$")
(define NUM "^@([0-9]+)$")
(define LABEL "^\\(([a-zA-Z]+[0-9a-zA-Z]*)\\)$")

(define (interp i loc)
  (match i
    [(regexp DCJ) 
     'NOT_IMPLEMENTED]
    
    [(regexp DC)
     (let ([d (second (regexp-match DC i))]
           [c (third (regexp-match DC i))])
       ((interp-dc d) (interp-c c)) 
       'NEXT
       )]
    
    [(regexp CJ)
     (let ([c (second (regexp-match CJ i))]
           [j (third (regexp-match CJ i))])
       (set-d! (interp-c c))
       ;; Return the jump code
       (string->symbol j))]
     
    ;; This is essentially a NOP. Only makes sense
    ;; in conjunction with, say, the jump bits.
    [(regexp D)
     (let ([d (second (regexp-match D i))])
       (interp-d)
       'NEXT
       )]
    
    [(regexp NUM)
     (let ([n (string->number 
               (second (regexp-match NUM i)))])
       (set-a! n)
       'NEXT
       )]
    
    [(regexp CONST)
     (let ([the-const (second (regexp-match CONST i))])
       (set-a! (new-symbol the-const))
       'NEXT
       )]
    
    [(regexp LABEL)
     (let ([the-sym (second (regexp-match LABEL i))])
       (new-label the-sym loc)
       (set-a! loc)
       'NEXT
       )]
       
    ))

(define-syntax (while stx)
  (syntax-case stx ()
    [(_ test bodies ...)
     #`(let loop ()
         (when test
           (begin
             bodies ...
             (loop))))]))
             
     
(define (emulate file)
  (define i 0)
  (define DONE false)
  
  ;; Read the instruction list into the code memory of the 
  ;; emulator (or should that be simulator?).
  (let ([num-inst (read-instructions file)])
    ;; Always initialize the state of the machine.
    (init-state)
    ;; Then, loop through each instruction.
    ;; Interpret it.
    ;; This is often called a "fetch-execute" loop
    ;; in the world of bytecode interpreters.
    (while (not DONE)
      (if (>= i num-inst)
          (set! DONE true)
          (let ([result (interp (get-code i) i)])
            (printf "Interpreting [~a] ~a [~a]~n" i (get-code i) result)
            (case result
              ['NEXT (set! i (add1 i))]
              ['JMP
               (printf "JUMPING TO ~a~n" i)
               (set! i (get-a))]))))
    
    ;; Show the state when we're done.
    (show-state)
    ;; Return the value of RAM location zero.
    (get-ram 0)
    ))