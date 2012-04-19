#lang racket

(require "base.rkt")

;;CONTRACT
;; nested statement -> nested statment (without * and /)
;; replace multiplication and division with while loops
(define (remove-mult-div statement)
  (cond
    [(binop? statement)
     (cond
       [(equal? statement-op '*)
        (let ([flag (gensym 'flag)])
          (let ([inc (gensym 'inc)])
            (let ([val (gensym 'val)]) 
              (remove-mul-div 
               (seq 
                (list
                (set flag 0)
                (set val 0)
                (set inc (remove-mult-div statement-lhs))
                (while0 flag
                        (seq
                         (if0 inc
                              (set flag 1)
                              (set inc (binop '- inc 1)))
                         (set val (binop '+ val (remove-mult-div statement-rhs)))))
                ; need to somehow return value
                val))))))]   
       [(equal? statement-op '/)
        (let ([flag (gensym 'flag)])
          (let ([inc (gensym 'inc)])
            (let ([val (gensym 'val)])
              (let ([count (gensym 'count)]) 
              (remove-mul-div 
               (seq 
                (list
                 (set flag 0)
                 (set val 0)
                 (set inc (remove-mult-div stement-lhs))
                 (while0 flag
                         (seq
                          (if0 inc
                               (set flag 1)
                               (set inc (binop '- inc 1)))
                          (set val (binop '+ val (remove-mult-div stement-rhs)))))
                 ; need to somehow return value
                count)))))))]
       [else
        (binop statement-op 
               (remove-mul-div statement-lhs)
               (remove-mul-div statement-lhs))]
       )]

       
    [(if0? statement) (if0 (remove-mul-div statement-test) 
                          (remove-mul-div statement-truecase) 
                          (remove-mul-div statement-falsecase))]
    [(while0? statement) (while0  (remove-mul-div statment-test) 
                                  (remove-mul-div statment-body))]
    [(seq? statement) (seq (map remove-mul-div statment-expressions))]
    [(set? statement) (set statment-ident (remove-mul-div statment-e))]
    [(num? statement) (num statement-value)]
    [(symbol? statement) (symbol statement-value)]

    
  ))


