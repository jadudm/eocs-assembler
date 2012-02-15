#lang racket
(require "asm-base.rkt"
         "asm-support.rkt")

(provide parse
         ;; Export parse-one-line
         ;; so we can test it.
         parse-one-line)

;; CONTRACT
;; parse :: list-of strings -> list-of ASM structures
;; PURPOSE
;; Takes in a list of strings and returns a list
;; of ASM structures (and a symbol or two).
(define (parse los)
  (cond
    [(empty? los) '()]
    [else
     (cons (parse-one-line (first los))
           (parse (rest los)))]))

;; CONTRACT
;; parse-one-line :: string -> (U A? C? label? symbol?)
;; PURPOSE
;; Parses a string representing a single assembly
;; language instruction.
(define (parse-one-line asm)
  (match asm
    ;; Handle blank lines.
    [(regexp "^\\s*$") 'blank-line]
    ;; If all else fails, emit a parse bogon.
    [else 'parse-bogon]
    ))