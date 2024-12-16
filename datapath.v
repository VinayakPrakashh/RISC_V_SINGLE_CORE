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
    input  [31:0] instr,
    output [31:0] Mem_WrAddr, Mem_WrData,
    input  [31:0] ReadData,
    output [31:0] Result,SrcA, SrcB
);
wire [31:0] PCNext, PCPlus4, PCTarget,Auipc,lAuiPC,PCjalr;
wire [31:0] ImmExt, WriteData, ALUResult;
//PC
mux_2_1 pcmux(.a(PCPlus4),.b(PCTarget),.sel(PCSrc),.y(PCNext));
ff pcff(.clk(clk),.rst(reset),.d(PCNext),.q(PC));
adder pcadd4(.a(PC),.b(32'd4),.sum(PCPlus4));
adder pcaddbranch(.a(PC), .b(ImmExt), .sum(PCTarget));
register_file rf(.clk(clk),.wr_en(RegWrite),.rd_addr1(instr[19:15]),.rd_addr2(instr[24:20]),.rw_addr(instr[11:7]),.wr_data(Result),.rd_data1(SrcA),.rd_data2(WriteData));
mux_2_1 alumux(.a(WriteData),.b(ImmExt),.sel(ALUSrc),.y(SrcB));
imm iext(.instr(instr),.immSrc(ImmSrc),.Immext(ImmExt));
endmodule
