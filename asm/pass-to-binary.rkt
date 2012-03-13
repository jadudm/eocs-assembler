#lang racket

(require "asm-base.rkt"
         "asm-support.rkt")

(provide structure->binary)

;; HELPERS
;; These functions all take a symbol
;; representing an instruction and return the binary
;; string representing that instruction. These values are 
;; extracted from Elements of Computing Systems by 
;; Noam Nisan and Shimon Schocken

;; CONTRACT
;; a-bits :: instruction -> string
;; PURPOSE
;; Takes an instruction and returns the "a" bit. 
;; This is either a zero or a one.
(define (a-bit inst)
  (cond
    [(member (C-comp inst)
             '(0 1 -1 D A !D !A -D -A D+1 A+1 D-1 A-1 D+A D-A A-D D&A D\|A))
     "0"]
    [else
     "1"]))

;; CONTRACT
;; c-bits :: instruction -> string
;; PURPOSE
;; Takes an instruction and returns the "c" bits.
;; These control the accumulator, and are all of 
;; length six.
(define (c-bits inst)
  (case (C-comp inst)
    ((0)   "101010")
    ((1) "111111")
    ((-1) "111010")
    ((D) "001100")
    ((A) "110000")
    ((!D) "001101")
    ((!A) "110001")
    ((-D) "001111")
    ((-A) "110011")
    ((D+1) "011111")
    ((A+1) "110111")
    ((D-1) "001110")
    ((A-1) "110010")
    ((D+A) "000010")
    ((D-A) "010011")
    ((A-D) "000111")
    ((D&A) "000000")
    ((D\|A) "010101")
    ((M) "110000")
    ((!M) "110001")
    ((-M) "110011")
    ((M+1) "110111")
    ((M-1) "110010")
    ((D+M) "000010")
    ((D-M) "010011")
    ((M-D) "000111")
    ((D&M) "000000")
    ((D\|M) "010101")))

;; CONTRACT
;; d-bits :: instruction -> string
;; PURPOSE
;; Returns the "d" bits, given an instruction.
;; These are all the destinations of the operation
;; of the accumulator, and are of length 3.
(define (d-bits inst)
  (match (C-dest inst)
    ['no-dest "000"]
    ['M       "001"]
    ['D       "010"]
    ['MD      "011"]
    ['A       "100"]
    ['AM      "101"]
    ['AD      "110"]
    ['AMD     "111"]))

;; CONTRACT
;; j-bits :: instruction -> string
;; PURPOSE
;; Returns the "j" bits, which control
;; where we go next. These are of length 3, and 
;; primarily control the program counter.
(define (j-bits inst)
  (match (C-jump inst)
    ['no-jump  "000"]
    ['JGT      "001"]
    ['JEQ      "010"]
    ['JGE      "011"]
    ['JLT      "100"]
    ['JNE      "101"]
    ['JLE      "110"]
    ['JMP      "111"]))

;; CONTRACT
;; structure->binary :: instruction -> string
;; PURPOSE
;; Takes an instruction (either a C or an A instruction) and
;; returns the 16 bit binary string that represents the machine
;; code instruction for the AST representation that you are given.
;; HINT
;; Should probably use string-append and the functions above.
(define (structure->binary ast)
  '...)
