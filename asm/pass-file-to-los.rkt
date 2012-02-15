#lang racket

(provide file->list-of-strings)

;; CONTRACT
;; strip :: string -> string
;; PURPOSE
;; Strips newlines, carriage returns, and Java-style comments
;; from a string, returning the string afterwards.
(define (strip line)
  (for-each (λ (pat)
              (set! line (regexp-replace* pat line "")))
            (list "\n" "\r" " " "//.*"))
  line)

;; CONTRACT
;; file->list-reader :: input-port -> list-of strings
;; PURPOSE
;; Takes an input port and reads all of the contents
;; into a list of strings, stripping:
;;  * newlines
;;  * carriage returns
;;  * Java-style comments
;; in the process.
(define (file->list-reader ip)
  (let ([line (read-line ip)])
    (cond
      [(eof-object? line) '()]
      [else
       (cons (strip line) (file->list-reader ip))])))

;; CONTRACT
;; file->list :: filename -> list-of strings
;; PURPOSE
;; Takes a filename and returns a list of strings 
;; from that file.
(define (file->list-of-strings fname)
  (if (regexp-match "\\.asm$" fname)
      (let* ([file (open-input-file fname)]
             [contents (file->list-reader file)])
        (close-input-port file)
        contents)
      (error "Input filename must end in .asm")))