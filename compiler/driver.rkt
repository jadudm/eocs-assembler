#lang racket

(require "base.rkt"
         "helpers.rkt"
         "pass1.rkt"
         "pass2.rkt"
         "pass3.rkt"
         "../asm-interp/main.rkt"
         )

(provide driver)

(define (driver file)
  (let ([sexp (read (open-input-file file))]
        [file-base (second (regexp-match "(.*)\\.420" file))]
        )
    (let ([str (pass-to-asm (pass2 (pass1 sexp)))])
      (let ([op (open-output-file 
                 (string-append file-base ".hack")
                 #:exists 'replace
                 )])
        (fprintf op str)
        (newline op)
        (close-output-port op)
        ))))

    
