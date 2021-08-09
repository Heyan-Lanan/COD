module ID_EX(
    input clk,rst,
    input en, clear,
    input ID_Branch,ID_MemRead, ID_MemWrite, ID_ALUSrc, ID_RegWrite, ID_Jump,
    input [1:0] ID_MemtoReg,
    input [31:0] ID_PCA_out, ID_PC_out, RF_out1, RF_out2, IG_out,
    input [4:0] RF_rs1, RF_rs2, RF_rd,
    input [6:0] opcode,
    output reg EX_Branch,EX_MemRead, EX_MemWrite, EX_ALUSrc, EX_RegWrite, EX_Jump,
    output reg [1:0] EX_MemtoReg,
    output reg [31:0] EX_PCA_out, EX_PC_out, EX_RF_out1, EX_RF_out2, EX_IG_out,
    output reg [4:0] EX_RF_rs1, EX_RF_rs2, EX_RF_rd,
    output reg [6:0] EX_opcode
);
always@(posedge clk or posedge rst)
begin
    if(rst|clear)//此处把较重要的值置0即可，其他值若无影响则不管
        begin
            EX_PC_out  <= 32'hffffffff;
            EX_MemtoReg <= 2'b11;
            EX_MemWrite <= 0;
            EX_RegWrite <= 0;
            EX_MemRead <= 0;
            EX_Jump <= 0;
            EX_Branch <= 0;
            EX_RF_rs1 <= 5'b00000;
            EX_RF_rs2 <= 5'b00000;
            EX_RF_rd  <= 5'b00000;
            EX_opcode <= 7'b0000000;
        end   
    else if(en)
        begin
            EX_PC_out  <= ID_PC_out;
            EX_MemtoReg <= ID_MemtoReg;
            EX_MemWrite <= ID_MemWrite;
            EX_RegWrite <= ID_RegWrite;
            EX_MemRead <= ID_MemRead;
            EX_Jump   <= ID_Jump;            
            EX_Branch <= ID_Branch;             
            EX_RF_rs1 <= RF_rs1;
            EX_RF_rs2 <= RF_rs2;
            EX_RF_rd  <= RF_rd;
            EX_opcode <= opcode;
        end
    else
        begin
            EX_PC_out  <= EX_PC_out;
            EX_MemtoReg <= EX_MemtoReg;
            EX_MemWrite <= EX_MemWrite;
            EX_RegWrite <= EX_RegWrite;
            EX_MemRead <= EX_MemRead;
            EX_Jump   <= EX_Jump;            
            EX_Branch <= EX_Branch;             
            EX_RF_rs1 <= EX_RF_rs1;
            EX_RF_rs2 <= EX_RF_rs2;
            EX_RF_rd  <= EX_RF_rd;
            EX_opcode <= EX_opcode;
        end 
end

always@(posedge clk)
begin
     if(en)
        begin
            EX_ALUSrc <= ID_ALUSrc;
            EX_PCA_out <= ID_PCA_out;
            EX_RF_out1 <= RF_out1;
            EX_RF_out2 <= RF_out2;
            EX_IG_out  <= IG_out;
        end
end
endmodule