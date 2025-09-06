#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

// ======================= ENCODERS =======================

// R-type encoder
uint32_t encode_rtype(int funct7, int rs2, int rs1, int funct3, int rd, int opcode) {
    uint32_t instr = 0;
    instr |= ((funct7 & 0x7F) << 25);
    instr |= ((rs2   & 0x1F) << 20);
    instr |= ((rs1   & 0x1F) << 15);
    instr |= ((funct3& 0x07) << 12);
    instr |= ((rd    & 0x1F) << 7);
    instr |=  (opcode & 0x7F);
    return instr;
}

// I-type encoder
uint32_t encode_itype(int imm, int rs1, int funct3, int rd, int opcode, int funct7, int is_shift) {
    uint32_t instr = 0;
    if (is_shift) {
        instr |= ((funct7 & 0x7F) << 25);
        instr |= ((imm    & 0x1F) << 20); // shamt
    } else {
        instr |= ((imm & 0xFFF) << 20);
    }
    instr |= ((rs1   & 0x1F) << 15);
    instr |= ((funct3& 0x07) << 12);
    instr |= ((rd    & 0x1F) << 7);
    instr |=  (opcode & 0x7F);
    return instr;
}

// S-type encoder
uint32_t encode_stype(int imm, int rs2, int rs1, int funct3, int opcode) {
    uint32_t instr = 0;
    int imm11_5 = (imm >> 5) & 0x7F;
    int imm4_0  = imm & 0x1F;

    instr |= (imm11_5 << 25);
    instr |= ((rs2    & 0x1F) << 20);
    instr |= ((rs1    & 0x1F) << 15);
    instr |= ((funct3 & 0x07) << 12);
    instr |= (imm4_0 << 7);
    instr |= (opcode & 0x7F);
    return instr;
}

// B-type encoder
uint32_t encode_btype(int imm, int rs2, int rs1, int funct3, int opcode) {
    uint32_t instr = 0;

    int imm12   = (imm >> 12) & 0x1;
    int imm10_5 = (imm >> 5) & 0x3F;
    int imm4_1  = (imm >> 1) & 0xF;
    int imm11   = (imm >> 11) & 0x1;

    instr |= (imm12   << 31);
    instr |= (imm10_5 << 25);
    instr |= ((rs2    & 0x1F) << 20);
    instr |= ((rs1    & 0x1F) << 15);
    instr |= ((funct3 & 0x07) << 12);
    instr |= (imm4_1  << 8);
    instr |= (imm11   << 7);
    instr |= (opcode & 0x7F);

    return instr;
}

// J-type encoder
uint32_t encode_jtype(int imm, int rd, int opcode) {
    uint32_t instr = 0;

    int imm20    = (imm >> 20) & 0x1;
    int imm10_1  = (imm >> 1) & 0x3FF;
    int imm11    = (imm >> 11) & 0x1;
    int imm19_12 = (imm >> 12) & 0xFF;

    instr |= (imm20    << 31);
    instr |= (imm19_12 << 12);
    instr |= (imm11    << 20);
    instr |= (imm10_1  << 21);
    instr |= ((rd      & 0x1F) << 7);
    instr |= (opcode & 0x7F);

    return instr;
}

// ======================= TABLES =======================

typedef struct {
    char name[10];
    int funct7;
    int funct3;
    int opcode;
} RInstrInfo;

typedef struct {
    char name[10];
    int funct3;
    int funct7;
    int opcode;
    int is_shift;
} IInstrInfo;

typedef struct {
    char name[10];
    int funct3;
    int opcode;
} SInstrInfo;

typedef struct {
    char name[10];
    int funct3;
    int opcode;
} BInstrInfo;

typedef struct {
    char name[10];
    int opcode;
} JInstrInfo;

// R-type
RInstrInfo rtype_table[] = {
    {"add",  0x00, 0x0, 0x33},
    {"sub",  0x20, 0x0, 0x33},
    {"sll",  0x00, 0x1, 0x33},
    {"slt",  0x00, 0x2, 0x33},
    {"sltu", 0x00, 0x3, 0x33},
    {"xor",  0x00, 0x4, 0x33},
    {"srl",  0x00, 0x5, 0x33},
    {"sra",  0x20, 0x5, 0x33},
    {"or",   0x00, 0x6, 0x33},
    {"and",  0x00, 0x7, 0x33},
};
int rtable_size = sizeof(rtype_table)/sizeof(rtype_table[0]);

// I-type
IInstrInfo itype_table[] = {
    {"lb",   0x0, 0x00, 0x03, 0},
    {"lh",   0x1, 0x00, 0x03, 0},
    {"lw",   0x2, 0x00, 0x03, 0},
    {"lbu",  0x4, 0x00, 0x03, 0},
    {"lhu",  0x5, 0x00, 0x03, 0},

    {"addi", 0x0, 0x00, 0x13, 0},
    {"slti", 0x2, 0x00, 0x13, 0},
    {"sltiu",0x3, 0x00, 0x13, 0},
    {"xori", 0x4, 0x00, 0x13, 0},
    {"ori",  0x6, 0x00, 0x13, 0},
    {"andi", 0x7, 0x00, 0x13, 0},

    {"slli", 0x1, 0x00, 0x13, 1},
    {"srli", 0x5, 0x00, 0x13, 1},
    {"srai", 0x5, 0x20, 0x13, 1},

    {"jalr", 0x0, 0x00, 0x67, 0},
};
int itable_size = sizeof(itype_table)/sizeof(itype_table[0]);

