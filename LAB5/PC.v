//ȡָ�Ĵ���,��ַΪ32λ
//ָ���ַ��0x0000_0000��ʼ
module PC(
    input clk,rst,
    input enable, //����HU�Ŀ����ź�
    input [31:0] in,
    output reg [31:0] out
);
initial out = 32'h0000_3000;//�ϰ���
//initial out = 32'h0000_0000;//����
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