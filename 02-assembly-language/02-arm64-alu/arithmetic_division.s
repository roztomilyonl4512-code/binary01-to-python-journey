// =========================================================
// File: arithmetic_division.s
// Purpose: Calculate (25 + 10 - 5) = 30, then divide by 10.
//          Prints the quotient and remainder as ASCII to the screen.
//          Output: "30\n"
// =========================================================

.global _start
_start:

    // ---------- CALCULATION PHASE ----------
    MOV x0, #25             // Load 25 into register x0
    MOV x1, #10             // Load 10 into register x1
    ADD x0, x0, x1          // x0 = 25 + 10 = 35

    MOV x2, #5              // Load subtractor (5) into x2
    SUB x0, x0, x2          // x0 = 35 - 5 = 30

    // ---------- DIVISION PHASE ----------
    MOV x3, #10             // Load divisor (10) into x3
    UDIV x4, x0, x3         // x4 = 30 / 10 = 3 (Quotient)
    MSUB x5, x4, x3, x0     // x5 = 30 - (3 * 10) = 0 (Remainder)

    // ---------- ASCII CONVERSION ----------
    ADD x4, x4, #48         // Quotient (3) + 48 = 51 ('3')
    ADD x5, x5, #48         // Remainder (0) + 48 = 48 ('0')

    // ---------- BUILD OUTPUT STRING ON STACK ----------
    SUB sp, sp, #16         // Allocate 16 bytes on the stack (safety space)
    STRB w4, [sp]           // Store '3' at stack[0]
    STRB w5, [sp, #1]       // Store '0' at stack[1]
    MOV x6, #10             // ASCII code for newline (\n)
    STRB w6, [sp, #2]       // Store newline at stack[2]

    // ---------- SYSCALL: WRITE TO SCREEN ----------
    MOV x0, #1              // 1 = Standard Output (stdout)
    MOV x1, sp              // Address of the buffer (stack pointer)
    MOV x2, #3              // Number of bytes to print ("3", "0", "\n")
    MOV x8, #64             // Syscall number for 'write' on ARM64
    SVC #0                  // Supervisor call (enter kernel)

    // ---------- SYSCALL: EXIT ----------
    MOV x8, #93             // Syscall number for 'exit'
    MOV x0, #0              // Exit with status 0 (No errors)
    SVC #0                  // Supervisor call (terminate program)
