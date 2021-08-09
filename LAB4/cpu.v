module  cpu(
  input clk, 
  input rst,

  //IO_BUS
  output [7:0] io_addr,      //led��seg�ĵ�ַ
  output [31:0] io_dout,     //���led��seg������
  output io_we,                 //���led��seg����ʱ��ʹ���ź�
  input [31:0] io_din,          //����sw����������

  //Debug_BUS
  input [7:0] m_rf_addr,   //�洢��(MEM)��Ĵ�����(RF)�ĵ��Զ��ڵ�ַ
  output [31:0] rf_data,    //��RF��ȡ������
  output [31:0] m_data,    //��MEM��ȡ������
  output [31:0] pc             //PC������
);

//����ͨ·����ʹ�õ�����
wire [31:0] pc_in, pc_out, pcA_out, pcS_out;//pc���룬�������Add��Sum�����
wire [31:0] IM_out; //Instruction Memory�����
wire [31:0] RF_rd0, RF_rd1;//RF����ǰ2��������ָ���3��debug
wire [31:0] MEMReal,MEMRead;
wire [31:0] wd;//RF��д
wire [31:0] IG_out, SL_out;  //ImmGen��Shift left 1�������
wire [31:0] ALU_in2;  //ALU��2������ˣ���1����rf_rd1;
wire ALU_z;   //ALU��0��
wire [31:0] ALUresult; //ALU�������DM�ĵ�1����ַ�ڣ���2��Ϊm_rf_addr 
wire [31:0] MEMrd;
//Control�Ŀ����ź���
wire Jump,Branch,MemRead,MemtoReg,MemWrite,ALUSrc,RegWrite;
wire [1:0] ALUop;
wire [3:0] AC_out;

assign io_we = ALUresult[10];
assign io_addr = ALUresult[7:0];
assign io_dout = RF_rd1;

//Control�����ź�
Control ctrl(
  .in(IM_out[6:0]),
  .Jump(Jump),
  .Branch(Branch),
  .MemRead(MemRead),
  .MemtoReg(MemtoReg),
  .ALUop(ALUop),
  .MemWrite(MemWrite),
  .ALUSrc(ALUSrc),
  .RegWrite(RegWrite)
);
ALUcontrol ac(
  .ALUop(ALUop),
  .AC_out(AC_out)
);
//pc�Ĵ���
wire PCBr,PCSrc;  //��һ��PCֵ��ѡ���ź�
AND AND(
  .in1(Branch),
  .in2(ALU_z),
  .out(PCBr)
);
    
OR OR(
  .in1(PCBr),
  .in2(Jump),
  .out(PCSrc)
  );
assign pc = pc_out;
assign pcA_out = pc_out + 32'h0000_0004;
assign pcS_out = pc_out + SL_out;
MUX pc_mux(
  .s(PCSrc),
  .src0(pcA_out),
  .src1(pcS_out),
  .out(pc_in)
);

ImmGen ig(
  .intro(IM_out),
  .gimm(IG_out)
);

shift1 sl1(
  .in(IG_out),
  .out(SL_out)
);

//��������ͨ·�Ľ���
PC pc1( 
  .clk(clk),
  .rst(rst),
  .in(pc_in),
  .out(pc_out)
);

IM IM(
  .a(pc_out[9:2]),
  .d(32'b0),
  .clk(clk),
  .we(0),
  .spo(IM_out)
);

RF rf(
  .clk(clk),
  .we(RegWrite),
  .wa(IM_out[11:7]),
  .wd(wd),
  .ra0(IM_out[19:15]),
  .ra1(IM_out[24:20]),
  .ra2(m_rf_addr[4:0]),
  .rd0(RF_rd0),
  .rd1(RF_rd1),
  .rd2(rf_data)
);

MUX rf_alu(//RF��ALU֮���ѡ����
    .s(ALUSrc),
    .src0(RF_rd1),
    .src1(IG_out),
    .out(ALU_in2)
);

alu ALU(//RF��DM֮���ALU +
  .a(RF_rd0),
  .b(ALU_in2),
  .f(AC_out),
  .y(ALUresult),
  .z(ALU_z)
);

DM DM(
  .a(ALUresult[9:2]),
  .d(RF_rd1),
  .dpra(m_rf_addr),
  .clk(clk),
  .we(MemWrite),
  .spo(MEMRead),
  .dpo(m_data)
);

MUX MUX_MEM(
  .s(MemtoReg),
  .src0(ALUresult),
  .src1(MEMRead),
  .out(MEMReal)
);

MUX MUX_IO(
  .s(ALUresult[10]),
  .src0(MEMReal),
  .src1(io_din),
  .out(MEMrd)
);

MUX MUX_RF(
  .src0(MEMrd),
  .src1(pcA_out),
  .s(Jump),
  .out(wd)
);



endmodule
