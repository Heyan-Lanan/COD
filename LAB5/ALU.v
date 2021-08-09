//32位ALU   WIDTH = 32
//6条指令中的ALU均只需要+，简化实现
module ALU(
    input [31:0] a,b,
    output [31:0] y
); 
assign y = a + b;
endmodule