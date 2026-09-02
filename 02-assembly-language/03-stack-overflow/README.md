🧵 "Learning Stack Overflow" — String Concatenation (Raw Hex Method)

"Combining strings at the byte level is the foundation of every text-based exploit."

This lab demonstrates string concatenation using raw hex constants. The strings "Learning", " Stack ", and "Overflow" are combined into a single sentence: "Learning Stack Overflow".

 

📓 1. Manual Conversion 
I did manual conversion of these strings from the number of the ascii's key for ever character  which is used in this lab. For the complete overview, please refer to my manual_conversion.jpg image attached in this lab. 
To check my conversion was true, I ran python tool to check the binary and the hexadecimal which are used in these strings, and got that my work and the python tool produce the same result. 

My Handwritting (image):

String 1: "Learning" (8 bytes)
Letter       Binary           Hex
L              0100 1100         4C
e              0110 0101          65
a              0110 0001         61
r               0111 0010          72
n              0110 1110           6E
i                0110 1001          69
n              0110 1110            6E
g              0110 0111            67

String 2: " Stack " (7 bytes)
Letter                 Binary              Hex
(space)            0010 0000      20
      S                      0101 0011         53
      t                       0111 0100          74
      a                      0110 0001         61
      c                      0110 0011          63
      k                      0110 1011           6B
(space)            0010 0000       20


String 3: "Overflow" (8 bytes)
Letter      Binary         Hex
     O         0100 1111        4F
     v          0111 0110         76
     e          0110 0101       65
     r           0111 0010        72
     f           0110 0110       66
     l            0110 1100       6C
    o           0110 1111         6F
    w          0111 0111          77

Little-Endian : 
"Learning": 0x676E696E7261654C
" Stack " : 0x206B6361745320
"Overflow" : 0x776F6C667265764F

 
📓 2. Python Tool

def text_to_binary(text):
    return " ".join(f"{ord(c):08b}" for c in text)

def text_to_hex(text):
    return " ".join(f"{ord(c):02x}" for c in text)

message = "Learning Stack Overflow"

print("=" * 40)
print("ASCII → BINARY (8-bit):")
print(text_to_binary(message))
print("\n" + "=" * 40)
print("ASCII → HEXADECIMAL:")
print(text_to_hex(message))
print("=" * 40)


And the output of the code was:
============================
ASCII → BINARY (8-bit):
01001100 01100101 01100001 01110010 01101110 01101001 01101110 01100111 00100000 01010011 01110100 01100001 01100011 01101011 00100000 01001111 01110110 01100101 01110010 01100110 01101100 01101111 01110111

============================
ASCII → HEXADECIMAL:
4c 65 61 72 6e 69 6e 67 20 53 74 61 63 6b 20 4f 76 65 72 66 6c 6f 77

[Program finished]
============================
The output of the python code shows similarities of binary and hexadecimal structure with the concatenation operation I created in my manual notes. 
 

