//Forwarding Unit 前递单元
//组合逻辑
module FU(
    input [4:0] EX_RF_rs1,
    input [4:0] EX_RF_rs2,
    input WB_RegWrite,
    input [4:0] WB_RF_rd,
    input MEM_RegWrite,
    input [4:0] MEM_RF_rd,
    output reg [1:0] FU_s1,
    output reg [1:0] FU_s2
);
//可考虑对称性
always@(*)
begin
    if((MEM_RF_rd==EX_RF_rs1) && MEM_RegWrite && (MEM_RF_rd!=5'b00000))        FU_s1 = 2'b10;  //MEM->EX
    else if(WB_RF_rd==EX_RF_rs1 && WB_RegWrite && (WB_RF_rd!=5'b00000))    FU_s1 = 2'b00;  //WB->EX
    else FU_s1 = 2'b01;     //不前递
end

always@(*)
begin
    if((MEM_RF_rd==EX_RF_rs2) && MEM_RegWrite && (MEM_RF_rd!=5'b00000))         FU_s2 = 2'b10;  //MEM->EX
    else if(WB_RF_rd==EX_RF_rs2 && WB_RegWrite && (WB_RF_rd!=5'b00000))    FU_s2 = 2'b00;  //WB->EX
    else FU_s2 = 2'b01;     //不前递
end
endmodule
