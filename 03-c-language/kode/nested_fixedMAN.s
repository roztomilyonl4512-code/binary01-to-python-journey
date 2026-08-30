.global _start
.data
msg1:   .ascii "A: Memanggil B\n"
        .equ len1, . - msg1
msg2:   .ascii "B: Di dalam B\n"
        .equ len2, . - msg2
msg3:   .ascii "A: Kembali dari B, sekarang kembali ke start\n"
        .equ len3, . - msg3
.text
_start:

BL func_A
MOV x8, #93
MOV x0, #0
SVC #0 

func_A:
STP x29, x30, [sp, #-16]!
MOV x29,sp
LDR x1, =msg1
MOV x2, #len1
MOV x0, #1 
MOV x8, #64
SVC #0 

BL func_B
LDR x1, =msg3
MOV x2, #len3
MOV x0, #1 
MOV x8, #64 
SVC #0 

LDP x29, x30, [sp], #16 
RET

func_B:
STP x29, x30, [sp, #-16]!
MOV x29, sp
LDR x1, =msg2
MOV x2, #len2
MOV x0, #1 
MOV x8, #64 
SVC #0 

LDP x29, x30, [sp], #16 
RET

