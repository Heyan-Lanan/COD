`timescale 1ns / 1ps

module  CPU(
    input clk, 
    input rst,

    //以下为PDU调试端口------------------------
    //IO_BUS
    output [7:0] io_addr,
    output [31:0] io_dout,
    output io_we,
    input [31:0] io_din,

    //Debug_BUS
    input [7:0] m_rf_addr,
    output [31:0] rf_data,
    output [31:0] m_data,

    //增加流水线寄存器调试接口
    output [31:0] pcin, pc, pcd, pce,
    output [31:0] ir, imm, mdr,
    output [31:0] a, b, y, bm, yw,
    output [4:0]  rd, rdm, rdw,
    output [31:0] ctrl, 
    output reg [31:0] ctrlm, ctrlw  
);



//线路
//IF-----------------------------------
wire PCSrc;
wire [31:0] PCA_out, PC_in, PC_out, IM_out;
//ID-----------------------------------
wire [31:0] ID_PCA_out, ID_PC_out, ID_IM_out, IG_out;
wire [4:0] RF_rs1, RF_rs2, RF_rd;
wire [6:0] opcode;
wire ID_Branch, ID_MemWrite, ID_MemRead, ID_ALUSrc, ID_RegWrite, ID_Jump;
wire [1:0] ID_MemtoReg;
wire [31:0] RF_out1, RF_out2;
//EX------------------------------------
wire EX_Branch, EX_MemWrite, EX_ALUSrc, EX_Jump, EX_RegWrite;
wire [1:0] EX_MemtoReg;
wire [31:0] EX_PCA_out, EX_PC_out, EX_RF_out1,EX_RF_out2, EX_IG_out;
wire [4:0] EX_RF_rs1, EX_RF_rs2, EX_RF_rd;
wire [6:0] EX_opcode;
wire [31:0] EX_M11_out, EX_M12_out, EX_M21_out, EX_M22_out;
wire EX_s12, BR_out, AND_out;
wire [31:0]  ALU_out;
//MEM-----------------------------------
wire [1:0]MEM_MemtoReg;
wire MEM_MemWrite, MEM_RegWrite;
wire [4:0] MEM_RF_rd;
wire [31:0] MEM_PCA_out, MEM_ALU_out, MEM_M21_out, DM_out;
//WB------------------------------------
wire [31:0] WB_io_din;
wire [1:0] WB_MemtoReg;
wire [31:0] WB_PCA_out, WB_ALU_out, WB_DM_out;
wire [4:0] WB_RF_rd;
wire WB_RegWrite;
wire [31:0] WB_MUX_out;
//FU&HU----------------------------------
wire [1:0] FU_s1,FU_s2;
wire HU_en;
//段间寄存器enable clear------------------
wire IF_ID_en, IF_ID_clear;
wire ID_EX_en, ID_EX_clear;
wire EX_MEM_en, EX_MEM_clear;
wire MEM_WB_en, MEM_WB_clear;

reg [31:0] WB_MemWrite;
reg [31:0] WB_M21_out;
always@(posedge clk) WB_MemWrite <= MEM_MemWrite;
always@(posedge clk) WB_M21_out <= MEM_M21_out;

//IO_BUS 
assign io_we = WB_ALU_out[10] & WB_MemWrite;
assign io_addr = WB_ALU_out[7:0];
assign io_dout = WB_M21_out;



wire [31:0] MUX_IO_out;
//Debug BUS 已连接至RF，DM
//增加流水线寄存器调试接口
//PC/IF/ID
assign pcin = PC_in;
assign pc = PC_out;
assign ir = IM_out;
assign pcd = ID_PC_out;
//ID/EX
assign pce = EX_PC_out;
assign a = EX_RF_out1;
assign b = EX_RF_out2;
assign imm = EX_IG_out;
assign rd = EX_RF_rd;
//EX/MEM
assign y = MEM_ALU_out;
assign bm = MEM_M21_out;
assign rdm = MEM_RF_rd;
//MMEM/WB
assign yw = WB_ALU_out;
assign mdr = MUX_IO_out;
assign rdw = WB_RF_rd;
//ctrl
assign ctrl = {HU_en, IF_ID_en, IF_ID_clear, ID_EX_clear, 
                2'b00, FU_s1, 2'b00, FU_s2, 2'b0, EX_RegWrite, EX_MemtoReg,
                2'b00, EX_MemRead, EX_MemWrite, 2'b00, EX_Jump, EX_Branch,
                2'b00, EX_s12, EX_ALUSrc, 4'b1111};
always@(posedge clk)
begin
    ctrlm <= ctrl;
    ctrlw <= ctrlm;
end


//////////////////////////////////////IF段
MUX2 MUX2_PC(
    .s(PCSrc),
    .src0(PCA_out),
    .src1(ALU_out),
    .out(PC_in)
);

PC PC(
    .clk(clk),
    .rst(rst),
    .enable(HU_en),
    .in(PC_in),
    .out(PC_out)
);

IM ft_IM(//+
  .a(PC_out[9:2]),
  .d(32'b0),
  .clk(clk),
  .we(0),
  .spo(IM_out)
);

ALU PCA(
    .a(PC_out),
    .b(32'h0000_0004),
    .y(PCA_out)
);

IF_ID IF_ID(//段间寄存器
    .clk(clk),.rst(rst),
    .en(IF_ID_en),
    .clear(IF_ID_clear),
    //输入                  //输出
    .PCA_out(PCA_out),      .ID_PCA_out(ID_PCA_out),
    .PC_out(PC_out),        .ID_PC_out(ID_PC_out),
    .IM_out(IM_out),        .ID_IM_out(ID_IM_out)
);


////////////////////////////////ID段
Decode Decode(
    .instruction(ID_IM_out),
    .RF_rs1(RF_rs1),
    .RF_rs2(RF_rs2),
    .RF_rd(RF_rd),
    .opcode(opcode)
);

ImmGen ImmGen(
    .intro(ID_IM_out),
    .gimm(IG_out)
);

Control Control(
    .in(opcode),
    .Branch(ID_Branch),
    .MemtoReg(ID_MemtoReg),
    .MemWrite(ID_MemWrite),
    .MemRead(ID_MemRead),
    .ALUSrc(ID_ALUSrc),
    .RegWrite(ID_RegWrite),
    .Jump(ID_Jump)
);

RF RF(
  .clk(clk),
  .we(WB_RegWrite),
  .wa(WB_RF_rd),
  .wd(WB_MUX_out),
  .ra0(RF_rs1),
  .ra1(RF_rs2),
  .rd0(RF_out1),
  .rd1(RF_out2),
  .ra2(m_rf_addr[4:0]),
  .rd2(rf_data)
);

ID_EX ID_EX(
    .clk(clk), .rst(rst),
    .en(ID_EX_en),
    .clear(ID_EX_clear),
    //输入                          //输出
    .ID_Branch(ID_Branch),          .EX_Branch(EX_Branch),
    .ID_MemtoReg(ID_MemtoReg),      .EX_MemtoReg(EX_MemtoReg),
    .ID_MemWrite(ID_MemWrite),      .EX_MemWrite(EX_MemWrite),
    .ID_MemRead(ID_MemRead),        .EX_MemRead(EX_MemRead),
    .ID_ALUSrc(ID_ALUSrc),          .EX_ALUSrc(EX_ALUSrc),
    .ID_RegWrite(ID_RegWrite),      .EX_RegWrite(EX_RegWrite),
    .ID_Jump(ID_Jump),              .EX_Jump(EX_Jump), 
    .ID_PCA_out(ID_PCA_out),        .EX_PCA_out(EX_PCA_out),
    .ID_PC_out(ID_PC_out),          .EX_PC_out(EX_PC_out),
    .RF_out1(RF_out1),              .EX_RF_out1(EX_RF_out1),
    .RF_out2(RF_out2),              .EX_RF_out2(EX_RF_out2), 
    .IG_out(IG_out),                .EX_IG_out(EX_IG_out),
    .RF_rs1(RF_rs1),                .EX_RF_rs1(EX_RF_rs1),
    .RF_rs2(RF_rs2),                .EX_RF_rs2(EX_RF_rs2),
    .RF_rd(RF_rd),                  .EX_RF_rd(EX_RF_rd),
    .opcode(opcode),                .EX_opcode(EX_opcode)
);

///////////////////////////////////////////EX段
MUX3 MUX3_11(
    .s(FU_s1),
    .src0(WB_MUX_out),
    .src1(EX_RF_out1),
    .src2(MEM_ALU_out),
    .out(EX_M11_out)
);

MUX3 MUX3_21(
    .s(FU_s2),
    .src0(WB_MUX_out),
    .src1(EX_RF_out2),
    .src2(MEM_ALU_out),
    .out(EX_M21_out)
);

assign EX_s12 = ~(EX_Jump | EX_Branch);//此处是个新信号
MUX2 MUX2_12(
    .s(EX_s12),
    .src0(EX_PC_out),
    .src1(EX_M11_out),
    .out(EX_M12_out)
);

MUX2 MUX2_22(
    .s(EX_ALUSrc),
    .src0(EX_M21_out),
    .src1(EX_IG_out),
    .out(EX_M22_out)
);

Branch Branch(
    .a(EX_M11_out),
    .b(EX_M21_out),
    .BR_out(BR_out)
);

AND AND(
    .in1(EX_Branch),
    .in2(BR_out),
    .out(AND_out)
);

OR OR(
    .in1(EX_Jump),
    .in2(AND_out),
    .out(PCSrc)
);

ALU ALU(
    .a(EX_M12_out),
    .b(EX_M22_out),
    .y(ALU_out)
);

EX_MEM EX_MEM(
    .clk(clk), .rst(rst),
    .en(EX_MEM_en),
    .clear(EX_MEM_clear),
    //输入                              //输出 
    .EX_MemtoReg(EX_MemtoReg),          .MEM_MemtoReg(MEM_MemtoReg),
    .EX_MemWrite(EX_MemWrite),          .MEM_MemWrite(MEM_MemWrite),
    .EX_RegWrite(EX_RegWrite),          .MEM_RegWrite(MEM_RegWrite),
    .EX_PCA_out(EX_PCA_out),            .MEM_PCA_out(MEM_PCA_out),
    .ALU_out(ALU_out),                  .MEM_ALU_out(MEM_ALU_out),
    .EX_M21_out(EX_M21_out),            .MEM_M21_out(MEM_M21_out),
    .EX_RF_rd(EX_RF_rd),                .MEM_RF_rd(MEM_RF_rd)
);

DM ft_DM(
  .a(MEM_ALU_out[9:2]),
  .d(MEM_M21_out),
  .dpra(m_rf_addr),
  .clk(clk),
  .we(MEM_MemWrite),
  .spo(DM_out),
  .dpo(m_data)
);


MEM_WB MEM_WB(
    .clk(clk),
     .rst(rst),
    .en(MEM_WB_en),
    .clear(MEM_WB_clear),
    //输入                              //输出
    .MEM_MemtoReg(MEM_MemtoReg),        .WB_MemtoReg(WB_MemtoReg),
    .MEM_RegWrite(MEM_RegWrite),        .WB_RegWrite(WB_RegWrite),
    .MEM_PCA_out(MEM_PCA_out),          .WB_PCA_out(WB_PCA_out),
    .MEM_ALU_out(MEM_ALU_out),          .WB_ALU_out(WB_ALU_out),
    .DM_out(DM_out),                    .WB_DM_out(WB_DM_out),
    .MEM_RF_rd(MEM_RF_rd),              .WB_RF_rd(WB_RF_rd)
);

////////////////////////////////////////////WB段
MUX2 MUX_IO(
    .s(WB_ALU_out[10]),
    .src0(WB_DM_out),
    .src1(io_din),
    .out(MUX_IO_out)
);
MUX3 MUX3(
    .s(WB_MemtoReg),
    .src0(WB_PCA_out),
    .src1(WB_ALU_out),
    .src2(MUX_IO_out),
    .out(WB_MUX_out)
);

//Forwarding Unit与Hazard Unit
FU FU(
    .FU_s1(FU_s1),
    .FU_s2(FU_s2),
    .EX_RF_rs1(EX_RF_rs1),
    .EX_RF_rs2(EX_RF_rs2),
    .WB_RegWrite(WB_RegWrite),
    .WB_RF_rd(WB_RF_rd),
    .MEM_RegWrite(MEM_RegWrite),
    .MEM_RF_rd(MEM_RF_rd)
);

HU HU(
    .EX_MemtoReg(EX_MemtoReg),
    .EX_MemRead(EX_MemRead),
    .MEM_RegWrite(MEM_RegWrite),
    .WB_RegWrite(WB_RegWrite),
    .EX_RF_rd(EX_RF_rd),
    .EX_opcode(EX_opcode),
    .RF_rs1(RF_rs1),
    .RF_rs2(RF_rs2),
    .HU_en(HU_en),//to PC
    .PCSrc(PCSrc),
    .IF_ID_en(IF_ID_en), 
    .IF_ID_clear(IF_ID_clear),
    .ID_EX_en(ID_EX_en),
    .ID_EX_clear(ID_EX_clear),
    .EX_MEM_en(EX_MEM_en),
    .EX_MEM_clear(EX_MEM_clear),
    .MEM_WB_en(MEM_WB_en),
    .MEM_WB_clear(MEM_WB_clear)
);

endmodule