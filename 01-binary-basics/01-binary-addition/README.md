# 🔬 Division Lab: (25 + 10 - 5) / 10 = 3 Remainder 0

This project demonstrates a complete ALU (Arithmetic Logic Unit) workflow:

1. **Manual Calculation**: I performed the binary arithmetic on paper (see photo) to predict the output.
2. **ARM64 Assembly**: The logic is implemented using `UDIV` (unsigned division) and `MSUB` (multiply-subtract to get remainder).
3. **ASCII Conversion**: The quotient (3) and remainder (0) are converted to ASCII characters `'3'` and `'0'` by adding 48 (`0x30`).
4. **Syscalls**: The program writes the string `"30\n"` directly to the terminal using the Linux `write` syscall.
5. **Hexdump**: The `xxd` output proves how the raw binary values (`0x03`, `0x00`) are stored in the object file.

**Key Takeaway**: I verified my manual binary calculations against the machine's actual output. They match perfectly, confirming I understand both the theory and the hardware execution.
