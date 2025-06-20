# RISC_V_SINGLE_CORE (NON_PIPELINED)

![Verilog](https://img.shields.io/badge/Verilog-100%25-blue)
![License](https://img.shields.io/github/license/VinayakPrakashh/RISC_V_SINGLE_CORE)
![Stars](https://img.shields.io/github/stars/VinayakPrakashh/RISC_V_SINGLE_CORE)
![Forks](https://img.shields.io/github/forks/VinayakPrakashh/RISC_V_SINGLE_CORE)

This repository contains a Verilog implementation of a 32-bit RISC-V CPU based on the RV32I base integer instruction set architecture (ISA). This is a *non-pipelined*, single-cycle implementation, meaning it executes one instruction per clock cycle.

## Table of Contents
- [About RV32I](#about-rv32i)
- [Project Overview](#project-overview)
- [Key Features](#key-features)
- [Implemented Instructions](#implemented-instructions)
- [Getting Started](#getting-started)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)

## About RV32I

The RV32I is the foundation of the RISC-V ISA family. It defines the core set of 32-bit integer instructions required for a general-purpose processor. This minimalist approach allows for smaller, simpler, and more efficient implementations.

### Key Components
- **Integer Arithmetic:** Addition, subtraction, multiplication, division, remainder.
- **Logical Operations:** AND, OR, XOR, shifts.
- **Data Transfer:** Load and store operations for accessing memory.
- **Control Flow:** Branches and jumps for program control.
- **System Instructions:** For interacting with the system environment.

The RV32I ISA is designed to be extensible, allowing for the addition of standard extensions (like multiplication and division, atomic operations, compressed instructions, etc.) or custom extensions tailored to specific applications.

## Project Overview

This project provides a complete Verilog implementation of an RV32I CPU. Due to its non-pipelined design, the CPU executes one instruction per clock cycle. This simplifies the control logic and makes the design easier to understand and verify.

## Key Features

- Implements the RISC-V RV32I base integer instruction set.
- Non-pipelined, single-cycle implementation.
- External Memory writing is available.
- Verilog RTL code for easy simulation and synthesis.
- **Instruction Memory:**
  - Size: 512 words (2KB)
  - Data Width: 32 bits
  - Address Width: 32 bits
  - Initialization: Loads instructions from "test.hex" file.
- **Data Memory:**
  - Size: 64 words (256 Bytes)
  - Data Width: 32 bits
  - Address Width: 32 bits
  - Sign extension for byte and halfword loads.
- **Register File:**
  - Number of Registers: 32 (x0-x31)
  - Data Width: 32 bits
  - 2 read ports, 1 write port.
  - Register x0 is hardwired to 0.

## Implemented Instructions

### Load/Store Instructions
- `lb`: Load byte
- `lh`: Load halfword
- `lw`: Load word
- `lbu`: Load byte unsigned
- `lhu`: Load halfword unsigned
- `sb`: Store byte
- `sh`: Store halfword
- `sw`: Store word

### Arithmetic/Logical Instructions
- `addi`: Add immediate
- `slli`: Shift left logical immediate
- `slti`: Set less than immediate
- `sltiu`: Set less than immediate unsigned
- `xori`: XOR immediate
- `srli`: Shift right logical immediate
- `srai`: Shift right arithmetic immediate
- `ori`: OR immediate
- `andi`: AND immediate
- `add`: Add
- `sub`: Subtract
- `sll`: Shift left logical
- `slt`: Set less than
- `sltu`: Set less than unsigned
- `xor`: XOR
- `srl`: Shift right logical
- `sra`: Shift right arithmetic
- `or`: OR
- `and`: AND
- `lui`: Load upper immediate
- `auipc`: Add upper immediate to PC

### Control Flow Instructions
- `beq`: Branch if equal
- `bne`: Branch if not equal
- `blt`: Branch if less than
- `bge`: Branch if greater than or equal
- `bltu`: Branch if less than unsigned
- `bgeu`: Branch if greater than or equal unsigned
- `jal`: Jump and link
- `jalr`: Jump and link register

## CPU Diagram
![image](https://github.com/user-attachments/assets/44a49023-8b71-45d4-824e-072d31c80c3b)
## Schematic
![Screenshot 2024-12-24 133927](https://github.com/user-attachments/assets/d06557cc-97f7-4eb0-95e0-714caf2b0f29)
## Simulation Results
![Screenshot 2024-12-24 135240](https://github.com/user-attachments/assets/c68604cd-ef3f-4d8c-acad-6f60ee74566f)
# Performace Analysis
Each instruction in the single-cycle processor takes one clock cycle, so the clock cycles per instruction (CPI) is 1.  In the processor, the lw instruction is the most time-consuming and involves the critical path. In a single-cycle processor, every instruction must finish within one clock cycle, so the clock cycle must be long enough to handle the slowest instruction (lw). It involves:\

- Instruction fetch from memory
- Register file read
- Immediate extend
- ALU add to compute address
- Data memory read
- Write back to register file

Hence, the cycle time of the single-cycle processor is:
`T_cycle = t_pcq + t_mem + t_RFread + t_ALU + t_mux + t_RFsetup`

## Getting Started

To get started with this project, you'll need to have a Verilog simulator installed. You can use tools like ModelSim, Xilinx Vivado, or any other Verilog simulation software.

### Prerequisites
- Verilog simulator
- Basic knowledge of Verilog and digital design

### Installation
Clone the repository:
```bash
git clone https://github.com/VinayakPrakashh/RISC_V_SINGLE_CORE.git
cd RISC_V_SINGLE_CORE

