//取指寄存器,地址为32位
//指令地址从0x0000_3000开始
module PC(
    input clk,rst,
    input [31:0] in,
    output reg [31:0] out
);
initial out = 32'h0000_3000;
always @(posedge clk or posedge rst) 
begin
    if(rst)
        out <= 32'h0000_3000;
    else
        out <= in;  
end
endmodule
