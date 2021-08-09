module ALUcontrol(
  input [1:0] ALUop,
  output reg [3:0] AC_out
);
//��Ϊ6��ָ���õ���ALU�������٣���˿���ͨ��ALUopֱ���ж�
always@(*)
begin
  case(ALUop)
    2'b11: AC_out <= 4'b1111; //jalָ��,z��Ϊ1,ֱ����ת
    2'b01: AC_out <= 4'b0110; //beqָ�ALU�ü���
    default: AC_out <= 4'b0010; //add,addi,sw,lw���üӷ�
    endcase
end

endmodule