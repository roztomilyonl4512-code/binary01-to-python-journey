.global _start
.data
msg1:   .ascii "A: Memanggil B\n"
        .equ len1, . - msg1
msg2:   .ascii "B: Di dalam B\n"
        .equ len2, . - msg2
msg3:   .ascii "A: Kembali dari B, sekarang kembali ke Start\n"
        .equ len3, . - msg3

.text
_start:
    BL func_A
    MOV X8, #93
    MOV X0, #0
    SVC #0

func_A:
    STP X29, X30, [SP, #-16]!
    MOV X29, SP

    // Cetak msg1
    LDR X1, =msg1
    MOV X2, #len1          // <- langsung pakai MOV, bukan LDR
    MOV X0, #1
    MOV X8, #64
    SVC #0

    BL func_B

    // Cetak msg3
    LDR X1, =msg3
    MOV X2, #len3          // <- langsung pakai MOV
    MOV X0, #1
    MOV X8, #64
    SVC #0

    LDP X29, X30, [SP], #16
    RET

func_B:
    STP X29, X30, [SP, #-16]!
    MOV X29, SP

    LDR X1, =msg2
    MOV X2, #len2          // <- langsung pakai MOV
    MOV X0, #1
    MOV X8, #64
    SVC #0

    LDP X29, X30, [SP], #16
    RET
