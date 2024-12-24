	module datapath(
    input         clk, reset,
    input [1:0]   ResultSrc,
    input         PCSrc, ALUSrc,
    input         RegWrite,
    input [1:0]   ImmSrc,
    input [2:0]   ALUControl,
	 input         jalr,
    output        Zero,ALUR31,
    output [31:0] PC,
    input  [31:0] Instr,
    output [31:0] Mem_WrAddr, Mem_WrData,
    input  [31:0] ReadData,
    output [31:0] Result,SrcA,SrcB
);
wire [31:0] PCPlus4, PCTarget, PCNext,WriteData,ImmExt,ALUResult;
wire [31:0] Auipc,lAuipc,rs1,rs2,rd,PCjalr;
mux2  pcmux(PCPlus4, PCTarget, PCSrc, PCNext);
mux2 jalrmux(PCNext, ALUResult, jalr, PCjalr);
reset_ff pcff(clk, reset,PCjalr,PC);
adder pcadd4(PC, 32'd4, PCPlus4);

reg_file  rf (clk, RegWrite, rs1, rs2, rd, Result, SrcA, WriteData);
imm_extend imm( Instr[31:7], ImmSrc,ImmExt);
adder pcaddbranch(PC, ImmExt, PCTarget);
mux2  srcbmux(WriteData, ImmExt, ALUSrc, SrcB);

alu alu( SrcA, SrcB, ALUControl, ALUResult, Zero, Instr[30], Instr[12]);
adder auipcadder({Instr[31:12],12'b0},PC,Auipc);
mux2 luipcmux({Instr[31:12],12'b0},Auipc,Instr[5],lAuipc);
mux4 Resmux(ALUResult, ReadData, PCPlus4,lAuipc, ResultSrc, Result);

assign Mem_WrAddr = ALUResult;
assign Mem_WrData = WriteData;
assign ALUR31 = ALUResult[31];


//instr assignments
assign rs1 = Instr[19:15];
assign rs2 = Instr[24:20];
assign rd = Instr[11:7];
endmodule