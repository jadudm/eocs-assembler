#lang racket

;;Hand tests for swigls-compiler

(require rackunit
         "base.rkt"
         "driver.rkt"
         "../asm-interp/main.rkt")

(define-check (check-files f1 f2)
  (check-equal?
   (file->list f1)
   (file->list f2)))

(test-suite
 "hand-written tests for CS420"
 (test-case
  "(+ 3 5)"
  (driver "expressions/one.420")
  (emulate "expressions/one.hack")
  (check-files "expressions/one.hack" "assemblyFiles/one.hack"))
 (test-case
  "(- 9 1)"
  (driver "expressions/two.420")
  (emulate "expressions/two.hack")
  (check-files "expressions/two.hack" "assemblyFiles/two.hack"))
 (test-case
  "(+ 3(- 5 2)"
  (driver "expressions/three.420")
  (emulate "expressions/three.hack")
  (check-files "expressions/three.hack" "assemblyFiles/three.hack"))
 (test-case
  "(- 3(+ 5 2)"
  (driver "expressions/four.420")
  (emulate "expressions/four.hack")
  (check-files "expressions/four.hack" "assemblyFiles/four.hack"))
 (test-case
  "(+(+ 1 2)(- 4 3))"
  (driver "expressions/five.420")
  (emulate "expressions/five.hack")
  (check-files "expressions/five.hack" "assemblyFiles/five.hack"))
 (test-case
  "(-(- 8 1)(+ 1 3))"
  (driver "expressions/six.420")
  (emulate "expressions/six.hack")
  (check-files "expressions/six.hack" "assemblyFiles/six.hack"))
 (test-case
  "(+(+ 3 5) 5)"
  (driver "expressions/seven.420")
  (emulate "expressions/seven.hack")
  (check-files "expressions/seven.hack" "assemblyFiles/seven.hack"))
 (test-case
  "(+(- 3 1) 6))"
  (driver "expressions/eight.420")
  (emulate "expressions/eight.hack")
  (check-files "expressions/eight.hack" "assemblyFiles/eight.hack"))
 (test-case
  "(-(- 4 2)1)"
  (driver "expressions/nine.420")
  (emulate "expressions/nine.hack")
  (check-files "expressions/nine.hack" "assemblyFiles/nine.hack"))
 (test-case
  "(* 4 2)"
  (driver "expressions/ten.420")
  (emulate "expressions/ten.hack")
  (check-files "expressions/ten.hack" "assemblyFiles/ten.hack"))
 (test-case
  "(* 5 3)"
  (driver "expressions/eleven.420")
  (emulate "expressions/eleven.hack")
  (check-files "expressions/eleven.hack" "assemblyFiles/eleven.hack")))


