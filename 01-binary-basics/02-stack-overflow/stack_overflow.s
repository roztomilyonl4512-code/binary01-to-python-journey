// =========================================================
// File: stack_overflow.s
// Purpose: Print "STACK OVERFLOW" to the terminal
// =========================================================
.global _start
.data
    msg: .asciz "STACK OVERFLOW\n"   // String + newline
.text
_start:
    // Write the string to stdout
    MOV x0, #1                // stdout
    LDR x1, =msg              // Load address of string
    MOV x2, #15               // Length of "STACK OVERFLOW\n" (15 chars)
    MOV x8, #64               // syscall write
    SVC #0

    // Exit
    MOV x8, #93               // syscall exit
    MOV x0, #0
    SVC #0
