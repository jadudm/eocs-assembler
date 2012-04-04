#lang racket

;(require "base.rkt")
(require "pass3.rkt")

(require rackunit)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; some basic smoke tests
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; empty test
(check-equal? (pass-to-asm (list empty))
              "(END)\n@END\n0;JMP")

;;single id w/o simple

(check-equal? (pass-to-asm (cons (id 'v1 5) empty)) 
              (string-append "@5\n"
                             "D=A\n"
                             "@v1\n"
                             "M=D\n"
                             "(END)\n"
                             "@END\n"
                             "0;JMP"))
(check-equal? (pass-to-asm (cons (id 'asdf 1) empty)) 
               (string-append"@1\n"
                             "D=A\n"
                             "@asdf\n"
                             "M=D\n"
                             "(END)\n"
                             "@END\n"
                             "0;JMP"))

;;list of ids w/o simple 

(check-equal? (pass-to-asm (cons (id 'v1 5) (id 'v2 5))) 
               (string-append "@5\n"
                              "D=A\n"
                              "@v1\n"
                              "M=D\n"
                              "@5\n"
                              "D=A\n"
                              "@v2\n"
                              "M=D\n"
                              "(END)\n"
                              "@END\n"
                              "0;JMP"))

(check-equal? (pass-to-asm (cons (id 'asdf 20) (id 'qwer 10) (id 'v1 5) (id 'v2 4))) 
              (string-append "@20\n"
                             "D=A\n"
                             "@asdf\n"
                             "M=D\n"
                             "@10\n"
                             "D=A\n"
                             "@qwer\n"
                             "M=D\n"
                             "@5\n"
                             "D=A\n"
                             "@v1\n"
                             "M=D\n"
                             "@2\n"
                             "D=A\n"
                             "@v2\n"
                             "M=D\n"
                             "(END)\n"
                             "@END\n"
                             "0;JMP"))

              

;;single id w/ (binop sym sym) 
(check-equal? (pass-to-asm (cons (id 'b5b (binop '+ 'asdf 'qwerty)) empty)) 
              (string-append "@asdf\n"
                             "D=M\n"
                             "@qwerty\n"
                             "A=M\n"
                             "D=D+A\n"
                             "@b5b\n"
                             "M=D\n"
                             "(END)\n"
                             "@END\n"
                             "0;JMP"))

(check-equal? (pass-to-asm (cons (id 'v1 (binop '+ 'v2 'v3)) empty)) 
              (string-append "@v2\n"
                             "D=M\n"
                             "@v3\n"
                             "A=M\n"
                             "D=D+A\n"
                             "@v1\n"
                             "M=D\n"
                             "(END)\n"
                             "@END\n"
                             "0;JMP"))

;;;;;;;;;;;;;;;;;;;;;;;;;;
; bigger test 
; (sould add more later)
;;;;;;;;;;;;;;;;;;;;;;;;;;
(check-equal? (pass-to-asm (cons 
                            (id 'asdf 6)
                            (id 'v1  10)
                            (id  'v2 1)
                            (id 'v3 (binop '+ 'v2 'asdf ))
                            (id 'qwerty (binop '- 'v1 'v3 ))
                            (id 'v5 (binop '+ 'asdf 'qwerty))))
              (string-append "@6\n"
                             "D=A\n"
                             "@asdf\n"
                             "M=D\n"
                             "@10\n"
                             "D=A\n"
                             "@v1\n"
                             "M=D\n"
                             "@1\n"
                             "D=A\n"
                             "@v2\n"
                             "M=D\n"     
                             "@v2\n"
                             "D=M\n"
                             "@asdf\n"
                             "A=M\n"
                             "D=D+A\n"
                             "@v3\n"
                             "M=D\n"     
                             "@v1\n"
                             "D=M\n"
                             "@v3\n"
                             "A=M\n"
                             "D=D-A\n"
                             "@qwerty\n"
                             "M=D\n" 
                             "@asdf\n"
                             "D=M\n"
                             "@qwerty\n"
                             "A=M\n"
                             "D=D-A\n"
                             "@v5\n"
                             "M=D\n"  
                             "(END)\n"
                             "@END\n"
                             "0;JMP"))