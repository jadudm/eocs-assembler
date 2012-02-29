#lang scribble/doc
@(require 
  scribble/core
  scribble/manual 
  scribble/bnf
  "about-the-assembler.rkt")

@title[#:tag "attach"]{Pass: Attaching Instruction Addresses}

The next step in our assembler is to attach instruction addresses (which are also referred to as "locations," as they are locations in memory) to each instruction. There are four functions that need to be implemented to complete this:

@(itemize
  @item{@tt{attach-to-a}}
  @item{@tt{attach-to-c}}
  @item{@tt{attach-to-label}}
  @item{@tt{attach-instruction-locations}}
  )

We'll say a few words about each.

@section{@tt{attach-to-*}}
The @tt{attach-to-...} functions are very straight forward. Each consumes a structure of the given type and an address, and returns a structure of the given type. The structure returned should contain the address given.

For example, if we were to call

@(racketblock
  (attach-to-a (A 'no-line 'i) 42))

we would expect to get back

@(racketblock
  (A 42 'i))

Implementing these helpers first will allow you to run unit tests that check that you have "done the right thing." They will also simplify (trivialize?) the implementation of the list processing function, as the work of the function (save for traversing the list) will be already taken care of.

@section{@tt{attach-instruction-locations}}

The function @tt{attach-instruction-locations} takes in a list of instructions, and returns the same list of instructions, but their locations added starting at zero. (Some embedded systems might have a bootloader that lives at address zero, with user code starting at byte location 512 (or 1024, or somewhere else entirely. This is, for example, the case with the Arduino.)

When running the unit tests, the input to your function will look like this:

@(racketblock
  (list
   (label -1 'label0)
   (C -1 'D1 'C2 'J3)
   (A -1 0)
   (label -1 'label4)
   (label -1 'label5)
   (label -1 'label6)
   (label -1 'label7)
   (label -1 'label8)
   (C -1 'D9 'C10 'J11)
   (C -1 'D12 'C13 'J14)
   (C -1 'D15 'C16 'J17)
   (C -1 'D18 'C19 'J20)
   (A -1 'label5)
   (C -1 'D21 'C22 'J23)
   (A -1 22)
   (C -1 'D24 'C25 'J26)))

It should come out of your function looking like this:

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
   (C 4 'D15 'C16 'J17)
   (C 5 'D18 'C19 'J20)
   (A 6 'label5)
   (C 7 'D21 'C22 'J23)
   (A 8 22)
   (C 9 'D24 'C25 'J26)))

