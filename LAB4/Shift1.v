//立即数左移一位模块
module shift1(
    input [31:0] in,
    output [31:0] out
);
assign out = in << 1;
endmodule