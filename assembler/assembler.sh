#!/bin/bash
# Simple RISC-V assembler script
# Usage: ./assemble.sh program.asm

if [ $# -eq 0 ]; then
  echo "Usage: $0 <file.asm>"
  exit 1
fi

# Input file
SRC=$1
BASENAME=$(basename "$SRC" .asm)
OBJ="${BASENAME}.o"
BIN="${BASENAME}.bin"
HEX="${BASENAME}.hex"
DUMP="${BASENAME}.dump"

# Assemble
riscv64-unknown-elf-as -march=rv32i -o $OBJ $SRC

# Convert to raw binary
riscv64-unknown-elf-objcopy -O binary $OBJ $BIN

# Convert binary to hex (32-bit words, big-endian, one per line)
xxd -e -g4 -c4 $BIN | awk '{print $2}' > $HEX


# Optional: disassembly to check opcodes
riscv64-unknown-elf-objdump -d $OBJ > $DUMP

echo "✅ Assembled $SRC"
echo "   Object file : $OBJ"
echo "   Binary file : $BIN"
echo "   Hex file    : $HEX"
echo "   Disassembly : $DUMP"
