#lang racket

(require "base.rkt")
(provide parse)
(provide interp reset-env)

(define env (make-hash))
(define (lookup v)
  (hash-ref env v
            (λ () (error (format "No value for ~a in env." v)))))
(define (update k v)
  (hash-set! env k v))
(define (reset-env)
  (set! env (make-hash)))

(define (interp e)
  (match e
    [(struct num (n)) n]
    [(struct variable (sym))
     (lookup sym)]
    [(struct binop (op lhs rhs))
     ((eval op) (interp lhs)
                (interp rhs))]
    [(struct set (id val))
     (update id (interp val))]
    [(struct if0 (test true false))
     (if (zero? (interp test))
         (interp true)
         (interp false))]
    [(struct while0 (test body))
     (let loop ()
       (when (zero? (interp test))
         (interp body)
         (loop)))]
    [(struct seq (e*))
     (first (reverse (map interp e*)))]
    ))

(define (operator? sym)
  (member sym '(+ - *)))

(define (parse e)
  (match e
    [(? number? n) (num n)]
    [(? symbol? s) (variable s)]
    [`(,(? operator? op) ,lhs ,rhs)
     (binop op (parse lhs) (parse rhs))]
    [`(set ,id ,val)
     (set id (parse val))]
    [`(if0 ,test ,true ,false)
     (if0 (parse test) (parse true) (parse false))]
    [`(while0 ,test ,body)
     (while0 (parse test) (parse body))]
    [`(seq ,e ...)
     (seq (map parse e))]))

(define (sum-nums-sexp n)
  `(seq 
    (set n ,n) 
    (set sum 0)
    (set flag 0)
    (while0 flag
            (if0 n
                 (set flag -1)
                 (seq
                  (set sum (+ sum n))
                  (set n (- n 1)))))
    sum))

(define (sum-nums-struct n)
  (seq 
   (list 
    (set 'n (num n))
    (set 'sum (num 0))
    (set 'flag (num 0))
    (while0 (variable 'flag)
            (if0 (variable 'n)
                 (set 'flag (num -1))
                 (seq
                  (list 
                   (set 'sum (binop '+ 
                                    (variable 'sum)
                                    (variable 'n)))
                   (set 'n (binop '-
                                  (variable 'n)
                                  (num 1)))))))
    (variable 'sum))))




