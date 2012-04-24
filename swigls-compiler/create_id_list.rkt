;; Pass 2

#lang racket
(require "base.rkt")
(provide createids)

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

  

#|
(cond
                        [(empty? structure) 0]
                        [else (cons (createids (first (seq-expressions structure)))
                                    (createids (rest (seq-expressions structure))))]
|#

(define (last ls)
  (first (reverse ls)))

(define (createids structure)
  (cond
    [(seq? structure) (map createids (seq-expressions structure))]
                         
                         
    [(binop? structure) (let ([lhs (createids (binop-lhs structure))]
                              [rhs (createids (binop-rhs structure))])
                          (append
                           lhs
                           rhs
                           (list
                            (id (gensym 'bin) (binop (binop-op structure)
                                                     (id-sym (last lhs))
                                                     (id-sym (last rhs))
                                                     )))))]
    [(if0? structure) (let ([test (createids (if0-test structure))]
                              [truecase (createids (if0-truecase structure))]
                              [falsecase (createids (if0-falsecase structure))])
                          (append
                           test
                           truecase
                           falsecase
                           (list
                            (id (gensym 'if) (if0 (id-sym (last test))
                                                     (id-sym (last truecase))
                                                     (id-sym (last falsecase))
                                                     )))))]
    [(set? structure) (let ([e (createids (set-e structure))])
                          (append
                           e
                           (list
                            (id (set-ident structure) (id-sym (last e))))))]
    [(goto? structure) (list (id (gensym 'goto) (goto-sym structure)))]
    [(label? structure) (list (id (gensym 'label) (label-sym structure)))]
    [(num? structure) (list (id (gensym 'num) (num-value structure)))]
    [(variable? structure) (list (id (gensym 'sym) (variable-value structure)))]
    ))

(define (unfold loi)
  (cond
    [(list? (first loi)) '...]
    [else '...]))