#lang racket

(require "pass1.rkt")
(require "base.rkt")
(require rackunit)

;;this is the test code for pass1

(check-equal? (pass-to-struct 3) (num 3))
(check-equal? (pass-to-struct '(+ 3 5)) (binop '+ (num 3) (num 5)))

(check-equal? (pass-to-struct '(- 3
                        (+ (- 5 
                              (+ 2 7))
                           (+ (- (- 2 3) 3)              
                              (+ 4 (+ 3 (- 4 2)))))))
              
              (binop '- (num 3)
                        (binop '+ 
                               (binop '- (num 5) 
                                         (binop + (num 2) (num 7)))
                               (binop '+ (binop '- (binop '- (num 2)(num 3))
                                                   (num 3))
                                         (binop + (num 4)
                                                  (binop '+ (num 3)
                                                            (binop '- (num 4) 
                                                                      (num 2))))))))
