#lang scribble/manual
@(require scribble/core 
          scribble/bnf)

@title{Assembling to HACK Machine Code in Racket}
@author["Matthew C. Jadud"]

@table-of-contents[]

@; ------------------------------------------------------------------------
@include-section["overview.scrbl"]

@include-section["structures.scrbl"]
@include-section["read-file.scrbl"]
@include-section["parse.scrbl"]
@include-section["attach.scrbl"]
@include-section["table.scrbl"]