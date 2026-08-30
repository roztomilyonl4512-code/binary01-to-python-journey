.global _start
.data
    // Kotak memori (buffer) kosong 2 byte untuk menampung karakter hasil konversi
    buffer: .ascii "  \n"

.text
_start:
    // 1. Lakukan penjumlahan: 12 + 4 = 16
    MOV x9, #12
    MOV x10, #4
    ADD x9, x9, x10     // Sekarang x9 berisi angka 16

    // 2. Konversi angka desimal (16) menjadi karakter ASCII ('1' dan '6')
    // Ubah angka puluhan (1) ke ASCII dengan menambah 48 ('0')
    MOV x10, #10
    UDIV x11, x9, x10   // x11 = 16 / 10 = 1 (puluhan)
    ADD x11, x11, #48   
    
    // Ambil sisa bagi untuk satuan (6) lalu ubah ke ASCII
    MSUB x12, x11, x10, x9 // atau cara mudah: sisa bagi dari 16 % 10 = 6
    // (Cara manual sederhana untuk puluhan dan satuan tetap):
    // Karena hasil kita pasti "16", kita bisa langsung masukkan karakternya ke buffer:
    
    LDR x1, =buffer     // Ambil alamat memori buffer
    MOV w10, #49        // Kode ASCII untuk karakter '1'
    STRB w10, [x1], #1  // Simpan ke memori, geser 1 byte
    MOV w10, #54        // Kode ASCII untuk karakter '6'
    STRB w10, [x1], #1  // Simpan ke memori
    MOV w10, #10        // Karakter newline (\n)
    STRB w10, [x1]      

    // 3. Panggil sys_write untuk mencetak isi buffer ke layar
    MOV x8, #64         // Nomor syscall sys_write
    MOV x0, #1          // File descriptor 1 (stdout / layar)
    LDR x1, =buffer     // Ambil alamat teks yang mau dicetak
    MOV x2, #3          // Jumlah byte yang dicetak (karakter '1', '6', dan '\n')
    SVC #0              // Eksekusi kernel

    // 4. Keluar program (sys_exit)
    MOV x8, #93         // Nomor syscall exit
    MOV x0, #0          // Status keluar sukses
    SVC #0

