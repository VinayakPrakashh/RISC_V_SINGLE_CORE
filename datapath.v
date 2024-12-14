module datapath (
    input clk,reset,
    input PCSrc,
    input RegWrite;
    input [31:0] instr,
    output [31:0] PC
);
wire [31:0] PCTarget,PCNext,PCPlus4;
//PC
mux_2_1 pcmux(.a(PCPlus4),.b(0),.sel(0),.y(PCNext));
ff pcff(.clk(clk),.rst(reset),.d(PCNext),.q(PC));
adder pcadd4(.a(PC),.b(32'd4),.sum(PCPlus4));
register_file rf(.clk(clk),.wr_en(RegWrite),.rd_addr1(instr[19:15]),.rd_addr2(instr[24:20]),.rw_addr(instr[11:7]),.wr_data(instr[31:20]),.rd_data1(rd_data1),.rd_data2(rd_data2));
endmodule