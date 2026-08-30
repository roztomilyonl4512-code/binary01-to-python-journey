	.file	"frichilya.c"
	.text
	.globl	open_clara2                     // -- Begin function open_clara2
	.p2align	2
	.type	open_clara2,@function
open_clara2:                            // @open_clara2
	.cfi_startproc
// %bb.0:
	stp	x29, x30, [sp, #-16]!           // 16-byte Folded Spill
	.cfi_def_cfa_offset 16
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	mov	w0, #1                          // =0x1
	adrp	x1, msg_clara2
	add	x1, x1, :lo12:msg_clara2
	mov	x2, #89                         // =0x59
	bl	write
	.cfi_def_cfa wsp, 16
	ldp	x29, x30, [sp], #16             // 16-byte Folded Reload
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
.Lfunc_end0:
	.size	open_clara2, .Lfunc_end0-open_clara2
	.cfi_endproc
                                        // -- End function
	.globl	open_clara1                     // -- Begin function open_clara1
	.p2align	2
	.type	open_clara1,@function
open_clara1:                            // @open_clara1
	.cfi_startproc
// %bb.0:
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	stp	x29, x30, [sp, #16]             // 16-byte Folded Spill
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	mov	w0, #1                          // =0x1
	stur	w0, [x29, #-4]                  // 4-byte Folded Spill
	adrp	x1, msg_clara1
	add	x1, x1, :lo12:msg_clara1
	mov	x2, #71                         // =0x47
	bl	write
	bl	open_clara2
	ldur	w0, [x29, #-4]                  // 4-byte Folded Reload
	adrp	x1, msg_clara3
	add	x1, x1, :lo12:msg_clara3
	mov	x2, #61                         // =0x3d
	bl	write
	.cfi_def_cfa wsp, 32
	ldp	x29, x30, [sp, #16]             // 16-byte Folded Reload
	add	sp, sp, #32
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
.Lfunc_end1:
	.size	open_clara1, .Lfunc_end1-open_clara1
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
	stur	wzr, [x29, #-4]
	adrp	x8, input_pin
	ldr	x8, [x8, :lo12:input_pin]
	adrp	x9, pin_clara
	ldr	x9, [x9, :lo12:pin_clara]
	subs	x8, x8, x9
	b.ne	.LBB2_2
	b	.LBB2_1
.LBB2_1:
	bl	open_clara1
	b	.LBB2_3
.LBB2_2:
	mov	w0, #1                          // =0x1
	adrp	x1, msg_claraumum
	add	x1, x1, :lo12:msg_claraumum
	mov	x2, #91                         // =0x5b
	bl	write
	b	.LBB2_3
.LBB2_3:
	mov	w0, wzr
	.cfi_def_cfa wsp, 32
	ldp	x29, x30, [sp, #16]             // 16-byte Folded Reload
	add	sp, sp, #32
	.cfi_def_cfa_offset 0
	.cfi_restore w30
	.cfi_restore w29
	ret
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
	.cfi_endproc
                                        // -- End function
	.type	input_pin,@object               // @input_pin
	.data
	.globl	input_pin
	.p2align	3, 0x0
input_pin:
	.xword	151121                          // 0x24e51
	.size	input_pin, 8

	.type	pin_clara,@object               // @pin_clara
	.globl	pin_clara
	.p2align	3, 0x0
pin_clara:
	.xword	151121                          // 0x24e51
	.size	pin_clara, 8

	.type	msg_clara1,@object              // @msg_clara1
	.globl	msg_clara1
msg_clara1:
	.asciz	"PESAN RAHASIA  1: Clara setuju acara peresmian dirinya menjadi milikku\n"
	.size	msg_clara1, 72

	.type	msg_clara2,@object              // @msg_clara2
	.globl	msg_clara2
msg_clara2:
	.asciz	"PESAN RAHASIA 2: Aku mengikat kalung di lehernya dan dia pun pasrah ke dalam pelukkan ku\n"
	.size	msg_clara2, 90

	.type	msg_clara3,@object              // @msg_clara3
	.globl	msg_clara3
msg_clara3:
	.asciz	"PESAN RAHASIA 3: Clara pun resmi menjadi pendamping hidup ku\n"
	.size	msg_clara3, 62

	.type	msg_claraumum,@object           // @msg_claraumum
	.globl	msg_claraumum
msg_claraumum:
	.asciz	"PADA UMUMNYA, INI BUKAN PESAN KHUSUS YA... Clara patuh tunduk dan setia kepadaku selamanya\n"
	.size	msg_claraumum, 92

	.ident	"clang version 21.1.8"
	.section	".note.GNU-stack","",@progbits
