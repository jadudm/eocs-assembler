#lang racket

(require "asm-base.rkt"
         "asm-support.rkt")

(provide write-file!)

;; CONTRACT
;; write-file! :: filename (list-of strings) -> void
;; PURPOSE
;; Takes the original filename and a list of strings
;; representing the machine code for a program, and 
;; writes each string to the file. It does overwrite
;; existing files, but hopefully nothing in the user's directory will
;; have the extention "hack".
(define (write-file! orig-file binary)
  (let* ([outfile (regexp-replace ".asm$" orig-file "-dr.hack")]
         [op (open-output-file outfile #:exists 'replace)])
    (for-each (λ (s)
                (fprintf op "~a~n" s))
              binary)
    (close-output-port op)))