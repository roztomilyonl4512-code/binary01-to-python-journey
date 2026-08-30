.global _start
_start:

MOV x0, #12 //salin angka 2 di register x0
MOV x1, #4 
ADD x0, x0, x1

MOV x10, #10 

UDIV x11, x0, x10
MSUB x12, x11, x10, x0

ADD x11, x11, #48 
ADD x12, x12, #48

SUB sp, sp, #16
STRB w11, [sp]
STRB w12, [sp, #1]

MOV x9, #10 // 10 adalah kode ASCII untuk newline (\n)
STRB w9, [sp, #2]   // Simpan newline di slot ke-3 (offset 2)

MOV x0, #1 
MOV x1, sp
MOV x2, #3 
MOV x8, #64
SVC #0 

MOV x8, #93
MOV x0, #0 
SVC #0
