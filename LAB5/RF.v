//32个x32位寄存器堆
//一个同步写端口，三个异步读端口
module RF(   
        input clk,we,                  //时钟、同步写使能
        input [4:0] wa,                 //同步写地址
        input [31:0] wd,           //同步写数据
        input [4:0] ra0,ra1,ra2,         //异步读地址
        output [31:0] rd0,rd1,rd2  //异步读数据
);

//寄存器存储块
reg  [31:0]regfile[0:31];
integer i;
//异步读地址
assign rd0 = regfile[ra0];
assign rd1 = regfile[ra1];
assign rd2 = regfile[ra2];

initial 
begin
for(i = 0; i < 32; i=i+1)
    regfile[i]=32'h00000000;
end

//下降沿写，上升沿读出，已解决结构相关
always@(negedge clk) 
begin
    if (we && (wa!=5'b00000) )  
        regfile[wa]  <=  wd;
end
endmodule