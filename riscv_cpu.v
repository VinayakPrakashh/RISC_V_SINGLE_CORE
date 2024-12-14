module riscv_cpu (
    input clk,reset,
    output [31:0] PC,
    input [31:0] instr
);

datapath dp(.clk(clk),.reset(reset),.PCSrc(PCSrc),.RegWrite(RegWrite),.instr(instr),.PC(PC));
endmodule