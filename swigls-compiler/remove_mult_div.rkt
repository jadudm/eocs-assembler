#lang racket

(require "base.rkt")
(provide remove-mult)

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
                (set flag (num 0))
                (set val (num 0))
                (set inc (remove-mult (binop-lhs statement)))
                (while0 (variable flag)
                        (seq
                         (list
                         (if0 (variable inc)
                              (set flag (num 1))
                              (set inc (binop '- (variable inc) (num 1))))
                         (set val (binop '+ (variable val) (remove-mult (binop-rhs statement)))))))
                ; need to somehow return value
                (variable val)))))))]    
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
    [(num? statement) statement]
    [(variable? statement) statement]   
  ))



