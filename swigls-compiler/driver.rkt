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
      (set! interim (parse sexp))
      (set! interim (remove-mult interim))
      (set! interim (removewhile interim))
      (set! interim (removeif interim))
      (set! interim (create-ids interim))
      (set! asm (pass-to-asm interim)) 
      (let ([op (open-output-file 
                 (string-append file-base ".hack")
                 #:exists 'replace
                 )])
        (fprintf op asm)
        (newline op)
        (close-output-port op)
        ))))

    
