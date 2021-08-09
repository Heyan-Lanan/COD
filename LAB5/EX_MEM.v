module EX_MEM(
    input clk, rst, en, clear,
    input [1:0] EX_MemtoReg,
    input EX_MemWrite, EX_RegWrite,
    input [31:0] EX_PCA_out, ALU_out, EX_M21_out, 
    input [4:0] EX_RF_rd,
    output reg [1:0] MEM_MemtoReg,
    output reg MEM_MemWrite, MEM_RegWrite,
    output reg [31:0] MEM_PCA_out, MEM_ALU_out, MEM_M21_out,
    output reg [4:0] MEM_RF_rd
);
always@(posedge clk or posedge rst)
begin
    if(rst|clear)
        begin
            MEM_MemWrite <= 0;
            MEM_RegWrite <= 0;
            MEM_RF_rd <= 5'b00000;
        end
    else if(en)
        begin
            MEM_MemWrite <= EX_MemWrite;
            MEM_RegWrite <= EX_RegWrite;
            MEM_RF_rd <= EX_RF_rd;
        end
    else
        begin
            MEM_MemWrite <= MEM_MemWrite;
            MEM_RegWrite <= MEM_RegWrite;
            MEM_RF_rd <= MEM_RF_rd;
        end
end

always@(posedge clk)
begin
    MEM_PCA_out <= EX_PCA_out;
    MEM_ALU_out <= ALU_out;
    MEM_M21_out <= EX_M21_out;
    MEM_MemtoReg <= EX_MemtoReg;
end
endmodule