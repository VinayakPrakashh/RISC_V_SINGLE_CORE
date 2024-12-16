module riscv_cpu (
    input clk,reset,
    output [31:0] PC,
    input [31:0] instr,
    output MemWrite,
    output [31:0] SrcA,SrcB
);
wire        ALUSrc, RegWrite, Jump, jalr,Zero,ALUR31;
wire [1:0]  ResultSrc, ImmSrc;
wire [2:0]  ALUControl;
datapath dp(.clk(clk),.reset(reset),.ResultSrc(ResultSrc),.PCSrc(PCSrc),.ALUSrc(ALUSrc),.RegWrite(RegWrite),.ImmSrc(ImmSrc),.ALUControl(ALUControl),.jalr(jalr),.Zero(Zero),.ALUR31(ALUR31),.PC(PC),.instr(instr),.SrcA(SrcA),.SrcB(SrcB));

controller ct(.op(instr[6:0]),.funct3(instr[14:12]),.funct7b5(instr[30]),.Zero(Zero),.ALUR31(ALUR31),.PCSrc(PCSrc),.RegWrite(RegWrite),.MemWrite(MemWrite),.jump(Jump),.ALUSrc(ALUSrc),.jalr(jalr),.ResultSrc(ResultSrc),.immSrc(ImmSrc),.AluControl(ALUControl));
endmodule