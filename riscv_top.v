module riscv_top (
    input clk,reset,
    output [31:0] instr
);
wire [31:0] PC,WriteData,ReadData,ALUResult;
wire MemWrite;
instruction_mem im(.instruction_address(PC),.instruction_data(instr));
riscv_cpu rc(.clk(clk),.reset(reset),.PC(PC),.instr(instr),.MemWrite(MemWrite));
data_mem dm(.clk(clk),.wr_en(MemWrite),.rw_addr(ALUResult),.wr_data(WriteData),.rd_data(ReadData));
endmodule
