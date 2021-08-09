module ALUcontrol(
  input [1:0] ALUop,
  output reg [3:0] AC_out
);
//因为6条指令用到的ALU操作较少，因此可以通过ALUop直接判断
always@(*)
begin
  case(ALUop)
    2'b11: AC_out <= 4'b1111; //jal指令,z恒为1,直接跳转
    2'b01: AC_out <= 4'b0110; //beq指令，ALU用减法
    default: AC_out <= 4'b0010; //add,addi,sw,lw都用加法
    endcase
end

endmodule