#lang racket

(require "base.rkt"
         "create_id_list.rkt"
         "remove-if.rkt"
         "remove_mult_div.rkt"
         "removewhile.rkt"
         "to_asm.rkt"
         "interp.rkt"
         ;;"../asm-interp/main.rkt"
         )

(provide driver)

(define (driver file)
  (let ([sexp (read (open-input-file file))]
        [file-base (second (regexp-match "(.*)\\.420" file))]
        )
    (let ([interim 0]
          [asm ""])
      (printf "parse~n")
      (set! interim (parse sexp))
      (show interim)
      
      (printf "remove mult~n")
      (set! interim (remove-mult interim))
      (show interim)
      
      (printf "remove while~n")
      (set! interim (removewhile interim))
      (show interim)
      
      (printf "remove if~n")
      (set! interim (removeif interim))
      (show interim)
      
      (printf "create-ids~n")
      (set! interim (create-ids interim))
      (show interim)
      (set! asm (pass-to-asm interim)) 
      (let ([op (open-output-file 
                 (string-append file-base ".hack")
                 #:exists 'replace
                 )])
        (fprintf op asm)
        (newline op)
        (close-output-port op)
        ))))

    
