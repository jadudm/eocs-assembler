#lang scribble/doc
@(require 
  scribble/core
  scribble/manual 
  scribble/bnf
  "about-the-assembler.rkt")

@title[#:tag "overview"]{Overview}

In working with Elements of Computing Systems, we have been working our way 
backward through the compiler. We began with NAND, built the basic (combinatorial)
logic gates, and used these to specify the ALU. From there, we took the 
DFF as a given, and used it to build a Bit, the Register, and finally an assortment
of RAMs. At the time that we built them, we neither understood the role of the ng and zr lines 
on the ALU, nor did we understand how they related to the PC, or program counter. 

Now, having built a complete CPU, the machine language (HACK) is becoming clear. 
The @bold{A-instruction} allows us to specify constants, which load values into the
@emph{accumulator} in our CPU design. 

@(centered
  (image "images/a-inst-layout.png" #:scale .7))

The @bold{C-instruction} does all of the work in our CPU; it specifies the 
computations we should carry out, the sources for the input to those
computations, and where the results should be stored. 

@(centered
  (image "images/c-inst-layout.png" #:scale .7))

Having built the CPU, the next step (as we work our way up the chain) is to
build an assembler for the ASM of this machine, and output the binary
machine code that drives our CPU. 

@element["newpage" ""] 

@section{An Assembler in @number-of-passes passes}

Our assembler will do its work in @number-of-passes passes. 

@(itemize
  @item{@tt{@pass1} reads in an ASM file and converts it to a list of strings.}
  @item{@tt{@pass2} transforms the ASM instructions into data structures (an AST, or @emph{abstract syntax tree}).}
  @item{@tt{attach-instruction-locations} attaches lines numbers to each structure in the AST.}
  @item{@tt{add-labels-to-table} finds each label and adds it to a table.}
  @item{@tt{add-memory-addresses-to-table} finds the remaining symbolic references and extends the table with an address in RAM for each.}
  @item{@tt{assign-addresses} walks through the AST and replaces all symbolic A-instructions with constants, using the table built with @tt{add-labels-to-table} and @tt{add-memory-addresses-to-table}.}
  @item{@tt{remove-labels} goes through the table and removes the @tt{label} structures that are no longer needed.}
  @item{@tt{structure->binary} transforms each data structure in the AST into a string of zeros and ones of length 16.}
  @item{@tt{write-file!} outputs a file with a @tt{.hack} extension, where each line in the file is sixteen zeros and ones---a HACK machine language instruction.}
  )

We begin with an overview of the structures used to construct the AST 
(which, in an assembler, looks less like a tree and more like a list)
and the "dirver," which runs each pass in sequence.
The next @number-of-passes sections detail the construction 
of each of these passes, followed by an appendix regarding 
the support code provided for authoring the assembler.
