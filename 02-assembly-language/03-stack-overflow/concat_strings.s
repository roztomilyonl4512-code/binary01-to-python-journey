// =========================================================
// File: concat_strings.s
// Title: Learning Stack Overflow (Raw Hex Method)
// Purpose: Combine "Learning", " Stack ", and "Overflow"
//          using hardcoded little-endian constants.
// =========================================================

.global _start
_start:

    // ---------- Load Little-Endian Constants ----------
    LDR x0, =0x676E696E7261654C   // "Learning"
    LDR x1, =0x206B6361745320     // " Stack "
    LDR x3, =0x776F6C667265764F   // "Overflow"

    // ---------- Allocate Stack Space ----------
    SUB sp, sp, #32               // 24 bytes needed, allocate 32 (16-byte aligned)

    // ---------- Store Strings on Stack ----------
    STR x0, [sp, #0]              // "Learning" at offset 0
    STR x1, [sp, #8]              // " Stack " at offset 8
    STR x3, [sp, #16]             // "Overflow" at offset 16

    // ---------- Add Newline ----------
    MOV x4, #10                   // ASCII newline (\n)
    STRB w4, [sp, #24]            // Place newline at offset 23 (24th byte)

    // ---------- Print to Screen ----------
    MOV x0, #1                    // stdout
    MOV x1, sp                    // Buffer address
    MOV x2, #25                   // Total length: 23 chars + 1 newline = 25
    MOV x8, #64                   // sys_write
    SVC #0

    // ---------- Restore Stack & Exit ----------
    ADD sp, sp, #32

    MOV x8, #93                   // sys_exit
    MOV x0, #0
    SVC #0
