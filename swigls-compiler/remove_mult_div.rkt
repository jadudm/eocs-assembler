#lang racket

(require "base.rkt")

;;CONTRACT
;; nested statement -> nested statment (without * and /)
;; replace multiplication and division with while loops
(define (remove-mult statement)
  (cond
    [(binop? statement)
     (cond
       [(equal? (binop-op statement) '*)
        (let ([flag (gensym 'flag)])
          (let ([inc (gensym 'inc)])
            (let ([val (gensym 'val)]) 
              (remove-mult 
               (seq 
                (list
                (set flag 0)
                (set val 0)
                (set inc (remove-mult (binop-lhs statement)))
                (while0 flag
                        (seq
                         (if0 inc
                              (set flag 1)
                              (set inc (binop '- inc 1)))
                         (set val (binop '+ val (remove-mult (binop-rhs statement))))))
                ; need to somehow return value
                val))))))]    
       [else
        (binop (binop-op statement) 
               (remove-mult (binop-lhs statement))
               (remove-mult (binop-rhs statement)))]
       )]

       
    [(if0? statement) (if0 (remove-mult (if0-test statement)) 
                          (remove-mult (if0-truecase statement)) 
                          (remove-mult(if0-falsecase statement)))]
    [(while0? statement) (while0  (remove-mult (while0-test statement)) 
                                  (remove-mult (while0-body statement)))]
    [(seq? statement) (seq (map remove-mult (seq-expressions statement)))]
    [(set? statement) (set (set-ident statement) (remove-mult (set-e statement)))]
    [(num? statement) (num (num-value statement))]
    [(symbol? statement) (symbol (symbol-value statement))]   
  ))



