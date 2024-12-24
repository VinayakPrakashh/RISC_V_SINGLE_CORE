module riscv_cpu (
    input         clk, reset,
    output [31:0] PC,
    input  [31:0] Instr,
    output        MemWrite,
    output [31:0] Mem_WrAddr, Mem_WrData,
    input  [31:0] ReadData,
    output [31:0] Result
);
wire        funct7b5,ALUSrc, RegWrite, Jump, jalr,Zero,ALUR31;
wire [1:0]  ResultSrc, ImmSrc;
wire [2:0]  ALUControl,funct3;

controller  c   (Instr[6:0], funct3, funct7b5, Zero,ALUR31,
                ResultSrc, MemWrite, PCSrc, ALUSrc, RegWrite, Jump,jalr,
                ImmSrc, ALUControl);

datapath    dp  (clk, reset, ResultSrc, PCSrc,
                ALUSrc, RegWrite, ImmSrc, ALUControl,jalr,
                Zero, ALUR31,PC, Instr, Mem_WrAddr, Mem_WrData, ReadData, Result);
assign funct3 = Instr[14:12];
assign funct7b5 = Instr[30];
endmodule