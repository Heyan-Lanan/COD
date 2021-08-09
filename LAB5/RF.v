//32��x32λ�Ĵ�����
//һ��ͬ��д�˿ڣ������첽���˿�
module RF(   
        input clk,we,                  //ʱ�ӡ�ͬ��дʹ��
        input [4:0] wa,                 //ͬ��д��ַ
        input [31:0] wd,           //ͬ��д����
        input [4:0] ra0,ra1,ra2,         //�첽����ַ
        output [31:0] rd0,rd1,rd2  //�첽������
);

//�Ĵ����洢��
reg  [31:0]regfile[0:31];
integer i;
//�첽����ַ
assign rd0 = regfile[ra0];
assign rd1 = regfile[ra1];
assign rd2 = regfile[ra2];

initial 
begin
for(i = 0; i < 32; i=i+1)
    regfile[i]=32'h00000000;
end

//�½���д�������ض������ѽ���ṹ���
always@(negedge clk) 
begin
    if (we && (wa!=5'b00000) )  
        regfile[wa]  <=  wd;
end
endmodule