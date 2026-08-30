.global _start

.data
// Kombinasi Tipe Data Integer (.quad = 8 bytes) dan String (.ascii)
status_code:    .quad 12                    // Integer: 0 berarti OK
msg_ok:         .ascii "STATUS: OK - SYSTEM SECURE\n"
msg_err:        .ascii "STATUS: ERROR DETECTED!\n"

.text
_start:
    // 1. LDR: Memuat nilai integer status_code ke register x0
    ldr x10, =status_code
    ldr x0, [x10]               // x0 sekarang berisi angka 0

    // 2. STR & LDR: Menyimpan status ke Stack untuk diamankan, lalu load string OK
    sub sp, sp, #16             // Alokasi stack frame
    str x0, [sp]                // STR: Simpan integer status ke stack

    // 3. CBZ: Cek apakah nilai integer di x0 adalah 0
    cbz x0, handler_success     // Jika x0 == 0, lompat langsung ke handler_success

    // Jika bukan nol (Error path)
    ldr x1, =msg_err
    mov x2, #23                 // Panjang string error
    b execute_print             // B: Lompat ke jalur cetak

handler_success:
    // Jalur sukses
    ldr x1, =msg_ok
    mov x2, #27                 // Panjang string OK

execute_print:
    // 4. BL (Branch with Link): Memanggil fungsi cetak (subrutin)
    // Alamat pulang disimpan otomatis di x30 (LR)
    bl print_to_stdout

    // 5. Cleanup stack dan keluar program (Sys_exit)
    add sp, sp, #16
    mov x8, #93                 // Sys_exit number untuk ARM64
    mov x0, #0                  // Exit code 0
    svc #0

// --- SUBROUTINE / FUNGSI TERPISAH ---
print_to_stdout:
    // Fungsi ini menerima argumen: x1 = alamat string, x2 = panjang string
    mov x0, #1                  // File descriptor 1 = stdout (layar)
    mov x8, #64                 // Sys_write number
    svc #0                      // Eksekusi syscall cetak
    ret                         // Kembali ke pemanggil menggunakan Link Register (x30)

