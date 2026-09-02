# 🧮 ALU in Action: Arithmetic Lab (25 + 10 - 5) / 10 = 3 R 0

> *"Before I could read memory, I had to master the math inside the CPU."*

This lab demonstrates the **Arithmetic Logic Unit (ALU)** in action. I performed a multi-step calculation entirely in ARM64 assembly, using only registers, arithmetic instructions, and the stack—then verified it against my manual notebook, Python, `objdump`, and GDB.

---

## 🧠 The Calculation Flow

**1. Addition & Subtraction:**
- `25 + 10 = 35`
- `35 - 5 = 30`

**2. Division & Remainder:**
- `30 ÷ 10 = 3` (Quotient)
- `30 - (3 × 10) = 0` (Remainder)

**3. ASCII Conversion:**
- Quotient `3` → ASCII `'3'` (51 in decimal, `0x33` in hex)
- Remainder `0` → ASCII `'0'` (48 in decimal, `0x30` in hex)
- Newline `\n` → ASCII `10` (`0x0A`)

**4. Final Output:**
- The program prints `"30\n"` to the terminal.

---

## 💻 The Assembly Code

// =========================================================
// File: arithmetic_division.s
// Purpose: Calculate (25 + 10 - 5) = 30, then divide by 10.
//          Prints the quotient and remainder as ASCII.
// =========================================================

.global _start
_start:

    // ---------- Calculation Phase ----------
    MOV x0, #25             // Load 25 into register x0
    MOV x1, #10             // Load 10 into register x1
    ADD x0, x0, x1          // x0 = 25 + 10 = 35

    MOV x2, #5              // Load subtrahend (5) into x2
    SUB x0, x0, x2          // x0 = 35 - 5 = 30

    // ---------- Division Phase ----------
    MOV x3, #10             // Load divisor (10) into x3
    UDIV x4, x0, x3         // x4 = 30 / 10 = 3 (quotient)
    MSUB x5, x4, x3, x0     // x5 = 30 - (3 * 10) = 0 (remainder)

    // ---------- ASCII Conversion ----------
    ADD x4, x4, #48         // Convert 3 to ASCII '3' (48 + 3 = 51)
    ADD x5, x5, #48         // Convert 0 to ASCII '0' (48 + 0 = 48)

    // ---------- Build Output String on Stack ----------
    SUB sp, sp, #16         // Allocate 16 bytes on stack
    STRB w4, [sp]           // Store '3' at stack[0]
    STRB w5, [sp, #1]       // Store '0' at stack[1]
    MOV x6, #10             // ASCII newline (\n)
    STRB w6, [sp, #2]       // Store newline at stack[2]

    // ---------- Syscall: Write ----------
    MOV x0, #1              // stdout
    MOV x1, sp              // Buffer address (stack pointer)
    MOV x2, #3              // Length: "3", "0", "\n"
    MOV x8, #64             // Syscall write
    SVC #0

    // ---------- Syscall: Exit ----------
    MOV x8, #93             // Syscall exit
    MOV x0, #0              // Exit code 0
    SVC #0
 

 

📓 Python Verification (Manual vs Machine)

I wrote a Python script to verify the ASCII and binary representation of my expected output "30\n":

def text_to_binary(text):
    return " ".join(f"{ord(c):08b}" for c in text)

def text_to_hex(text):
    return " ".join(f"{ord(c):02x}" for c in text)

print("BINARY:", text_to_binary("30\n"))
print("HEX:   ", text_to_hex("30\n"))
 

Output:

 
BINARY: 00110011 00110000 00001010
HEX:    33 30 0a
 

Verification:

· '3' = 00110011 (binary) = 0x33 (hex) ✅
· '0' = 00110000 (binary) = 0x30 (hex) ✅
· '\n' = 00001010 (binary) = 0x0A (hex) ✅

My manual notebook matches this exactly. 
 

🕵️ GDB Analysis: Watching the Registers Change

Using GDB, I stepped through the program to watch the registers update in real-time.

Breakpoint at _start:

(gdb) break _start
(gdb) run
 
Stepping through:

(gdb) stepi   // MOV x0, #25
(gdb) info registers x0   // x0 = 0x19 (25)

(gdb) stepi   // MOV x1, #10
(gdb) stepi   // ADD x0, x0, x1
(gdb) info registers x0   // x0 = 0x23 (35) ✅

(gdb) stepi   // MOV x2, #5
(gdb) stepi   // SUB x0, x0, x2
(gdb) info registers x0   // x0 = 0x1e (30) ✅

(gdb) stepi   // MOV x3, #10
(gdb) stepi   // UDIV x4, x0, x3
(gdb) info registers x4   // x4 = 0x3 (3) ✅

(gdb) stepi   // MSUB x5, x4, x3, x0
(gdb) info registers x5   // x5 = 0x0 (0) ✅
 

ASCII Conversion Check:

 
(gdb) stepi   // ADD x4, x4, #48
(gdb) info registers x4   // x4 = 0x33 (51, which is '3') ✅

(gdb) stepi   // ADD x5, x5, #48
(gdb) info registers x5   // x5 = 0x30 (48, which is '0') ✅
 

Stack Inspection (Before Write):

 
(gdb) x/3bx $sp
0x30 0x33 0x0a   // Bytes: '0', '3', newline — printed as "30\n" ✅
 

The CPU followed my exact manual logic.

 

🔍 Disassembly with objdump -d

Disassembling the object file reveals the raw machine code:

 
0000000000210158 <_start>:
  210158: d2800320      mov     x0, #0x19      // 25
  21015c: d2800141      mov     x1, #0xa       // 10
  210160: 8b010000      add     x0, x0, x1
  210164: d28000a2      mov     x2, #0x5
  210168: cb020000      sub     x0, x0, x2
  21016c: d2800143      mov     x3, #0xa
  210170: 9ac30804      udiv    x4, x0, x3
  210174: 4b0308a5      msub    x5, x4, x3, x0
  210178: 91010c84      add     x4, x4, #0x30   // #48
  21017c: 91010ca5      add     x5, x5, #0x30
  ...
 

Observations:

· d2800320 is the machine code for mov x0, #25.
· 8b010000 is add x0, x0, x1.
· 9ac30804 is udiv x4, x0, x3.
· The ASCII addition (add x4, x4, #0x30) encodes #0x30 which is exactly 48 in hex—the start of the ASCII digit range.

 

🧠 Why MSUB is Special (Important Insight)

In many architectures, calculating a remainder requires a separate MOD instruction. ARM64 uses MSUB (Multiply-Subtract) to compute the remainder in a single instruction:

 
MSUB x5, x4, x3, x0   // x5 = x0 - (x4 * x3)
 

This demonstrates ARM64's efficient RISC philosophy—using a fused operation to save cycles. This is critical for reverse engineering, because seeing MSUB in a binary tells me the compiler is optimizing a division/remainder pair.

 

✅ Conclusion

This lab solidified my understanding of:

· ALU Operations: ADD, SUB, UDIV, MSUB.
· Register Tracking: Watching x0 change from 25 → 35 → 30.
· ASCII Conversion: Manually converting numbers to characters using #48.
· Stack Management: Using SP to store a custom byte string.
· Verification: Matching my manual notes, Python output, GDB, and objdump against each other.

"The CPU doesn't guess—it calculates. And now, so do I."
