	.file	"main.c"
	.text
	.globl	tambah                          // -- Begin function tambah
	.p2align	2
	.type	tambah,@function
tambah:                                 // @tambah
	.cfi_startproc
// %bb.0:
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	str	w0, [sp, #12]
	str	w1, [sp, #8]
	ldr	w8, [sp, #12]
	ldr	w9, [sp, #8]
	add	w0, w8, w9
	add	sp, sp, #16
	.cfi_def_cfa_offset 0
	ret
.Lfunc_end0:
	.size	tambah, .Lfunc_end0-tambah
	.cfi_endproc
                                        // -- End function
	.globl	main                            // -- Begin function main
	.p2align	2
	.type	main,@function
main:                                   // @main
	.cfi_startproc
// %bb.0:
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	stp	x29, x30, [sp, #16]             // 16-byte Folded Spill
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	mov	w8, wzr
	str	w8, [sp, #4]                    // 4-byte Folded Spill
	stur	wzr, [x29, #-4]
	mov	w0, #5                          // =0x5
	mov	w1, #7                          // =0x7
	bl	tambah
	str	w0, [sp, #8]
	ldr	w1, [sp, #8]
	adrp	x0, .L.str
	add	x0, x0, :lo12:.L.str
	bl	printf
	ldr	w0, [sp, #4]                    // 4-byte Folded Reload
	.cfi_def_cfa wsp, 32
	ldp	x29, x30, [sp, #16]             // 16-byte Folded Reload
	add	sp, sp, #32
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
	.cfi_endproc
                                        // -- End function
	.type	.L.str,@object                  // @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"Hasil: %d\n"
	.size	.L.str, 11

	.ident	"clang version 21.1.8"
	.section	".note.GNU-stack","",@progbits
