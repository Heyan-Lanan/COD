//取指寄存器,地址为32位
//指令地址从0x0000_0000开始
module PC(
    input clk,rst,
    input enable, //来自HU的控制信号
    input [31:0] in,
    output reg [31:0] out
);
initial out = 32'h0000_3000;//上板子
//initial out = 32'h0000_0000;//仿真
always @(posedge clk or posedge rst) 
begin
    if(rst)
        //out <= 32'h0000_0000;
        out <= 32'h0000_3000;
    else if(enable)
        out <= in;  
    else 
        out <= out;
end
endmodule