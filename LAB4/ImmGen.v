//立即数扩展模块
 module ImmGen(
    input [31:0] intro,
    output reg [31:0] gimm
);

//实现6种指令的opcode
parameter J_op = 7'b1101111;   //jal
parameter B_op = 7'b1100011;   //beq
parameter L_op = 7'b0000011;   //lw
parameter S_op = 7'b0100011;   //sw
parameter I_op = 7'b0010011;   //addi
parameter R_op = 7'b0110011;   //add

always@(*)
begin
    case(intro[6:0])
    J_op: gimm <= {{13{intro[31]}}, intro[19:12], intro[20], intro[30:21]};
    B_op: gimm <= {{21{intro[31]}}, intro[7], intro[30:25], intro[11:8]};
    L_op: gimm <= {{20{intro[31]}}, intro[31:20]};
    S_op: gimm <= {{20{intro[31]}}, intro[31:25], intro[11:7]};
    I_op: gimm <= {{20{intro[31]}}, intro[31:20]};
    default: gimm <= 32'h00000000; 
    endcase
end
endmodule