// S-type
SInstrInfo stype_table[] = {
    {"sb", 0x0, 0x23},
    {"sh", 0x1, 0x23},
    {"sw", 0x2, 0x23},
};
int stable_size = sizeof(stype_table)/sizeof(stype_table[0]);

// B-type
BInstrInfo btype_table[] = {
    {"beq",  0x0, 0x63},
    {"bne",  0x1, 0x63},
    {"blt",  0x4, 0x63},
    {"bge",  0x5, 0x63},
    {"bltu", 0x6, 0x63},
    {"bgeu", 0x7, 0x63},
};
int btable_size = sizeof(btype_table)/sizeof(btype_table[0]);

// J-type
JInstrInfo jtype_table[] = {
    {"jal", 0x6F},
};
int jtable_size = sizeof(jtype_table)/sizeof(jtype_table[0]);

// ======================= PARSER =======================

void process_line(char *line, FILE *out) {
    char instr[10];
    int rd, rs1, rs2, imm;

    // Remove newline
    line[strcspn(line, "\n")] = 0;

    // Ignore comments and empty lines
    if (line[0] == '#' || line[0] == '\0') {
        return;
    }

    // ---------- R-type ----------
    if (sscanf(line, "%s x%d, x%d, x%d", instr, &rd, &rs1, &rs2) == 4) {
        for (int i = 0; i < rtable_size; i++) {
            if (strcmp(instr, rtype_table[i].name) == 0) {
                uint32_t machine = encode_rtype(
                    rtype_table[i].funct7,
                    rs2, rs1,
                    rtype_table[i].funct3,
                    rd,
                    rtype_table[i].opcode
                );
                fprintf(out, "%08X\n", machine);
                return;
            }
        }
    }

    // ---------- I-type (no shift) ----------
    if (sscanf(line, "%s x%d, %d(x%d)", instr, &rd, &imm, &rs1) == 4) {
        for (int i = 0; i < itable_size; i++) {
            if (strcmp(instr, itype_table[i].name) == 0) {
                uint32_t machine = encode_itype(
                    imm, rs1,
                    itype_table[i].funct3,
                    rd,
                    itype_table[i].opcode,
                    itype_table[i].funct7,
                    0
                );
                fprintf(out, "%08X\n", machine);
                return;
            }
        }
    }

    // ---------- I-type (shift) ----------
    if (sscanf(line, "%s x%d, x%d, %d", instr, &rd, &rs1, &imm) == 4) {
        for (int i = 0; i < itable_size; i++) {
            if (strcmp(instr, itype_table[i].name) == 0) {
                uint32_t machine = encode_itype(
                    imm, rs1,
                    itype_table[i].funct3,
                    rd,
                    itype_table[i].opcode,
                    itype_table[i].funct7,
                    itype_table[i].is_shift
                );
                fprintf(out, "%08X\n", machine);
                return;
            }
        }
    }

    // ---------- S-type ----------
    if (sscanf(line, "%s x%d, %d(x%d)", instr, &rs2, &imm, &rs1) == 4) {
        for (int i = 0; i < stable_size; i++) {
            if (strcmp(instr, stype_table[i].name) == 0) {
                uint32_t machine = encode_stype(
                    imm, rs2, rs1,
                    stype_table[i].funct3,
                    stype_table[i].opcode
                );
                fprintf(out, "%08X\n", machine);
                return;
            }
        }
    }

    // ---------- B-type ----------
    if (sscanf(line, "%s x%d, x%d, %d", instr, &rs1, &rs2, &imm) == 4) {
        for (int i = 0; i < btable_size; i++) {
            if (strcmp(instr, btype_table[i].name) == 0) {
                uint32_t machine = encode_btype(
                    imm, rs2, rs1,
                    btype_table[i].funct3,
                    btype_table[i].opcode
                );
                fprintf(out, "%08X\n", machine);
                return;
            }
        }
    }

    // ---------- J-type ----------
    if (sscanf(line, "%s x%d, %d", instr, &rd, &imm) == 3) {
        for (int i = 0; i < jtable_size; i++) {
            if (strcmp(instr, jtype_table[i].name) == 0) {
                uint32_t machine = encode_jtype(
                    imm, rd,
                    jtype_table[i].opcode
                );
                fprintf(out, "%08X\n", machine);
                return;
            }
        }
    }

    fprintf(out, "// Unknown instruction: %s\n", line);
}

// ======================= MAIN =======================

int main() {
    FILE *fp, *out;
    char line[256];
// open the input file
    fp = fopen("program.asm", "r");
    if (fp == NULL) {
        printf("Error: cannot open input file\n");
        return 1;
    }
else{
    printf("Input file found\n");
    }
// Open or create output file
    out = fopen("program.hex", "w");
    if (out == NULL) {
        printf("Output file created\n");
        fclose(fp);
        return 1;
    }
    else{
        printf("Output file opened\n");
    }
// process file
    printf("Processing line by line...\n");
    while (fgets(line, sizeof(line), fp)) {
        process_line(line, out);
    }
    printf("Machine code generated\n");
    fclose(fp);
    fclose(out);

    printf("Machine code written to program.hex\n");
    printf("Enjoy!!");
    return 0;
}
