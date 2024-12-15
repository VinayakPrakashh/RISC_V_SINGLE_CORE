module controller (
    input [6:0] op,
    input [2:0] funct3,
    input funct7b5,
    input Zero,ALUR31,
    output PCSrc,RegWrite,MemWrite,jump,ALUSrc,jalr,
    output [1:0] ResultSrc,
    output [1:0] immSrc,
    output [2:0] AluControl

);
wire [1:0] aluOp;
wire Branch;
    main_decoder md(.op(op),.funct3(funct3),.Zero(Zero),.ALUR31(ALUR31),
                    .RegWrite(RegWrite),.MemWrite(MemWrite),.ALUSrc(ALUSrc),.ResultSrc(ResultSrc),
                    .immSrc(immSrc),.Branch(Branch),.jump(jump),.jalr(jalr),.aluOp(aluOp));
    alu_decoder ad(.opb5(op[5]),.funct3(funct3),.funct7b5(funct7b5),.aluOp(aluOp),.AluControl(AluControl));
assign PCSrc = Branch | jump;
endmodule
