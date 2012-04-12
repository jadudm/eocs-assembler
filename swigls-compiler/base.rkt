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

;; Label Structure
;; contains a
;; - symbol
(struct label (sym)
  #:inspector (make-inspector))

;; Goto Stucture
;; contains a
;; - symbol
(struct goto (sym)
  #:inspector (make-inspector))

;; If0 Structure
;; contains a
;; - test
;; - true case
;; - false case
;; The test and cases must be expressions
(struct if0 (test truecase falsecase)
  #:inspector (make-inspector))

;; While0 Structure
;; contains a
;; - test
;; - body
;; The test and body must be expressions
(struct while0 (test body)
  #:inspector (make-inspector))

;; Seq Structure
;; contains a 
;; - a list of one or more expressions
(struct seq (expressions)
  #:inspector (make-inspector))
