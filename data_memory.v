module moduleName #(
    parameter DATA_WIDTH = 32,ADDR_WIDTH = 32,MEM_SIZE = 64;
) (
    input clk,wr_en;
    input [ADDR_WIDTH-1:0] rw_addr;
    input [DATA_WIDTH-1:0] wr_data;
    output [DATA_WIDTH-1:0] rd_data;
);
// Data memory
reg [DATA_WIDTH-1:0] memory[0:MEM_SIZE-1];

wire [ADDR_WIDTH-1:0] word_addr = rw_addr[ADDR_WIDTH-1:2] % 64;

assign rd_data = memory[word_addr];

always @(posedge clk) begin
    if (wr_en) begin memory[word_addr] <= wr_data; end
end

endmodule