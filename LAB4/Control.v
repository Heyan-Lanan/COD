//Control模块,根据op[6:0]与组合逻辑，输出电路控制指令
module Control(
    input [6:0] in,
    output reg Branch,
    output reg MemRead,
    output reg MemtoReg,
    output reg [1:0] ALUop,
    output reg MemWrite,
    output reg ALUSrc,
    output reg RegWrite,
    output reg Jump
);

parameter J_op = 7'b1101111;   //jal
parameter B_op = 7'b1100011;   //beq
parameter L_op = 7'b0000011;   //lw
parameter S_op = 7'b0100011;   //sw
parameter I_op = 7'b0010011;   //addi
parameter R_op = 7'b0110011;   //add

//实现6中指令的fun，jal无
parameter FUN_beq = 3'b000;
parameter FUN_lw  = 3'b010;
parameter FUN_sw  = 3'b010;
parameter FUN_addi= 3'b000;
parameter FUN_add = 3'b000;

//由于该单周期CPU要求实现的6类指令各只有一种，故此处暂不考虑FUN
always@(*)
begin
    case(in)
    J_op:begin//jal 
        Branch  <= 1;
        Jump    <= 1;
        MemRead <= 0;
        MemtoReg<= 0;
        ALUop   <= 2'b11;
        MemWrite<= 0;
        ALUSrc  <= 1;
        RegWrite<= 1;
    end
    B_op:begin//beq 
        Branch  <= 1;
        Jump    <= 0;
        MemRead <= 0;
        MemtoReg<= 0;//x
        ALUop   <= 2'b01;
        MemWrite<= 0;
        ALUSrc  <= 0;
        RegWrite<= 0;
    end
    L_op:begin//lw 
        Branch  <= 0;
        Jump    <= 0;
        MemRead <= 1;
        MemtoReg<= 1;
        ALUop   <= 2'b00;
        MemWrite<= 0;
        ALUSrc  <= 1;
        RegWrite<= 1;
    end
    S_op:begin//sw 
        Branch  <= 0;
        Jump    <= 0;
        MemRead <= 0;
        MemtoReg<= 0;//x
        ALUop   <= 2'b00;
        MemWrite<= 1;
        ALUSrc  <= 1;
        RegWrite<= 0;
    end
    I_op:begin//addi
        Branch  <= 0;
        Jump    <= 0;
        MemRead <= 0;
        MemtoReg<= 0;
        ALUop   <= 2'b10;
        MemWrite<= 0;
        ALUSrc  <= 1;
        RegWrite<= 1;
    end
    default:begin// R型add 
        Branch  <= 0;
        Jump    <= 0;
        MemRead <= 0;
        MemtoReg<= 0;
        ALUop   <= 2'b10;
        MemWrite<= 0;
        ALUSrc  <= 0;
        RegWrite<= 1;
    end
    endcase
end

endmodule