module riscv_top (
    input clk,reset,
);
wire [31:0] instr,PC;
instruction_mem im(.instruction_address(PC),.instruction_data(instr));
riscv_cpu rvcpu(.clk(clk),.reset(reset),.PC(PC),.instr(instr));
endmodule