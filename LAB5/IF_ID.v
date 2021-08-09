module IF_ID(//段间寄存器
    input clk,rst,
    input en, clear,
    input [31:0] PCA_out, PC_out, IM_out,
    output reg [31:0] ID_PCA_out, ID_PC_out, ID_IM_out
);
always@(posedge clk or posedge rst)
begin
    if(rst|clear)
        begin
            ID_PCA_out <= 32'h00003004;
            ID_PC_out <= 32'h00003000;
            ID_IM_out <= 32'h00000000;
        end
    else if(en)
        begin
            ID_PCA_out <= PCA_out;
            ID_PC_out <= PC_out;
            ID_IM_out <= IM_out;
        end
    else//en不生效，自锁
        begin
            ID_PCA_out <= ID_PCA_out;
            ID_PC_out <= ID_PC_out;
            ID_IM_out <= ID_IM_out;
        end
end
endmodule