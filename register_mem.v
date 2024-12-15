module register_file #(
    parameter DATA_WIDTH = 32
) (
    input clk,wr_en,
    input [4:0] rd_addr1,rd_addr2,rw_addr,
    input [DATA_WIDTH-1:0] wr_data,
    output [DATA_WIDTH-1:0] rd_data1,rd_data2
);
// Register file
reg [DATA_WIDTH-1:0] register_file[0:31];

//initialization
integer i;
initial begin
    for(i=0;i<32;i=i+1) begin
        register_file[i] = 0;
    end
end
//reg write logic
always @(posedge clk) begin
    if (wr_en) begin register_file[rw_addr] <= wr_data; end
end
//reg read logic
assign read_data1 = (rd_addr1) ? register_file[rd_addr1] : 0;
assign read_data2 = (rd_addr2) ? register_file[rd_addr2] : 0;
endmodule