💻 3. The Assembly Code
 
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
    SUB sp, sp, #32               // 25 bytes needed, allocate 32 (16-byte aligned)

    // ---------- Store Strings on Stack ----------
    STR x0, [sp, #0]           // "Learning" at offset 0 (bytes 0-7)
    STR x1, [sp, #8]          // " Stack " at offset 8 (bytes 8-15)
    STR x3, [sp, #16]         // "Overflow" at offset 16 (bytes 16-23)

    // ---------- Add Newline ----------
    MOV x4, #10                   // ASCII newline (\n)
    STRB w4, [sp, #24]            // store newline at offset 24 (the 25th byte) 

    // ---------- Print to Screen ----------
    MOV x0, #1                    // stdout
    MOV x1, sp                    // Buffer address
    MOV x2, #25                   // Total length: 25 chars,  which are consist of 21 letters + 2 spaces bars + 1 of char padding + 1 newline = 25
    MOV x8, #64                   // sys_write
    SVC #0

    // ---------- Restore Stack & Exit ----------
    ADD sp, sp, #32

    MOV x8, #93                   // sys_exit
    MOV x0, #0
    SVC #0
 
 
🔍 4. GDB Memory Inspection :

I ran  gdb  with  break _start  to inspect register changes step by step using  stepi  and  info registers  until the program exited safely. This confirmed:

🔸 The first string ( "Learning" ) is stored in register  x0  at  0x000000000021015c  using little-endian structure:
 x0 = 0x676e696e7261654c  →  "gninraeL"  (which is  "Learning"  reversed)

🔸 The second string ( " Stack " ) is stored in register  x1  at  0x0000000000210160 :
 x1 = 0x206b6361745320  →  " kcatS "  (which is  " Stack "  reversed)

🔸 The third string ( "Overflow" ) is stored in register  x3  at  0x0000000000210164 :
 x3 = 0x776f6c667265764f  →  "wolfrevO"  (which is  "Overflow"  reversed)

At exit,  x3  still held  "Overflow" . This is normal behavior, but it raised an important security question—see the section below.

Full GDB session log is available in this lab folder as  gdb_session_learning_stack.txt .


## 🧠 Critical Security & Systems Question: Why Did `x3` Still Hold "Overflow" at Exit?

(gdb) stepi
0x000000000021019c in _start ()
(gdb) i r
x0             0x0                 0
x1             0x7fffffe250        549755806288
x2             0x19                25
x3             0x776f6c667265764f  8606216600190023247
x4             0xa                 10
x5             0x0                 0
x6             0x0                 0
x7             0x0                 0
x8             0x5d                93
x9             0x0                 0
x10            0x0                 0 

While testing my program in GDB, I noticed something that caught my attention:

```bash
(gdb) i r
x3             0x776f6c667265764f  8606216600190023247
 
I expected all registers to be empty (0) after my program finished executing, especially after the SVC #0 (exit) syscall. But instead, x3 still contained the full "Overflow" string in little-endian.

## 🛡️ Security Note: Why This Matters are crucial for White Hat Engineering

While debugging this program, I noticed that `x3` still held the string `"Overflow"` at exit. This raises an important question:

> *"If this were a password, would it still be sitting in a register after the program finished?"*

After searching out for a while, I got YES🤔
The answer is **yes**—unless you explicitly clear it. 

In security-sensitive applications, developers must **zero out registers and memory** before freeing them:
MOV x0, #0
MOV x1, #0
MOV x3, #0

This prevents sensitive data from being exposed in crash dumps, core files, or memory scans 

**This program is not security-sensitive**—it prints a non-secret string and exits. But the discipline of checking register values at every stage is exactly what White Hats practice when auditing code for vulnerabilities.

> *"A White Hat doesn't just run code—they investigate what the code leaves behind."*
 
 

🔍 5. Disassembly (objdump -d)
◾️concat_strings.o:       file format elf64-littleaarch64

Disassembly of section .text:

0000000000000000 <_start>:
       0: 58000240      ldr     x0, 0x48 <_start+0x48>
       4: 58000261      ldr     x1, 0x50 <_start+0x50>
       8: 58000283      ldr     x3, 0x58 <_start+0x58>

         ... objdump disassembly ... 

      48: 4c 65 61 72   .word   0x7261654c
      4c: 6e 69 6e 67   .word   0x676e696e
      50: 20 53 74 61   .word   0x61745320
      54: 63 6b 20 00   .word   0x00206b63
      58: 4f 76 65 72   .word   0x7265764f
      5c: 66 6c 6f 77   .word   0x776f6c66

From the objdump I know that the data string is started at 0x48 until 0x5f with a NULL terminated at the second string. I deacribe the detail address below:
🔸 0x48 to 0x4f for 1st string "Learning", whichis consist of 8 byte
🔸 0x50 to 0x57 for 2nd string, which is consist 5 characters of the word "Stack" + 2 space bars + a null offset
🔸 0x58 to 0x5f for string "Overflow", which is consist of 8 byte
 

🔍 6. Xxd (hexadump)

The hexdump confirms the string layout in memory:

```bash
00000080: 4c65 6172 6e69 6e67 2053 7461 636b 2000  Learning Stack .
00000090: 4f76 6572 666c 6f77 0000 0000 0000 0000  Overflow........

Observation:
The 00 byte after " Stack " is the NULL terminator that I added to pad the string to 8 bytes. This is stored in x1 and ensures the word "Stack" and its surrounding spaces fit neatly into an 8-byte register.


🤔 Conclusion

✅ What did I Learn? 

· Byte Precision: I now know exactly which byte goes where in memory.
· Little-Endian Mastery: I can reverse byte orders to write correct hex constants.
· Register Limits: x0 holds exactly 8 bytes, so strings of length 8 fit perfectly.
· Stack Management: I can allocate space and store values at specific offsets.
· Syscalls: I used write to output the final combined string.

 

"Bytes are the atoms of memory. Once you can arrange them, you can build anything."
