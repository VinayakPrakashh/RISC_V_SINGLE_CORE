# ========================
# I-type: arithmetic immediates
# ========================
addi x1, x0, 10       # x1 = 10
addi x2, x0, 20       # x2 = 20
andi x3, x1, 5        # x3 = x1 & 5
ori  x4, x2, 1        # x4 = x2 | 1
xori x5, x1, 3        # x5 = x1 ^ 3
slti x6, x1, 15       # x6 = (x1 < 15)
sltiu x7, x1, 15      # x7 = (x1 < 15 unsigned)
slli x8, x1, 2        # x8 = x1 << 2
srli x9, x2, 1        # x9 = x2 >> 1
srai x10, x2, 1       # x10 = x2 >>> 1

