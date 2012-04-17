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
        (let ([flag (gensym)])
          (let ([inc (gensym)])
            (let ([val (gensym)]) 
              (remove-mul-div 
               (seq 
                (set flag 0)
                (set val 0)
                (set inc (remove-mult-div stement-lhs))
                (while0 flag
                        (seq
                         (if0 inc
                              (set flag 1)
                              (set inc (binop '- inc 1)))
                         (set value (binop '+ value (remove-mult-div stement-rhs)))))
                ; need to somehow return value
                (set val val))))))]   
       [(equal? statement-op '*/)
        ;;TODO: figure out divide
        ;; http://en.wikipedia.org/wiki/Division_%28digital%29
        (remove-mul-div (replace-div statement))]
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
  ))



