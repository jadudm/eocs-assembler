#lang racket
(require "interp.rkt" "asm-emulate.rkt" "driver.rkt")

(define noisy?
  (file-exists? "NOISY"))

(define (all-three file)
  (let ([interp-result 0]
        [emulation-result 0])
    (reset-env)
    (let* ([ip (open-input-file file)]
           [sexp (read ip)])
      (close-input-port ip)
      (set! interp-result (interp (parse sexp)))
      (printf "=== INTERP ===~n~a~n~n" interp-result))
    (printf "=== DRIVER ===~n")
    (driver file)
    (printf "===ASM===~n")
    (set! emulation-result (emulate (regexp-replace "420" file "hack") noisy?))
    (printf "~n===EMULATION RESULT===~n~a~n~n" emulation-result)
    (if (= interp-result emulation-result)
        (printf "RESULTS EQUAL~n")
        (printf "BAD! RESULTS NOT EQUAL!~n"))
    ))
