#lang scribble/doc
@(require 
  scribble/core
  scribble/manual 
  scribble/bnf
  "about-the-assembler.rkt")

@title[#:tag "underlying"]{Underlying Structures}

The HACK assembler contains four data structures.

@section{A-instructions}

@racketblock[
(struct A (line value) 
  #:inspector (make-inspector))
]

The @tt{A} structure will represent our A-instructions, and contains two fields: @tt{line}, which will hold the line number of this instruction in the final HACK output, and and @tt{value}, a number or symbol.

@section{C-instructions}

@racketblock[
(struct C (line dest comp jump)
  #:inspector (make-inspector))
]

The @tt{C} structure will represent our C-instructions, and contains four fields: @tt{line}, which will hold the line number of this instruction in the final HACK output, @tt{dest}, which holds a symbol representing the destination for this instruction (or @racket['no-dest] if there is no dest field in this instruction), @tt{comp}, which holds the computation part of our assembly instruction (or @racket{'no-comp}), and @tt{jump}, which holds the symbol representing what jump we should make (or @racket{'no-jump}) after carrying out our computation.

@section{Labels}

@racketblock[
(struct label (line name) 
  #:inspector (make-inspector))
]

The @tt{label} structure has two fields: @tt{line}, which holds the line number this label represents in the final HACK output, and @tt{name}, the name of the label.

@section{Comments}

@racketblock[
(struct comment (text) 
  #:inspector (make-inspector))
]

The @tt{comment} structure has one field, @tt{text}, which holds the text of a comment. We will probably strip and ignore comments in our assembler, as our system is not complex enough to warrant holding onto them.