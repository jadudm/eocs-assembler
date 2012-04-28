#lang racket
(require "interp.rkt" "asm-emulate.rkt" "driver.rkt")

(define (all-three file)
  
  (reset-env)
  (let* ([ip (open-input-file file)]
         [sexp (read ip)])
    (close-input-port ip)
    (printf "=== INTERP ===~n~a~n~n" (interp (parse sexp))))
  (printf "=== DRIVER ===~n")
  (driver file)
  (printf "===ASM===~n")
  (printf "~n===RESULT===~n~a~n~n"
          (emulate (regexp-replace "420" file "hack"))))
