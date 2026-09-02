def text_to_binary(text):
    return " ".join(f"{ord(c):08b}" for c in text)

def text_to_hex(text):
    return " ".join(f"{ord(c):02x}" for c in text)

print("BINARY:", text_to_binary("30\n"))
print("HEX:   ", text_to_hex("30\n"))