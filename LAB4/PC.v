//ȡָ�Ĵ���,��ַΪ32λ
//ָ���ַ��0x0000_3000��ʼ
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
