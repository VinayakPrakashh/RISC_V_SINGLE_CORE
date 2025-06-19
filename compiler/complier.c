#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int reg_num(const char *reg) {
    if (reg[0] == 'x') return atoi(reg + 1);
    return -1;
}

unsigned int encode_rtype(int opcode, int rd, int funct3, int rs1, int rs2, int funct7) {
    return (funct7 << 25) | (rs2 << 20) | (rs1 << 15) |
           (funct3 << 12) | (rd << 7) | opcode;
}

unsigned int encode_itype(int opcode, int rd, int funct3, int rs1, int imm) {
    return ((imm & 0xFFF) << 20) | (rs1 << 15) |
           (funct3 << 12) | (rd << 7) | opcode;
}

unsigned int encode_stype(int opcode, int funct3, int rs1, int rs2, int imm) {
    int imm11_5 = (imm >> 5) & 0x7F;
    int imm4_0 = imm & 0x1F;
    return (imm11_5 << 25) | (rs2 << 20) | (rs1 << 15) |
           (funct3 << 12) | (imm4_0 << 7) | opcode;
}

unsigned int encode_btype(int opcode, int funct3, int rs1, int rs2, int imm) {
    int imm12 = (imm >> 12) & 0x1;
    int imm10_5 = (imm >> 5) & 0x3F;
    int imm4_1 = (imm >> 1) & 0xF;
    int imm11 = (imm >> 11) & 0x1;

    return (imm12 << 31) | (imm11 << 7) | (imm10_5 << 25) |
           (rs2 << 20) | (rs1 << 15) | (funct3 << 12) |
           (imm4_1 << 8) | opcode;
}

unsigned int encode_utype(int opcode, int rd, int imm) {
    return (imm << 12) | (rd << 7) | opcode;
}

unsigned int encode_jtype(int opcode, int rd, int imm) {
    int imm20 = (imm >> 20) & 0x1;
    int imm10_1 = (imm >> 1) & 0x3FF;
    int imm11 = (imm >> 11) & 0x1;
    int imm19_12 = (imm >> 12) & 0xFF;

    return (imm20 << 31) | (imm19_12 << 12) |
           (imm11 << 20) | (imm10_1 << 21) |
           (rd << 7) | opcode;
}

void trim_newline(char *line) {
    line[strcspn(line, "\n")] = 0;
}

int main() {
    FILE *fin = fopen("program.asm", "r");
    FILE *fout = fopen("output.hex", "w");
    if (!fin || !fout) {
        perror("File error");
        return 1;
    }

    char line[100];
    while (fgets(line, sizeof(line), fin)) {
        trim_newline(line);

        char instr[10], r1[10], r2[10], r3[10];
        int rd, rs1, rs2, imm;
        unsigned int encoded = 0;

        // R-type
        if (sscanf(line, "%s %[^,], %[^,], %s", instr, r1, r2, r3) == 4) {
            rd = reg_num(r1);
            rs1 = reg_num(r2);
            rs2 = reg_num(r3);

            if (strcmp(instr, "add") == 0)
                encoded = encode_rtype(0x33, rd, 0x0, rs1, rs2, 0x00);
            else if (strcmp(instr, "sub") == 0)
                encoded = encode_rtype(0x33, rd, 0x0, rs1, rs2, 0x20);
        }

        // I-type: addi, jalr
        else if (sscanf(line, "%s %[^,], %[^,], %d", instr, r1, r2, &imm) == 4) {
            rd = reg_num(r1);
            rs1 = reg_num(r2);

            if (strcmp(instr, "addi") == 0)
                encoded = encode_itype(0x13, rd, 0x0, rs1, imm);
            else if (strcmp(instr, "jalr") == 0)
                encoded = encode_itype(0x67, rd, 0x0, rs1, imm);
        }

        // I-type: lw
        else if (sscanf(line, "%s %[^,], %d(%[^)])", instr, r1, &imm, r2) == 4) {
            rd = reg_num(r1);
            rs1 = reg_num(r2);

            if (strcmp(instr, "lw") == 0)
                encoded = encode_itype(0x03, rd, 0x2, rs1, imm);
        }

        // S-type: sw
        else if (sscanf(line, "%s %[^,], %d(%[^)])", instr, r1, &imm, r2) == 4) {
            rs2 = reg_num(r1);
            rs1 = reg_num(r2);

            if (strcmp(instr, "sw") == 0)
                encoded = encode_stype(0x23, 0x2, rs1, rs2, imm);
        }

        // B-type: beq, bne
        else if (sscanf(line, "%s %[^,], %[^,], %d", instr, r1, r2, &imm) == 4) {
            rs1 = reg_num(r1);
            rs2 = reg_num(r2);

            if (strcmp(instr, "beq") == 0)
                encoded = encode_btype(0x63, 0x0, rs1, rs2, imm);
            else if (strcmp(instr, "bne") == 0)
                encoded = encode_btype(0x63, 0x1, rs1, rs2, imm);
        }

        // U-type: lui, auipc
        else if (sscanf(line, "%s %[^,], %d", instr, r1, &imm) == 3) {
            rd = reg_num(r1);
            if (strcmp(instr, "lui") == 0)
                encoded = encode_utype(0x37, rd, imm);
            else if (strcmp(instr, "auipc") == 0)
                encoded = encode_utype(0x17, rd, imm);
        }

        // J-type: jal
        else if (sscanf(line, "%s %[^,], %d", instr, r1, &imm) == 3) {
            rd = reg_num(r1);
            if (strcmp(instr, "jal") == 0)
                encoded = encode_jtype(0x6F, rd, imm);
        }

        fprintf(fout, "%08x\n", encoded);
    }

    fclose(fin);
    fclose(fout);
    printf("Compilation complete: output.hex generated.\n");
    return 0;
}
