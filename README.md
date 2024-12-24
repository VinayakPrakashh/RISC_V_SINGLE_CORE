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
