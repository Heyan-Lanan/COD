//32λALU   WIDTH = 32
//6��ָ���е�ALU��ֻ��Ҫ+����ʵ��
module ALU(
    input [31:0] a,b,
    output [31:0] y
); 
assign y = a + b;
endmodule