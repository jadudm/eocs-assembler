#lang scribble/doc
@(require 
  scribble/core
  scribble/manual 
  scribble/bnf
  "about-the-assembler.rkt")

@title[#:tag "read-file"]{Pass: Reading in Files}

The first pass of the assembler is provided to you. 
@tt{@pass1} takes in a filename and
returns a list of strings. Along the way, it strips three
things from the file:

@(itemize
  @item{Newline characters (@tt{\n})}
  @item{Carriage returns (@tt{\r})}
  @item{Java-style comments (anything including and following a @tt{//})}
  )

@section{@tt{@pass1}}

@#reader scribble/comment-reader
   (racketblock
;; CONTRACT
;; file->list-of-strings :: filename -> list-of strings
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
)

The complete source for this pass (including supporting code)
can be found in the file @tt{asm-file-to-list-of-strings.rkt}.