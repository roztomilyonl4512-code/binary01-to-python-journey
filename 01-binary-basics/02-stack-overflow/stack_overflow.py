def text_to_binary(text):
    return " ".join(f"{ord(c):08b}" for c in text)

def text_to_hex(text):
    return " ".join(f"{ord(c):02x}" for c in text)

message = "STACK OVERFLOW"

print("=" * 40)
print("ASCII → BINARY (8-bit):")
print(text_to_binary(message))
print("\n" + "=" * 40)
print("ASCII → HEXADECIMAL:")
print(text_to_hex(message))
print("=" * 40)