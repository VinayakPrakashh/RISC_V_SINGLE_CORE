module imm (
    input [31:7] instr,
    input [1:0] immSrc,
    output reg  [31:0] Immext 
);
    always @(*) begin
    case(immSrc)
        // I−type
        2'b00:   Immext = {{20{instr[31]}}, instr[31:20]};
        // S−type (stores)
        2'b01:   Immext = {{20{instr[31]}}, instr[31:25], instr[11:7]};
        // B−type (branches)
        2'b10:   Immext = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0};
        // J−type (jal)
        2'b11:   Immext = {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0};
        default: Immext = 32'bx; // undefined
    endcase
end
endmodule