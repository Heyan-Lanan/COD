module MEM_WB(
    input clk,rst,en,clear,
    input [1:0] MEM_MemtoReg,
    input [31:0] MEM_PCA_out, MEM_ALU_out, DM_out,
    input [4:0] MEM_RF_rd,
    input MEM_RegWrite,
    output reg WB_RegWrite,
    output reg [1:0] WB_MemtoReg,
    output reg [31:0] WB_PCA_out, WB_ALU_out, WB_DM_out, 
    output reg [4:0] WB_RF_rd
);
always@(posedge clk or posedge rst)
begin
    if(rst|clear)
        begin
            WB_RegWrite <= 0;
            WB_RF_rd <= 5'b00000;
        end
    else if(en)
        begin
            WB_RegWrite <= MEM_RegWrite;
            WB_RF_rd <= MEM_RF_rd;
        end
    else
        begin
            WB_RegWrite <= WB_RegWrite;
            WB_RF_rd <= WB_RF_rd;
        end
end

always@(posedge clk)
begin
    WB_MemtoReg <= MEM_MemtoReg;
    WB_PCA_out <= MEM_PCA_out;
    WB_ALU_out <= MEM_ALU_out;
    WB_DM_out  <= DM_out;
end
endmodule