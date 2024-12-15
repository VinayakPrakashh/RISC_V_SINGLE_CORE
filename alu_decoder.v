module alu_decoder (
    input  opb5,
    input [2:0] funct3,
    input funct7b5,
    input [1:0] aluOp,
    output reg [2:0] AluControl
);
always @(*) begin
    case(aluOp)
    2'b00: begin AluControl = 3'b000; end //add
    2'b01: begin AluControl = 3'b001; end //sub
    default: begin //for R,I
        case(funct3)
        3'b000: begin if(funct7b5 & opb5) AluControl = 3'b001;  //sub
                      else                AluControl = 3'b000; end //add
        3'b001: begin AluControl = 3'b100; end //sll slli
        3'b010: begin AluControl = 3'b101; end //slt slti
        3'b011: begin AluControl = 3'b101; end //sltu sltiu
        3'b100: begin AluControl = 3'b111; end //xor xori
        3'b101: begin AluControl = 3'b110; end //srl srl sra srai
        3'b110: begin AluControl = 3'b011; end //or ori
        3'b111: begin AluControl = 3'b010; end //and andi
        default:begin AluControl = 3'bxxx; end //??
        endcase
    end
    endcase
end
endmodule