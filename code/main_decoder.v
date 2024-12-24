module main_decoder (
    input  [6:0] op,
	 input  [2:0] funct3,
	 input        Zero,ALUR31,
    output [1:0] ResultSrc,
    output       MemWrite, Branch, ALUSrc,
    output       RegWrite, Jump,jalr,
    output [1:0] ImmSrc,
    output [1:0] ALUOp
);
reg [10:0] controls;
reg Takebranch;

always @(*) begin
    Takebranch = 0;
    casez (op)
        // RegWrite_ImmSrc_ALUSrc_MemWrite_ResultSrc_ALUOp_Jump_jalr
        7'b0000011: controls = 11'b1_00_1_0_01_00_0_0; // lw
        7'b0100011: controls = 11'b0_01_1_1_00_00_0_0; // sw
        7'b0110011: controls = 11'b1_xx_0_0_00_10_0_0; // R–type
        7'b1100011: begin //branch
		  controls = 11'b0_10_0_0_00_01_0_0; 
		  case(funct3)
		  3'b000: Takebranch =Zero;//beq
		  3'b001: Takebranch =!Zero;//bne
		  3'b111: Takebranch =!ALUR31;//blt
		  3'b101: Takebranch =!ALUR31;//bltu
		  3'b100: Takebranch =ALUR31;//bge
		  3'b110: Takebranch =ALUR31;//bgeu
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
assign {RegWrite, ImmSrc, ALUSrc, MemWrite, ResultSrc, ALUOp, Jump,jalr} = controls;
endmodule