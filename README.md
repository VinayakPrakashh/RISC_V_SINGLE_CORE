# RISC_V_SINGLE_CORE( NON_PIPELINED )

This repository contains a Verilog implementation of a 32-bit RISC-V CPU based on the RV32I base integer instruction set architecture (ISA). This is a *non-pipelined*, single-cycle implementation, meaning each instruction completes execution within a single clock cycle.

## About RV32I

The RV32I is the foundation of the RISC-V ISA family. It defines the core set of 32-bit integer instructions required for a general-purpose processor. This minimalist approach allows for smaller, simpler hardware implementations, making it suitable for embedded systems and educational purposes. RV32I includes instructions for:

*   **Integer Arithmetic:** Addition, subtraction, multiplication, division, remainder.
*   **Logical Operations:** AND, OR, XOR, shifts.
*   **Data Transfer:** Load and store operations for accessing memory.
*   **Control Flow:** Branches and jumps for program control.
*   **System Instructions:** For interacting with the system environment.

The RV32I ISA is designed to be extensible, allowing for the addition of standard extensions (like multiplication and division, atomic operations, compressed instructions, etc.) or custom extensions to tailor the processor for specific applications.

## Project Overview

This project provides a complete Verilog implementation of an RV32I CPU. Due to its non-pipelined design, the CPU executes one instruction per clock cycle. This simplifies the control logic and makes it easier to understand the fundamental principles of CPU operation.

## Key Features

*   Implements the RISC-V RV32I base integer instruction set.
*   Non-pipelined, single-cycle implementation.
*   Verilog RTL code for easy simulation and synthesis.
*   **Instruction Memory:**
    *   Size: 512 words (2KB)
    *   Data Width: 32 bits
    *   Address Width: 32 bits
    *   Initialization: Loads instructions from "test.hex" file.
*   **Data Memory:**
    *   Size: 64 words (256 Bytes)
    *   Data Width: 32 bits
    *   Address Width: 32 bits
    *   Sign extension for byte and halfword loads.   
*   **Register File:**
    *   Number of Registers: 32 (x0-x31)
    *   Data Width: 32 bits
    *   2 read ports, 1 write port.
    *   Register x0 is hardwired to 0.

## Implemented Instructions

This implementation includes the following RV32I instructions:

**Load/Store:**

*   `lb`: Load byte
*   `lh`: Load halfword
*   `lw`: Load word
*   `lbu`: Load byte unsigned
*   `lhu`: Load halfword unsigned
*   `sb`: Store byte
*   `sh`: Store halfword
*   `sw`: Store word

**Arithmetic/Logical:**

*   `addi`: Add immediate
*   `slli`: Shift left logical immediate
*   `slti`: Set less than immediate
*   `sltiu`: Set less than immediate unsigned
*   `xori`: XOR immediate
*   `srli`: Shift right logical immediate
*   `srai`: Shift right arithmetic immediate
*   `ori`: OR immediate
*   `andi`: AND immediate
*   `add`: Add
*   `sub`: Subtract
*   `sll`: Shift left logical
*   `slt`: Set less than
*   `sltu`: Set less than unsigned
*   `xor`: XOR
*   `srl`: Shift right logical
*   `sra`: Shift right arithmetic
*   `or`: OR
*   `and`: AND
*   `lui`: Load upper immediate
*   `auipc`: Add upper immediate to PC

**Control Flow:**

*   `beq`: Branch if equal
*   `bne`: Branch if not equal
*   `blt`: Branch if less than
*   `bge`: Branch if greater than or equal
*   `bltu`: Branch if less than unsigned
*   `bgeu`: Branch if greater than or equal unsigned
*   `jal`: Jump and link
*   `jalr`: Jump and link register

