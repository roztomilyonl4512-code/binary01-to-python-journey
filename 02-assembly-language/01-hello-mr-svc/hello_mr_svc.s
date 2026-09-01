// =========================================================
// File: hello_mr_svc.s
// Title: Hello, Mr. Supervisor Call
// Purpose: A friendly introduction to the ARM64 SVC instruction.
//          This program prints a greeting to the terminal
//          by invoking the Linux kernel via 'SVC #0'.
// =========================================================

.global _start

.data
    hello: .ascii "Hello, Mr. Supervisor Call!\n"

.text
_start:

    // Step 1: Print to screen
    MOV x0, #1          // File descriptor: stdout
    LDR x1, =hello      // Address of the message
    MOV x2, #28         // Length of the string (counted manually)
    MOV x8, #64         // Syscall number for 'write'
    SVC #0              // "Mr. Supervisor Call, please write this for me."

    // Step 2: Exit gracefully
    MOV x8, #93         // Syscall number for 'exit'
    MOV x0, #0          // Exit code: 0 (no errors)
    SVC #0              // "Mr. Supervisor Call, we are done here."
