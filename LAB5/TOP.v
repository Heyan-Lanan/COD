module TOP(
    input clk,rst,run,valid,step,
    input [4:0] in,
    output [1:0] check,
    output [4:0] out0,
    output [2:0] an,
    output [3:0] seg,
    output ready
);
  wire clk_cpu;
  wire [7:0] io_addr;
  wire [31:0] io_dout;
  wire io_we;
  wire [31:0] io_din;
  //Debug_BUS
  wire[7:0] m_rf_addr;
  wire [31:0] rf_data;
  wire [31:0] m_data;

  //增加流水线寄存器调试接口
  wire [31:0] pcin, pc, pcd, pce;
  wire [31:0] ir, imm, mdr;
  wire [31:0] a, b, y, bm, yw;
  wire [4:0]  rd, rdm, rdw;
  wire [31:0] ctrl, ctrlm, ctrlw;  

CPU FT_CPU(
    .clk(clk_cpu), 
    .rst(rst),
    .io_addr(io_addr),
    .io_dout(io_dout),
    .io_we(io_we),
    .io_din(io_din),
    .m_rf_addr(m_rf_addr),
    .rf_data(rf_data),
    .m_data(m_data),
    .pcin(pcin), 
    .pc(pc), 
    .pcd(pcd), 
    .pce(pce),
    .ir(ir), 
    .imm(imm), 
    .mdr(mdr),
    .a(a), 
    .b(b), 
    .y(y), 
    .bm(bm), 
    .yw(yw),
    .rd(rd), 
    .rdm(rdm), 
    .rdw(rdw),
    .ctrl(ctrl), 
    .ctrlm(ctrlm), 
    .ctrlw(ctrlw)  
);

PDU Teacher_PDU(
  .clk(clk),
  .rst(rst),
  .run(run), 
  .step(step),
  .clk_cpu(clk_cpu),
  .valid(valid),
  .in(in),
  .check(check),
  .out0(out0), 
  .an(an), 
  .seg(seg),
  .ready(ready),
  .io_addr(io_addr),
  .io_dout(io_dout),
  .io_we(io_we),
  .io_din(io_din),
  .m_rf_addr(m_rf_addr),
  .rf_data(rf_data),
  .m_data(m_data),
  .pcin(pcin), 
  .pc(pc), 
  .pcd(pcd), 
  .pce(pce),
  .ir(ir), 
  .imm(imm), 
  .mdr(mdr),
  .a(a), 
  .b(b), 
  .y(y), 
  .bm(bm), 
  .yw(yw),
  .rd(rd), 
  .rdm(rdm), 
  .rdw(rdw),
  .ctrl(ctrl), 
  .ctrlm(ctrlm), 
  .ctrlw(ctrlw)   
);
endmodule