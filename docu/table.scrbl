#lang scribble/doc
@(require 
  scribble/core
  scribble/manual 
  scribble/bnf
  "about-the-assembler.rkt")

@title[#:tag "table"]{Pass: Populating the symbol table}

The symbol table is where all of the magic in our assembler happens. It takes all of the variables
(symbols) in our instruction stream, and replaces them with actual memory addresses. For example,
if we have a piece of code like the following:

@verbatim|{
           @5
           D=A
           @i
           M=D
           (INIFITE_LOOP)
           @INFINITE_LOOP
           0;JMP
           }|

the assembler will go through and replace all of the symbols with addresses in RAM:

@verbatim|{
           @5
           D=A
           @16
           M=D
           @4
           0;JMP
           }|

The symbol @tt{i} was given the address @tt{16}, and the label @tt{INFINITE_LOOP} was given the 
address @tt{4}. The assignment of addresses takes place in the pass @tt{add-memory-addresses-to-table},
and the assignemnt of label locations takes place in the pass @tt{add-labels-to-table}.


@section{@tt{add-labels-to-table}}

Each label has a location in the instruction stream. Whenever an @tt{A} instruction refers
to a label, we need to replace that label reference with the address of the label.

To do this, we first have to go through and insert each label into the symbol table. For example, 
consider the following block of assembly (similar to the one from the previous section):

@(racketblock
  (list
   (label 0 'label0)
   (C 0 'D1 'C2 'J3)
   (A 1 0)
   (label 2 'label4)
   (label 2 'label5)
   (label 2 'label6)
   (label 2 'label7)
   (label 2 'label8)
   (C 2 'D9 'C10 'J11)
   (C 3 'D12 'C13 'J14)
   (A 4 'next)
   (C 5 'D15 'C16 'J17)
   (C 6 'D18 'C19 'J20)
   (A 7 'label5)
   (C 8 'D21 'C22 'J23)
   (A 9 22)
   (C 10 'D24 'C25 'J26)))

There are six labels: @tt{label0}, @tt{label4}, @tt{label5}, @tt{label6}, @tt{label7}, and @tt{label8}.
Each of these carry with them their current address in ROM. For example, @tt{label0} is pointing to
address zero in ROM, and hence its address field is correct (from previous passes). We need to 
find each label instruction and insert the label name and ROM address into the table.

When we are done, the symbol table should look like this

@verbatim|{
   #hash((label0 0)
         (label4 2)
         (label5 2)
         (label6 2)
         (label7 2)
         (label8 2)
         )}|

@section{@tt{add-memory-addresses-to-table}}

Assume we have a list of instructions like the following:

@(racketblock
  (list
   (label 0 'label0)
   (C 0 'D1 'C2 'J3)
   (A 1 0)
   (label 2 'label4)
   (label 2 'label5)
   (label 2 'label6)
   (label 2 'label7)
   (label 2 'label8)
   (C 2 'D9 'C10 'J11)
   (C 3 'D12 'C13 'J14)
   (A 4 'next)
   (C 5 'D15 'C16 'J17)
   (C 6 'D18 'C19 'J20)
   (A 7 'label5)
   (C 8 'D21 'C22 'J23)
   (A 9 22)
   (C 10 'D24 'C25 'J26)))

There are an assortment of @tt{labels}, @tt{C} instructions, and @tt{A} instructions. 
There is one symbolic @tt{A} instruction in this stream: @(racket (A 4 'next)).
When we find the symbolic reference, we should insert it into the symbol table.
By default, we start numbering symbolic references at memory address 16; this way,
we do not interfere with the locations of registers R0 through R15 (which live at 
locations 0 through 15).

After running the pass @tt{add-memory-addresses-to-table}, we should end up
with the same instruction stream, but the symbol table should look like this:

@verbatim|{
   #hash((label0 0)
         (label4 2)
         (label5 2)
         (label6 2)
         (label7 2)
         (label8 2)
         (next 16)
         )}|

The ordering in the symbol table does not matter; we are not guaranteed
any particular order when we use a hash table in this way. However, we should
still have all of the label addresses and, when we're done with this pass,
all of the symbolic references should be assigned addresses as well.

When we're done, we should still have the same instruction stream that we
started with. The next pass will go through the stream, removing instructions,
and inserting actual values for addresses as appropriate.

@section{@tt{rewrite-with-addresses}}

Before writing out the contents of the assembly, we rewrite the instruction stream
using the addresses we have inserted into the instruction table.

@(itemize
  @item{If we encounter a label, we should simply ignore it. Or, if you prefer, it should
        be removed from the instruction stream. We no longer need the label
        instructions.}
  @item{If we find a symbolic @tt{A} instruction, we should look it up in the symbol table, and
                      replace the symbolic form with an actual memory address.}
  @item{Any other instruction should be left as-is.})

Our example stream from the previous section currently looks like this:


@(racketblock
  (list
   (label 0 'label0)
   (C 0 'D1 'C2 'J3)
   (A 1 0)
   (label 2 'label4)
   (label 2 'label5)
   (label 2 'label6)
   (label 2 'label7)
   (label 2 'label8)
   (C 2 'D9 'C10 'J11)
   (C 3 'D12 'C13 'J14)
   (A 4 'next)
   (C 5 'D15 'C16 'J17)
   (C 6 'D18 'C19 'J20)
   (A 7 'label5)
   (C 8 'D21 'C22 'J23)
   (A 9 22)
   (C 10 'D24 'C25 'J26)))

When we are done with the pass @tt{rewrite-with-addresses}, it should look like this:


@(racketblock
  (list
   (C 0 'D1 'C2 'J3)
   (A 1 0)
   (C 2 'D9 'C10 'J11)
   (C 3 'D12 'C13 'J14)
   (A 4 16)
   (C 5 'D15 'C16 'J17)
   (C 6 'D18 'C19 'J20)
   (A 7 2)
   (C 8 'D21 'C22 'J23)
   (A 9 22)
   (C 10 'D24 'C25 'J26)))

At this point, labels have been removed, the reference to @tt{label5} has been resolved to ROM location 2, and 
the reference to the symbol @tt{next} has been resolved to RAM address 16.

We are now ready to emit binary machine code.