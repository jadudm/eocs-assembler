#lang racket

(require 
 ;; Data structures
 "asm-base.rkt"
 ;; Helper functions
 "asm-support.rkt"
 ;; PASSES
 ;; Read the file to a list of strings
 "pass-file-to-los.rkt"
 ;; Parsing from strings to structures
 "pass-parse.rkt"
 ;; Annotating instructions with addresses
 "pass-attach-instruction-locations.rkt"
 ;; Building the symbol table and resolving
 ;; addresses in the instruction stream
 "pass-symbol-table.rkt"
 ;; Output
 "pass-to-binary.rkt"
 "pass-write-file.rkt"
 ;; For pretty printing.
 racket/pretty)

(define (driver file)
  (each 
   ;; First convert to a list of strings
   [list-of-strings (file->list-of-strings file)]
   ;; Then parse
   [parsed (parse list-of-strings)]
   ;; Now, attach instruction locations
   [numbered (attach-instruction-locations parsed 0)]
   ;; Init table
   [x (init-symbol-table)]
   ;; Add labels
   [x1 (add-labels-to-table numbered)]
   ;; Add memory locations
   [assigned (add-memory-addresses-to-table numbered)]
   ;; Assign addresses to everything
   [no-labels (rewrite-with-addresses assigned)]
   ;; Convert structures to binary
   [zeroones (map structure->binary no-labels)]
   ;; Write the file
   [x3 (write-file! file zeroones)]
   [final numbered]))
