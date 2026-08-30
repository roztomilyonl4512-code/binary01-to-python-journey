.global _start //titik awal program dimulai

_start: //label
MOV x0, #12 //sslin biner 00001100 (desimal 12) di register x0
MOV x1, #4 // salin biner 00000100 (desimal 4)di register x1
ADD x0, x0, x1 //menjumlahkan biner 00001100 dan biner 00000100 di regiater x0
MOV x8, #93 //register x8,register khusus syscall exit dwngan nomor call #93
MOV x1, #0 //memberi tahukernel libux bahwa operasi hitung telah sukses nol error
SVC #0 // IZN KERNELNLINUX
