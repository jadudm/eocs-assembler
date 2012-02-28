#lang racket

(require "asm-base.rkt")

(provide extract-dest
         extract-comp
         extract-jump
 
         @inst->symbol
         @inst->number
         
         ;; Random bits
         ;; Exported for testing only.
         string->number-or-symbol
         )

;; CONTRACT
;; string->number-or-symbol :: string -> (U symbol? number?)
;; PURPOSE
;; If the string provided can be turned into a number,
;; then it is. Otherwise, it is turned into a symbol.
(define (string->number-or-symbol str)
  (if (string->number str)
      (string->number str)
      (string->symbol str)))

;; CONTRACT
;; @inst->number :: string -> number
;; PURPOSE
;; Takes an @ instruction and returns the number
;; that it contains.
(define (@inst->number asm)
  (string->number
   (second (regexp-match "([0-9]+)" asm))))

;; CONTRACT
;; @inst->number :: string -> number
;; PURPOSE
;; Takes an @ instruction and returns the symbol
;; that it contains.
(define (@inst->symbol asm)
  (string->symbol
   ;; It must start with alpha characters, and then anything can follow
   (second (regexp-match "([a-zA-Z]+[a-zA-Z0-9_$.]+)" asm))))

;; CONTRACT
;; extract-comp :: string -> symbol
;; PURPOSE
;; Takes an instruction of the form
;;   dest=comp;...
;; or
;;   comp
;; and returns a symbol representing the 'dest'.
(define (extract-comp exp)
  '...)

;; CONTRACT
;; extract-dest :: string -> symbol
;; PURPOSE
;; Takes an instruction of the form
;;   dest=...
;; and returns a symbol representing the 'dest'.
(define (extract-dest asm)
  '...)

;; CONTRACT
;; extract-jump :: string -> symbol
;; PURPOSE
;; Takes an instruction of the form
;;   dest=comp;jump
;; and returns a symbol representing the 'dest'.
(define (extract-jump exp)
  '...)