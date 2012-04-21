#lang racket

(require "base.rkt")

(define (removewhile statement)
  (cond
    [(while0? statement) 
                          (let ([top-label (gensym 'TOP)]
                                [end-label (gensym 'END)]
                                [FLAG      (gensym 'FLAG)]
                                )
                            (seq
                             (list
                              (label top-label)
                              (set FLAG (removewhile (while0-test statement)))
                              (if0 FLAG
                                   (seq
                                    (list
                                     (removewhile (while0-body statement))
                                     (goto top-label)))
                                   (goto end-label))
                              (label end-label)
                              ))
                            )]
    [(binop? statement)
     (binop (binop-op statement) 
            (removewhile (binop-lhs statement))
            (removewhile (binop-rhs statement)))]

       
    [(if0? statement) (if0 (removewhile if0-test) 
                          (removewhile if0-truecase) 
                          (removewhile if0-falsecase))]
   
    [(seq? statement) (seq (map removewhile (seq-expressions statement)))]
    [(set? statement) (set (set-ident statement) (removewhile (set-e statement)))]
    [(num? statement) statement]
    [(symbol? statement) statement]
  ))