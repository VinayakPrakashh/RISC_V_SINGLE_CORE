module main_decoder (
    input [6:0] op,
    input [2:0] funct3,
    input Zero,
    input ALUR31,
    output RegWrite,MemWrite,ALUSrc,
    output [1:0] immSrc,ResultSrc,
    output Branch,jump,jalr,
    output [1:0] aluOp
);
    reg [10:0] controls;
    reg Takebranch;

always @(*) begin
Takebranch=0;
    casez (op)
    
        // RegWrite_ImmSrc_ALUSrc_MemWrite_ResultSrc_ALUOp_Jump_jalr
        7'b0000011: controls = 11'b1_00_1_0_01_00_0_0; // lw
        7'b0100011: controls = 11'b0_01_1_1_00_00_0_0; // sw
        7'b0110011: controls = 11'b1_xx_0_0_00_10_0_0; // R–type
        7'b1100011: begin //branch
		  controls = 11'b0_10_0_0_00_01_0_0; 
		  case(funct3)
		  3'b000: Takebranch =Zero;
		  3'b001: Takebranch =!Zero;
		  3'b111: Takebranch =!ALUR31;
		  3'b101: Takebranch =!ALUR31;
		  3'b100: Takebranch =ALUR31;
		  3'b110: Takebranch =ALUR31;
		  endcase
		  
		  end
        7'b0010011: controls = 11'b1_00_1_0_00_10_0_0; // I–type ALU
		  7'b0?10111: controls = 11'b1_xx_x_0_11_xx_0_0;  //lui or auipc
		  7'b1100111: controls = 11'b1_00_1_0_10_00_0_1;  //jalr 
        7'b1101111: controls = 11'b1_11_0_0_10_00_1_0; // jal
        default:    controls = 11'bx_xx_x_x_xx_xx_x_x; // ???
    endcase
end
assign Branch = Takebranch;
assign {RegWrite,immSrc,ALUSrc,MemWrite,ResultSrc,aluOp,jump,jalr} = controls;
endmodule