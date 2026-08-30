.global _start
_start:

MOV x0, #25  //salin angka 25 di register x0
MOV x1, #10  //salin angka 10 di register x1
ADD x0, x0, x1 //jumlah 25 (reg x0) +10 (reg x1) lalu simpan di register x0

MOV x2, #5 //salin angka pengurang ke register x2
SUB x0, x0, x2 //mengurangkan angka 35 di register x0 dengan anhka pengurang di register x2

MOV x2, #2 //menggunakan register x2 untuk menulis 2 karakter yaitu 3 dan 0
MOV x8, #64 //salin syscall kode nomor 64 untuk tampil di layar di register x8
MOV x3, #10 //memakai register x3 sebagai angka pembagi yaitu 10

UDIV x4, x0, x3 //bagi bilangan 30 di reg x0 dan bilangan 10 dibreg x3 dan simpan hasil di reg x4
MSUB x5, x4, x3, x0 //reg x5 untuk simpan pembagian sisa bilangan yang ada di x4,yaitu 0 dikali dikurangi 30 di x0 

ADD x4, x4, #48 //48 adalah nilai konstan angka desimal Ascii ditambah 4 hasilnya 51, untuk angka 3
ADD x5, x5, #48 //48 untuk salin 0 di reg x5+48 hasilnya 48, untuk angka 0

SUB sp, sp, #16 //kurangi stack pointer menjadi 16 byte saja karrna hanya 2 karakter
STRB w4, [sp] //register asal
STRB w5, [sp, #1] //register tujuan di tambah 1

MOV x6, #10         // 10 adalah kode ASCII untuk newline (\n)
STRB w6, [sp, #2]   // Simpan newline di slot ke-3 (offset 2)

MOV x0, #1 //stdout ke layar
MOV x1, sp //alamat buffer awal data
MOV x2, #3 //panjang karakter termasuk newline
MOV x8, #64 //syscall write
SVC #0 //supervisor call,izin kernel linux

MOV x8, #93 //izin untkk exit
MOV x0, #0 // 0 artinya perintah telah dilaksanakan tanpa error
SVC #0 
