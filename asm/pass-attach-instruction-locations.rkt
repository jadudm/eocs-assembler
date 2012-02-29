#lang racket

(require "asm-base.rkt"
         "asm-support.rkt")

(provide attach-instruction-locations)

;; CONTRACT
;; attach-instruction-locations :: (list-of instructions) number -> l-o-i
;; PURPOSE
;; Consumes a list of instruction structures (A, C, label) and returns
;; the list of instructions rebuilt. As we walk the list, attach an instruction
;; address to each A and C instruction (incrementing the line counter
;; as we proceed). Attach instruction addresses to labels, but do NOT increment
;; the instruction address as you go on---labels will ultimately be removed, and
;; therefore should not count as an instruction address.


(define (attach-instruction-locations loi addr)
  (cond
    [(empty? loi) '()]
    [(A? (first loi)) '...]
    [(C? (first loi)) '...]
    [(label? (first loi)) '...]
    [else
     (attach-instruction-locations (rest loi) addr)]))