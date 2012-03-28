#lang racket

(require rackunit
         "../asm/asm-base.rkt"
         "../asm/asm-support.rkt"
         "base.rkt"
         "helpers.rkt")


(test-suite
 "hand-written tests for CS420"
 (test-case
  "(+ 3 5)"
  (compile '(+ 3 5) "foo.hack")
  (check-equal?
   (file->list "foo.hack")
   (file->list "one.hack")))
(test-case
 "(- 9 1)"
 (compile '(- 9 1) "foo.hack")
 (check-equal?
  (file->list "foo.hack")
  (file->list "two.hack")))
(test-case
 "(+ 3(- 5 2)"
 (compile '(+ 3(- 5 2)) "foo.hack")
 (check-equal?
  (file->list "foo.hack")
  (file->list "three.hack")))


(define actual1
  (file->list "testactual.txt"))
(define expected1
  (file->list "testfile.txt" ))
(check-equal? actual1 expected1 "is this assembly as expected?")
