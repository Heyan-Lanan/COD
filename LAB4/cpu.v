module  cpu(
  input clk, 
  input rst,

  //IO_BUS
  output [7:0] io_addr,      //led和seg的地址
  output [31:0] io_dout,     //输出led和seg的数据
  output io_we,                 //输出led和seg数据时的使能信号
  input [31:0] io_din,          //来自sw的输入数据

  //Debug_BUS
  input [7:0] m_rf_addr,   //存储器(MEM)或寄存器堆(RF)的调试读口地址
  output [31:0] rf_data,    //从RF读取的数据
  output [31:0] m_data,    //从MEM读取的数据
  output [31:0] pc             //PC的内容
);

//数据通路中所使用到的线
wire [31:0] pc_in, pc_out, pcA_out, pcS_out;//pc输入，输出端与Add，Sum输出端
wire [31:0] IM_out; //Instruction Memory的输出
wire [31:0] RF_rd0, RF_rd1;//RF的中前2个服务于指令，第3个debug
wire [31:0] MEMReal,MEMRead;
wire [31:0] wd;//RF的写
wire [31:0] IG_out, SL_out;  //ImmGen和Shift left 1的输出端
wire [31:0] ALU_in2;  //ALU第2个输入端，第1个是rf_rd1;
wire ALU_z;   //ALU的0端
wire [31:0] ALUresult; //ALU的输出，DM的第1个地址口，第2个为m_rf_addr 
wire [31:0] MEMrd;
//Control的控制信号们
wire Jump,Branch,MemRead,MemtoReg,MemWrite,ALUSrc,RegWrite;
wire [1:0] ALUop;
wire [3:0] AC_out;

assign io_we = ALUresult[10];
assign io_addr = ALUresult[7:0];
assign io_dout = RF_rd1;

//Control控制信号
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
//pc的处理
wire PCBr,PCSrc;  //下一个PC值的选择信号
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

//其他数据通路的接线
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

MUX rf_alu(//RF和ALU之间的选择器
    .s(ALUSrc),
    .src0(RF_rd1),
    .src1(IG_out),
    .out(ALU_in2)
);

alu ALU(//RF和DM之间的ALU +
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
