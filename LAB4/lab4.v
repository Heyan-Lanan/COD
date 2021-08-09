module cputest(
    input clk,
    input rst,

    //ѡ��CPU������ʽ;
    input run, 
    input step,

    //����switch�Ķ˿�
    input valid,
    input [4:0] in,

    //���led��seg�Ķ˿� 
    output [1:0] check,   //led6-5:�鿴����
    output [4:0] out0,    //led4-0
    output [2:0] an,      //8�������
    output [3:0] seg,
    output ready          //led7
);

//IO_BUS
wire [7:0] io_addr;  //IO�����ַ
wire [31:0] io_dout; //CPU���������
wire io_we;          //CPU��led��seg���ʱ��ʹ���ź�
wire [31:0] io_din; //CPU���յ�sw��������

//Debug_BUS
wire [7:0] m_rf_addr; //��CPU���DM/RF��ַ
wire [31:0] rf_data;  //���ص�RF������
wire [31:0] m_data;    //����DM������
wire [31:0] pc;         //����ָ���ַ
wire clk_cpu;

pdu_1cycle pdu(
  .clk(clk),
  .rst(rst),

  //ѡ��CPU������ʽ;
  .run(run), 
  .step(step),
  .clk_cpu(clk_cpu),

  //����switch�Ķ˿�
  .valid(valid),
  .in(in),

  //���led��seg�Ķ˿� 
  .check(check),  //led6-5:�鿴����
  .out0(out0),    //led4-0
  .an(an),     //8�������
  .seg(seg),
  .ready(ready),          //led7

  //IO_BUS 
  .io_addr(io_addr),  //IO�����ַ
  .io_dout(io_dout), //CPU���������
  .io_we(io_we),          //CPU��led��seg���ʱ��ʹ���ź�
  .io_din(io_din), //CPU���յ�sw��������

  //Debug_BUS 
  .m_rf_addr(m_rf_addr), //��CPU���DM/RF��ַ
  .rf_data(rf_data),   //���ص�RF������
  .m_data(m_data),    //����DM������
  .pc(pc)         //����ָ���ַ
);

cpu cpu1(
  .clk(clk_cpu), 
  .rst(rst),            //PC��λ 

  //IO_BUS
  .io_addr(io_addr),      //led��seg�ĵ�ַ
  .io_dout(io_dout),     //���led��seg������
  .io_we(io_we),                 //���led��seg����ʱ��ʹ���ź�
  .io_din(io_din),          //����sw����������

  //Debug_BUS
  .m_rf_addr(m_rf_addr),   //�洢��(MEM)��Ĵ�����(RF)�ĵ��Զ��ڵ�ַ
  .rf_data(rf_data),    //��RF��ȡ������
  .m_data(m_data),    //��MEM��ȡ������
  .pc(pc)             //PC������
);
endmodule