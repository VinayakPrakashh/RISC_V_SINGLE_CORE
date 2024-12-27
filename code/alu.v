module alu #(parameter WIDTH = 32) (
    input [WIDTH-1:0] a, b,
    input [2:0] ALUControl,
    output reg [WIDTH-1:0] Result,
    output Zero,
    input funct7b6, funct3_bit
);

always @(*) begin
    case(ALUControl)
        3'b000: Result = a + b; // ADD
        3'b001: Result = a - b; // SUB
        3'b010: Result = a & b; // AND
        3'b011: Result = a | b; // OR
        3'b100: Result = a << b[4:0]; // SLL
        3'b101: case (funct3_bit)

            1'b0:begin//SLT
                if(a[31]!= b[31]) Result = a[31] ?1:0; 
                else Result = (a < b) ? 1:0;
            end 
            1'b1: Result <= (a < {20'b0, b[11:0]}) ? 1 : 0; // SLTU
                endcase
        3'b110: begin
            if(funct7b6) Result = a >> b[4:0]; // SRL
            else Result = a >>> b[4:0]; // SRA
        end
        3'b111: Result = a ^ b; // XOR
        default: Result = 32'b0;
        endcase
end

assign Zero = (Result == 0)?1:0;

endmodule