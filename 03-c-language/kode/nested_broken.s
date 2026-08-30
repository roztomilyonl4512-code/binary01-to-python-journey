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
    // ============================================
    // 1. PANGGIL FUNGSI A (BL)
    // ============================================
    BL func_A               // [X30] diisi alamat instruksi berikutnya (MOV X8, #93)
    
    // ============================================
    // 2. JIKA KEMBALI DENGAN SELAMAT, EXIT
    // ============================================
    MOV X8, #93             // Exit syscall
    MOV X0, #0
    SVC #0

// ============================================
// FUNGSI A (TANPA PROLOG)
// ============================================
func_A:
    // Cetak "A: Memanggil B"
    LDR X1, =msg1
    LDR X2, =len1
    LDR X2, [X2]
    MOV X0, #1
    MOV X8, #64
    SVC #0

    // ============================================
    // PANGGIL FUNGSI B (BL KEDUA - MENIMPA X30!)
    // ============================================
    BL func_B               // [X30] DITIMPA dengan alamat instruksi berikutnya (LDR X1, =msg3)

    // Cetak "A: Kembali dari B, sekarang kembali ke Start"
    LDR X1, =msg3
    LDR X2, =len3
    LDR X2, [X2]
    MOV X0, #1
    MOV X8, #64
    SVC #0

    // ============================================
    // RET (KEMBALI KE PEMANGGIL)
    // ============================================
    RET                     // ❌ X30 masih berisi alamat setelah BL func_B (bukan alamat di _start)
                            //    Akibatnya: program melompat ke LDR X1, =msg3 lagi (infinite loop)

// ============================================
// FUNGSI B (LEAF - TIDAK MEMANGGIL FUNGSI LAIN)
// ============================================
func_B:
    // Cetak "B: Di dalam B"
    LDR X1, =msg2
    LDR X2, =len2
    LDR X2, [X2]
    MOV X0, #1
    MOV X8, #64
    SVC #0

    RET                     // Kembali ke func_A (tepat setelah BL func_B)
