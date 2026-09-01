🧙 Hello, Mr. Supervisor Call — My First ARM64 Assembly Program

"Before you can reverse engineer, you must first learn to speak the language of the kernel."

This project is not just a "Hello World" clone. It is my formal introduction to ARM64 Linux syscalls—the interface between my code and the operating system.

What Is a Supervisor Call?

In ARM64 architecture, the  SVC  (Supervisor Call) instruction is the primary mechanism for user-space programs to request services from the Linux kernel. When I write  SVC #0 , I am essentially saying:

"Mr. Supervisor Call, please execute this kernel function on my behalf."

This program uses two syscalls:

​Syscall #64 (write): Prints my message to the terminal.
​Syscall #93 (exit): Terminates the program cleanly.

Why This Matters

Understanding the kernel interface is fundamental to reverse engineering. Malware, exploits, and protective mechanisms all rely on syscalls. By mastering  SVC , I am learning to read and manipulate the bridge between user space and kernel space—the very layer where security boundaries are enforced.

Code

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

Hexdump

00000000: 7f45 4c46 0201 0100 0000 0000 0000 0000  .ELF............
00000010: 0100 b700 0100 0000 0000 0000 0000 0000  ................
00000020: 0000 0000 0000 0000 b001 0000 0000 0000  ................
00000030: 0000 0000 4000 0000 0000 4000 0800 0700  ....@.....@.....
00000040: 2000 80d2 e100 0058 8203 80d2 0808 80d2   ......X........
00000050: 0100 00d4 a80b 80d2 0000 80d2 0100 00d4  ................
============================
00000060: 0000 0000 0000 0000 4865 6c6c 6f2c 204d  ........Hello, M
00000070: 722e 2053 7570 6572 7669 736f 7220 4361  r. Supervisor Ca
00000080: 6c6c 210a 0000 0000 0000 0000 0000 0000  ll!.............
============================
00000090: 0000 0000 0000 0000 0000 0000 0000 0000  ................

"Hello, Mr. Supervisor Call. I will be visiting you often."


🕵️ GDB Analysis: Observing the Syscall in Action

To see my whole understanding, I ran this program through the GNU Debugger (GDB) and found that the address of my output was at 0x21016c

Breakpoint 1, 0x000000000021015c in _start ()
(gdb) stepi
0x0000000000210160 in _start ()
(gdb) stepi
0x0000000000210164 in _start ()
(gdb) stepi
0x0000000000210168 in _start ()
(gdb) stepi
Hello, Mr. Supervisor Call!
0x000000000021016c in _start ()
(gdb) stepi
0x000000000021016c in _start ()
(gdb) stepi
0x0000000000210170 in _start ()
(gdb) stepi
0x0000000000210174 in _start ()
(gdb) stepi
[Inferior 1 (process 17718) exited normally]


Why This Matters

By inspecting the registers before the  SVC #0  instruction, I can predict exactly what the kernel will do before it happens. This is the foundation of:

​Reverse Engineering: Understanding what a program does without source code.
​Exploit Development: Finding vulnerable syscalls and manipulating arguments.
​Malware Analysis: Tracing suspicious system calls in unknown binaries.

"GDB turns assembly from a language I write into a conversation I have with the machine."


🔍 Disassembly with  objdump -d : Understanding Machine Code

To truly understand what my assembly program becomes after compilation, I used  objdump -d  to disassemble the object file. This shows me the raw machine code (opcodes) that the CPU actually executes.

Disassembly Output

 hello_mr_svc:   file format elf64-littleaarch64

Disassembly of section .text:

0000000000210158 <_start>:
  210158: d2800020      mov     x0, #0x1                // =1
  21015c: 580000e1      ldr     x1, 0x210178 <_start+0x20>
  210160: d2800382      mov     x2, #0x1c               // =28
  210164: d2800808      mov     x8, #0x40               // =64
  210168: d4000001      svc     #0
  21016c: d2800ba8      mov     x8, #0x5d               // =93
  210170: d2800000      mov     x0, #0x0                // =0
  210174: d4000001      svc     #0
  210178: 80 01 22 00   .word   0x00220180
  21017c: 00 00 00 00   .word   0x00000000


## 🧠 Why objdump -d and GDB Show Different Addresses

While analyzing the binary with `objdump -d` and GDB, I noticed that the addresses displayed by each tool were different. This is not an error—it's a fundamental concept in program execution.

### objdump -d: Relative Offsets
`objdump -d` shows addresses **relative to the start of the file**. The first instruction is at `0x0`, then `0x4`, `0x8`, etc.

### GDB: Runtime Virtual Addresses
GDB shows the **actual memory address** where the program is loaded at runtime. The loader maps the program to a higher address (in my case, `0x210158`).

### Why the String Appears at `0x21016c`
The `write` syscall is executed at `0x210168`. After the syscall completes, the program continues to `0x21016c`, which is the start of the exit sequence. GDB shows `0x21016c` as the **next instruction pointer** after the syscall, which is why the string output appears to be associated with that address.

### Key Takeaway
Understanding the difference between file offsets and runtime addresses is essential for reverse engineering. When analyzing a binary, I must always be aware of **where** the code is loaded and **how** the program's memory is mapped.
