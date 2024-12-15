module mux_2_1 #(parameter WIDTH = 32)(
    input [WIDTH-1:0] a,b,
    input sel,
    output [WIDTH-1:0]  y
);

assign y = sel ? b : a;

endmodule