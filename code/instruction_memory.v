`timescale 1ns / 1ps
module instr_mem #(
    parameter DATA_WIDTH = 32, ADDR_WIDTH = 32, MEM_SIZE = 512
) (
    input [ADDR_WIDTH-1:0] instruction_address,
    output [DATA_WIDTH-1:0] instruction_data
);
reg [DATA_WIDTH-1:0] memory[0:MEM_SIZE-1];

initial begin
    $readmemh("test.hex",memory); 
end

assign instruction_data = memory[instruction_address[31:2]];
endmodule
