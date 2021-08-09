module cputest(
    input clk,
    input rst,

    //选择CPU工作方式;
    input run, 
    input step,

    //输入switch的端口
    input valid,
    input [4:0] in,

    //输出led和seg的端口 
    output [1:0] check,   //led6-5:查看类型
    output [4:0] out0,    //led4-0
    output [2:0] an,      //8个数码管
    output [3:0] seg,
    output ready          //led7
);

//IO_BUS
wire [7:0] io_addr;  //IO外设地址
wire [31:0] io_dout; //CPU输出的数据
wire io_we;          //CPU向led和seg输出时的使能信号
wire [31:0] io_din; //CPU接收的sw输入数据

//Debug_BUS
wire [7:0] m_rf_addr; //向CPU输出DM/RF地址
wire [31:0] rf_data;  //返回的RF的数据
wire [31:0] m_data;    //返回DM的数据
wire [31:0] pc;         //返回指令地址
wire clk_cpu;

pdu_1cycle pdu(
  .clk(clk),
  .rst(rst),

  //选择CPU工作方式;
  .run(run), 
  .step(step),
  .clk_cpu(clk_cpu),

  //输入switch的端口
  .valid(valid),
  .in(in),

  //输出led和seg的端口 
  .check(check),  //led6-5:查看类型
  .out0(out0),    //led4-0
  .an(an),     //8个数码管
  .seg(seg),
  .ready(ready),          //led7

  //IO_BUS 
  .io_addr(io_addr),  //IO外设地址
  .io_dout(io_dout), //CPU输出的数据
  .io_we(io_we),          //CPU向led和seg输出时的使能信号
  .io_din(io_din), //CPU接收的sw输入数据

  //Debug_BUS 
  .m_rf_addr(m_rf_addr), //向CPU输出DM/RF地址
  .rf_data(rf_data),   //返回的RF的数据
  .m_data(m_data),    //返回DM的数据
  .pc(pc)         //返回指令地址
);

cpu cpu1(
  .clk(clk_cpu), 
  .rst(rst),            //PC复位 

  //IO_BUS
  .io_addr(io_addr),      //led和seg的地址
  .io_dout(io_dout),     //输出led和seg的数据
  .io_we(io_we),                 //输出led和seg数据时的使能信号
  .io_din(io_din),          //来自sw的输入数据

  //Debug_BUS
  .m_rf_addr(m_rf_addr),   //存储器(MEM)或寄存器堆(RF)的调试读口地址
  .rf_data(rf_data),    //从RF读取的数据
  .m_data(m_data),    //从MEM读取的数据
  .pc(pc)             //PC的内容
);
endmodule