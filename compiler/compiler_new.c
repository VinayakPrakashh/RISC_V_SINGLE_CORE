#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

uint32_t encode_lb(uint8_t rd, uint8_t rs1, int16_t imm) {
    uint32_t opcode = 0b0000011;
    uint32_t funct3 = 0b000;

    uint32_t instr = 0;
    instr |= ((imm & 0xFFF) << 20);
    instr |= ((rs1 & 0x1F) << 15);
    instr |= (funct3 << 12);
    instr |= ((rd & 0x1F) << 7);
    instr |= opcode;

    return instr;
}

int get_reg_number(const char* reg) {
    if (reg[0] != 'x') return -1;
    return atoi(reg + 1);
}

int main() {
    FILE *fp = fopen("program.asm", "r");
    if (!fp) {
        perror("Error opening file");
        return 1;
    }

    char line[128];
    while (fgets(line, sizeof(line), fp)) {
        char op[8], rd_str[8], rs1_str[8];
        int imm;

        // Match pattern: lb x5, 8(x1)
        if (sscanf(line, "%s %[^,], %d(%[^)])", op, rd_str, &imm, rs1_str) == 4) {
            if (strcmp(op, "lb") == 0) {
                int rd = get_reg_number(rd_str);
                int rs1 = get_reg_number(rs1_str);

                if (rd >= 0 && rs1 >= 0) {
                    uint32_t instr = encode_lb(rd, rs1, imm);
                    printf("0x%08X\n", instr);
                } else {
                    fprintf(stderr, "Invalid register in line: %s", line);
                }
            } else {
                fprintf(stderr, "Unsupported instruction: %s\n", op);
            }
        } else {
            fprintf(stderr, "Invalid format: %s", line);
        }
    }

    fclose(fp);
    return 0;
}
