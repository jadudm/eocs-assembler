#lang racket

(require rackunit
         "../asm/asm-base.rkt"
         "../asm/asm-support.rkt"
         "base.rkt"
         "helpers.rkt")

(define-check (check-files f1 f2)
  (check-equal?
   (file->list f1)
   (file->list f2)))

(test-suite
 "hand-written tests for CS420"
 (test-case
  "(+ 3 5)"
  (compile '(+ 3 5) "foo.hack")
  (check-files "foo.hack" "testingFiles/one.hack"))
(test-case
 "(- 9 1)"
 (compile '(- 9 1) "foo.hack")
 (check-files "foo.hack" "testingFiles/two.hack"))
(test-case
 "(+ 3(- 5 2)"
 (compile '(+ 3(- 5 2)) "foo.hack")
 (check-files "foo.hack" "testingFiles/three.hack"))
(test-case
 "(- 3(+ 5 2)"
 (compile '(- 3(+ 5 2)) "foo.hack")
 (check-files "foo.hack" "testingFiles/four.hack"))
(test-case
 "(- 3(+ 5 2)"
 (compile '(- 3(+ 5 2)) "foo.hack")
 (check-files "foo.hack" "testingFiles/four.hack"))
(test-case
 "(+(+ 1 2)(- 4 3))"
 (compile '(+(+ 1 2)(- 4 3)) "foo.hack")
 (check-files "foo.hack" "testingFiles/five.hack"))
(test-case
 "(-(- 8 1)(+ 1 3))"
 (compile '(+(+ 1 2)(- 4 3)) "foo.hack")
 (check-files "foo.hack" "testingFiles/six.hack"))
(test-case
 "(+(+ 3 5) 5)"
 (compile '(+(+ 1 2)(- 4 3)) "foo.hack")
 (check-files "foo.hack" "testingFiles/seven.hack"))
(test-case
 "(+(- 3 1) 6))"
 (compile '(+(- 3 1)6) "foo.hack")
 (check-files "foo.hack" "testingFiles/eight.hack"))
(test-case
 "(-(- 4 2)1)"
 (compile '(-(-4 2)1) "foo.hack")
 (check-files "foo.hack" "testingFiles/nine.hack")))
