#lang racket

;;Hand tests for swigls-compiler

(require rackunit
         "base.rkt")

(define-check (check-files f1 f2)
  (check-equal?
   (file->list f1)
   (file->list f2)))

(test-suite
 "hand-written tests for CS420"
 (test-case
  "(+ 3 5)"
  (swigls '(+ 3 5) "foo.hack")
  (check-files "foo.hack" "testingFiles/one.hack"))
(test-case
 "(- 9 1)"
 (swigls '(- 9 1) "foo.hack")
 (check-files "foo.hack" "testingFiles/two.hack"))
(test-case
 "(* 4 2)"
 (swigls '(* 4 2) "foo.hack")
 (check-files "foo.hack" "testingFiles/ten.hack"))
 "(* 5 3)"
 (swigls '(* 5 3) "foo.hack")
 (check-files "foo.hack" "testingFiles/eleven.hack"))
(test-case
 "(+ 3(- 5 2)"
 (swigls '(+ 3(- 5 2)) "foo.hack")
 (check-files "foo.hack" "testingFiles/three.hack"))
(test-case
 "(- 3(+ 5 2)"
 (swigls '(- 3(+ 5 2)) "foo.hack")
 (check-files "foo.hack" "testingFiles/four.hack"))
(test-case
 "(+(+ 1 2)(- 4 3))"
 (swigls '(+(+ 1 2)(- 4 3)) "foo.hack")
 (check-files "foo.hack" "testingFiles/five.hack"))
(test-case
 "(-(- 8 1)(+ 1 3))"
 (swigls '(+(+ 1 2)(- 4 3)) "foo.hack")
 (check-files "foo.hack" "testingFiles/six.hack"))
(test-case
 "(+(+ 3 5) 5)"
 (swigls '(+(+ 1 2)(- 4 3)) "foo.hack")
 (check-files "foo.hack" "testingFiles/seven.hack"))
(test-case
 "(+(- 3 1) 6))"
 (swigls '(+(- 3 1)6) "foo.hack")
 (check-files "foo.hack" "testingFiles/eight.hack"))
(test-case
 "(-(- 4 2)1)"
 (swigls '(-(-4 2)1) "foo.hack")
 (check-files "foo.hack" "testingFiles/nine.hack")))

