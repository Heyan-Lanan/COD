//由于数据通路改变，许多信号需要重新写！！！！！！！！！
//Control模块,根据op[6:0]与组合逻辑，输出电路控制指令
module Control(
    input [6:0] in,
    output reg Branch,
    output reg [1:0] MemtoReg,
    output reg MemRead,
    output reg MemWrite,
    output reg ALUSrc,
    output reg RegWrite,
    output reg Jump
);

//简化实现，无需fun
parameter J_op = 7'b1101111;   //jal
parameter B_op = 7'b1100011;   //beq
parameter L_op = 7'b0000011;   //lw
parameter S_op = 7'b0100011;   //sw
parameter I_op = 7'b0010011;   //addi
parameter R_op = 7'b0110011;   //add
parameter N_op = 7'b0000000;   //nop

always@(*)
begin
    case(in)
    J_op:begin//jal 
        Branch  <= 0;
        Jump    <= 1;
        MemtoReg<= 2'b00;
        MemRead <= 0;
        MemWrite<= 0;
        ALUSrc  <= 1;
        RegWrite<= 1;
    end
    B_op:begin//beq
        Branch  <= 1;
        Jump    <= 0;
        MemtoReg<= 2'b11;//xx
        MemRead <= 0;
        MemWrite<= 0;
        ALUSrc  <= 1;
        RegWrite<= 0;
    end
    L_op:begin//lw
        Branch  <= 0;
        Jump    <= 0;
        MemtoReg<= 2'b10;
        MemRead <= 1;
        MemWrite<= 0;
        ALUSrc  <= 1;
        RegWrite<= 1;
    end
    S_op:begin//sw
        Branch  <= 0;
        Jump    <= 0;
        MemtoReg<= 2'b11;//xx
        MemRead <= 0;
        MemWrite<= 1;
        ALUSrc  <= 1;
        RegWrite<= 0;
    end
    I_op:begin//addi
        Branch  <= 0;
        Jump    <= 0;
        MemtoReg<= 2'b01;
        MemRead <= 0;
        MemWrite<= 0;
        ALUSrc  <= 1;
        RegWrite<= 1;
    end
    R_op: begin//add
        Branch  <= 0;
        Jump    <= 0;
        MemtoReg<= 2'b01;
        MemRead <= 0;
        MemWrite<= 0;
        ALUSrc  <= 0;
        RegWrite<= 1;
    end
    default:begin//nop
        Branch  <= 0;
        Jump    <= 0;
        MemtoReg<= 2'b01;
        MemRead <= 0;
        MemWrite<= 0;
        ALUSrc  <= 0;
        RegWrite<= 0;
    end
    endcase
end

endmodule