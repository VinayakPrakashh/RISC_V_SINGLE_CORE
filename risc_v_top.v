module risc_v_top (
    input clk,reset,
    output [31:0] instr
);
wire PCSrc;
wire [31:0] PC,PCTarget,PCNext,PCPlus4;
//PC
mux_2_1 pcmux(.a(PCPlus4),.b(0),.sel(0),.y(PCNext));
ff pcff(.clk(clk),.rst(reset),.d(PCNext),.q(PC));
adder pcadd4(.a(PC),.b(32'd4),.sum(PCPlus4));
instruction_mem im(.instruction_address(PC),.instruction_data(instr));
endmodule