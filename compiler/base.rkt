#lang racket

(provide (all-defined-out))


;; Structures


;; Number Structure
;; contains a
;; - value
(struct num (value)
  #:inspector (make-inspector))

;; Binop Structure
;; contains a
;; - operator
;; - left hand operand
;; - right hand operand
(struct binop (op lhs rhs)
  #:inspector (make-inspector))

;; Simple Structure
;; contains a
;; - operator
;; - left hand operand
;; - right hand operand
;; NOTE: lhs and rhs must be num structures!
(struct simple (op lhs rhs)
  #:inspector (make-inspector))

;; Identifier Structure
;; contains a
;; - symbol
;; - number or simple
(struct id (sym value)
  #:inspector (make-inspector))

