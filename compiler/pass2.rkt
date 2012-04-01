;; Pass 2

;; thehumancompiler was here...

#lang racket
(require "base.rkt")

;; PURPOSE
;; Take in the structures from the previous pass
;; and produce a list of structures (broken down into the simple forms)
;; CONTRACT
;; pass2 : struct -> list of structs

#|
(+ 3 5) -> (simple + (num 3) (num 5)) -> (prog
                                            (id a 3)
                                            (id b 5)
                                            (id c (+ a b)))

(+ 3 (+ 2 3)) -> (binop + 3 (simple + (num 2) (num 3))
                          |
                          -> (prog
                                (id a 2)        (*)
                                (id b 3)        (**)
                                (id c (+ a b))  (***)
                                (id d 3)
                                (id e (+ c d)))
|#

(define (pass2 struc)
  (cond
    [(simple? struc)
     ;; Hold onto result of recursion and add to list
     (let ([lhs-result (pass2 simple-lhs)])
       (let ([rhs-result (pass2 simple-rhs)])
         ;; lhs-result = (*) // rhs-result = (**) // (id ...) = (***)
         (list lhs-result
               rhs-result
               (id ...))))]
    
    ))