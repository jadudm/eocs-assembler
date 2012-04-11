#lang racket

;; CONTRACT
;; snoc :: any ls -> ls
;; PURPOSE
;; Adds to the end of a list.
;; The opposite of cons.
(define (snoc o ls)
  (append ls (list o)))

;; CONTRACT
;; file->list :: string -> list
;; PURPOSE
;; Reads a file to a list of strings.
(define (file->list filename)
  (let ([ls '()]
        [ip (open-input-file filename)]
        )
    (let loop ([line (read-line ip)])
      (unless (eof-object? line)
        (set! ls (snoc line ls))
        (loop (read-line ip))))
    ls))
