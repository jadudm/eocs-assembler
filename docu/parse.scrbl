#lang scribble/doc
@(require 
  scribble/core
  scribble/manual 
  scribble/bnf
  "about-the-assembler.rkt")

@title[#:tag "parse"]{Pass: Parsing data}

The first thing we need to do in our assembler is transform 
our list of strings into a list of data structures. The strings
in our files take one of several forms:

@(itemize
  @item{dest=comp;jump}
  @item{comp;jump}
  @item{dest=comp}
  @item{@@"@"number}
  @item{@@"@"symbol}
  @item{(label)}
  )

In each case, we need to convert these into the appropriate data structure:

@(itemize
  @item{The first three become C instructions (substituting @tt{'no-dest}, @tt{'no-comp},
@tt{'no-jump} where there are no destinations, computations, or jumps specified).}
  @item{The next two become A instructions; the fact that some are numeric and some are
        symbolic does not matter to us at this point. We will treat them the same
        at this point, and differentiate them in later passes.}
  @item{Labels will be read in as @tt{label} structures; we'll drop the parens in parsing, and just
        store the contents of the parentheses in a @tt{label} structure.}
  )

In addition, you need to handle blank lines. When you find one, return @tt{'blank-line}.
We will filter this symbol out of our instruction stream in a later pass.
                                                                
         
@section{Writing the parser}
The module @tt{asm-pass-parse.rkt} exports one function, @tt{parse}. 
This code is provided for you.


@#reader scribble/comment-reader
(racketblock
;; CONTRACT
;; parse :: list-of strings -> list-of ASM structures
;; PURPOSE
;; Takes in a list of strings and returns a list
;; of ASM structures (and a symbol or two).
(define (parse los)
  (cond
    [(empty? los) '()]
    [else
     (cons (parse-one-line (first los))
           (parse (rest los)))]))
)

Your task is to write the function @tt{parse-one-line}. This function
takes in a single string, and returns a parsed version of that string.
You can use @tt{match} or @tt{cond} to structure this function; because
our assembly is a very simple language, we can use regular expressions
to match each case. You should have 8 cases in your parser---one for
labels, three for C instructions, two for A instructions, and one 
to handle blank lines.

@section{Starter Code}

The following code is provided to get you started (if you choose to use it).

@#reader scribble/comment-reader
(racketblock
;; CONTRACT
;; parse-one-line :: string -> (U A? C? label? symbol?)
;; PURPOSE
;; Parses a string representing a single assembly
;; language instruction.
(define (parse-one-line asm)
  (match asm
    [(regexp "^\\s*$")
     'blank-line]
    [else (error 'parse "NO MATCH: ~a" asm)]))
)

@section{Testing your Parser}
The file @tt{test-