# 🧬 Stack Overflow Lab: ASCII → Binary → Hex → Memory

> *"I don't just learn theory—I verify it against the machine itself."*

This lab traces the complete journey of the phrase **"STACK OVERFLOW"** —from my handwritten notes, through Python automation, into ARM64 Assembly, and finally, to the raw memory dump (`xxd`). 

This project proves that I understand not only how to write code, but also **what actually happens inside the RAM and CPU** when a string is stored and printed.

---

## 🧠 The Three Stages of Understanding

### 1. 📓 Manual (Pen & Paper)

Before any code, I converted each letter of **"STACK OVERFLOW"** into its **ASCII decimal**, then into **8-bit binary**, and finally into **hexadecimal**.

**Example (Letter 'S'):**


| Letter | ASCII | Binary (8-bit) | Hex |
| :--- | :--- | :--- | :--- |
| S | 83 | 01010011 | 0x53 |
| T | 84 | 01010100 | 0x54 |
| A | 65 | 01000001 | 0x41 |
| C | 67 | 01000011 | 0x43 |
| K | 75 | 01001011 | 0x4B |
| (space) | 32 | 00100000 | 0x20 |
| O | 79 | 01001111 | 0x4F |
| V | 86 | 01010110 | 0x56 |
| E | 69 | 01000101 | 0x45 |
| R | 82 | 01010010 | 0x52 |
| F | 70 | 01000110 | 0x46 |
| L | 76 | 01001100 | 0x4C |
| O | 79 | 01001111 | 0x4F |
| W | 87 | 01010111 | 0x57 |

*(The full photo of my notebook is included as `stack_overflow_ascii.jpg`)*

---

### 2. 🐍 Python Automation (Binary & Hex Generator)

To verify my manual calculations, I wrote a **Python script** that converts any string into 8-bit binary and hexadecimal on the fly.

**Code Snippet:**
```python
def teks_ke_biner(teks):
    return " ".join(f"{ord(c):08b}" for c in teks)

def teks_ke_hex(teks):
    return " ".join(f"{ord(c):02x}" for c in teks)

pesan = "STACK OVERFLOW"
print("Binary:", teks_ke_biner(pesan))
print("Hex:   ", teks_ke_hex(pesan))

What did I learn from this lab?

"The string I write in my code is not stored as letters—it's stored as bytes. When I look at the hexdump, I am literally reading the memory that the CPU will execute. This is the foundation of Reverse Engineering."
