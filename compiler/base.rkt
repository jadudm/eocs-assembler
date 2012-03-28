#lang racket

(provide (all-defined-out))

;; Structures
(struct E (op lhs rhs)
  #:inspector (make-inspector))


(struct id (sym simple)
  #:inspector (make-inspector))



;; NOT YET COMPLETED, MORE STRUCTURES MUST BE ADDED
;; AS THE PROJECT CONTINUES AND STRUCTURES ARE NEEDED

