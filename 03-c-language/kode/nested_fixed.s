.global _start
.data
msg1:   .ascii "A: Memanggil B\n"
        .equ len1, . - msg1
msg2:   .ascii "B: Di dalam B\n"
        .equ len2, . - msg2
msg3:   .ascii "A: kembali dari B, sekarang kembali ke start\n"
        .equ len3, . - msg3
.text
_start:

BL func_A //[x30] diisi alamat MOV x8, #93
MOV x8, #93
MOV x0, #0 
SVC #0 

//================================
//FUNGSI A (DENGAN PROLOG/EPILOG)
//================================
func_A:
//===== PROLOG =====
STP x29, x30, [sp, #-16]! //simpan alamat kembali (x30)ke stack
MOV x29, sp //frame point baru

//cetak "A: Memanggil B"
LDR x1, =msg1
LDR x2, =len1
LDR x2, [x2]
MOV x0, #1 
MOV x8, #64
SVC #0

//================================
//FUNGSI B (BL KEDUA MENIMPA x30)
//================================
BL func_B //x30 tertimpa, tetapi x30 asli sudah tersimpan di stack
//cetak "A: kembali dari B, sekarang kembali ke start\n"

LDR x1, =msg3
LDR x2, =len3
LDR x2, [x2]
MOV x0, #1 
MOV x8, #64
SVC #0

//===== EPILOG =====
LDP x29, x30, [sp], #16 // Mengembalikan x30 asli dari stack
RET //Kembali ke start dengan selamat

//================================
//FUNGSI B (BL KEDUA MENIMPA x30)
//================================

func_B:
//===== PROLOG =====
STP x29, x30, [sp, #-16]!
MOV x29, sp

//Cetak "B: Di dalam B\n"
LDR x1, =msg2
LDR x2, =len2
LDR x2, [x2]
MOV x0, #1 
MOV x8, #64
SVC #0 

//===== EPILOG =====
LDP x29, x30, [sp], #16 
RET //Kembali ke func_A (tepat setelah BL func_B)
