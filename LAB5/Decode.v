//¥¶¿Ì÷∏¡Ó
module Decode(
    input [31:0] instruction,
    output [4:0] RF_rs1,RF_rs2,RF_rd,
    output [6:0] opcode
);
assign RF_rs1 = instruction[19:15];
assign RF_rs2 = instruction[24:20];
assign RF_rd  = instruction[11:7];
assign opcode = instruction[6:0];
endmodule