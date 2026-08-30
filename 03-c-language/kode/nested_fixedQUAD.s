.global _start
.data
msg1:   .ascii "A: Memanggil B\n"
len1:   .quad 14
msg2:   .ascii "B: Di dalam B\n"
len2:   .quad 14
msg3:   .ascii "A: Kembali dari B, sekarang kembali ke Start\n"
len3:   .quad 43

.text
_start:
    BL func_A
    MOV X8, #93
    MOV X0, #0
    SVC #0

func_A:
    STP X29, X30, [SP, #-16]!
    MOV X29, SP

    LDR X1, =msg1
    LDR X2, =len1
    LDR X2, [X2]
    MOV X0, #1
    MOV X8, #64
    SVC #0

    BL func_B

    LDR X1, =msg3
    LDR X2, =len3
    LDR X2, [X2]
    MOV X0, #1
    MOV X8, #64
    SVC #0

    LDP X29, X30, [SP], #16
    RET

func_B:
    STP X29, X30, [SP, #-16]!
    MOV X29, SP

    LDR X1, =msg2
    LDR X2, =len2
    LDR X2, [X2]
    MOV X0, #1
    MOV X8, #64
    SVC #0

    LDP X29, X30, [SP], #16
    RET
