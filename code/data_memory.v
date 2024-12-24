module data_mem #(
    parameter DATA_WIDTH = 32,ADDR_WIDTH = 32,MEM_SIZE = 64
) (
    input clk,wr_en,
    input [2:0] funct3,
    input [ADDR_WIDTH-1:0] wr_addr,
    input [DATA_WIDTH-1:0] wr_data,
    output reg [DATA_WIDTH-1:0] rd_data_mem
);
// Data memory
reg [DATA_WIDTH-1:0] data_ram[0:MEM_SIZE-1];

wire [ADDR_WIDTH-1:0] word_addr = wr_addr[ADDR_WIDTH-1:2] % 64;

always @(posedge clk) begin
 
    if (wr_en) begin
        case (funct3)
            3'b000:   begin 
                data_ram[word_addr][7:0] <= wr_data[7:0];
            end
            3'b001: begin 
                data_ram[word_addr][15:0] <= wr_data[15:0];
            end
            3'b010:   begin 
                data_ram[word_addr] <= wr_data;
            end
        endcase 
        end
        end
always @(*) begin
    case (funct3)
        3'b000:rd_data_mem = {{24{data_ram[word_addr][7]}},data_ram[word_addr][7:0]};
        3'b001:rd_data_mem = {{16{data_ram[word_addr][15]}},data_ram[word_addr][15:0]};
        3'b010:rd_data_mem = data_ram[word_addr];
        3'b100:rd_data_mem = {24'b0,data_ram[word_addr][7:0]};
        3'b101:rd_data_mem = {16'b0,data_ram[word_addr][15:0]};
    endcase
end
endmodule    