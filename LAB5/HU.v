//Hazard Unit
module HU(
    input EX_MemRead,
    input MEM_RegWrite, WB_RegWrite,
    input [4:0] EX_RF_rd,
    input [6:0] EX_opcode,
    input [4:0] RF_rs1, RF_rs2,
    input PCSrc,
    input [1:0] EX_MemtoReg,
    output reg HU_en,
    output reg IF_ID_en, IF_ID_clear,
    output reg ID_EX_en, ID_EX_clear,
    output  EX_MEM_en, EX_MEM_clear,
    output  MEM_WB_en, MEM_WB_clear
);
parameter J_op = 7'b1101111;   //jal
parameter B_op = 7'b1100011;   //beq
parameter L_op = 7'b0000011;   //lw
parameter S_op = 7'b0100011;   //sw
parameter I_op = 7'b0010011;   //addi
parameter R_op = 7'b0110011;   //add
//实现
//1. lw接add(i),前者rd与后者rs相同时，产生气泡一个周期
//2. beq与jal指令跳转成功时，需要清除分支后的指令
//3. 注意事项：清除与停顿时，注意不要影响正常指令

always@(*)
begin
    case(EX_opcode)
    L_op:
        begin
            if( (RF_rs1==EX_RF_rd)| (RF_rs2==EX_RF_rd) )
                begin
                    HU_en = 0;//PC停顿
                    IF_ID_en = 0;
                    ID_EX_en = 1;
                    IF_ID_clear = 0;
                    ID_EX_clear = 1;
                end
            else
                begin
                    HU_en = 1;
                    IF_ID_en = 1;
                    ID_EX_en = 1;
                    IF_ID_clear = 0;
                    ID_EX_clear = 0;
                end
        end
    B_op:
        begin
            if(PCSrc==1)//跳转
                begin
                    HU_en = 1;
                    IF_ID_en = 1;
                    ID_EX_en = 1;
                    IF_ID_clear = 1;
                    ID_EX_clear = 1;
                end
            else
                begin
                    HU_en = 1;
                    IF_ID_en = 1;
                    ID_EX_en = 1;
                    IF_ID_clear = 0;
                    ID_EX_clear = 0;
                end
        end
    J_op:
        begin
            HU_en = 1;
            IF_ID_en = 1;
            ID_EX_en = 1;
            IF_ID_clear = 1;
            ID_EX_clear = 1;
        end
    default:
        begin
            HU_en = 1;
            IF_ID_en = 1;
            ID_EX_en = 1;
            IF_ID_clear = 0;
            ID_EX_clear = 0;
        end
    endcase
end

//前两条指令，一般不会动
assign EX_MEM_en = 1;
assign EX_MEM_clear = 0;
assign MEM_WB_en = 1;
assign MEM_WB_clear = 0;
endmodule