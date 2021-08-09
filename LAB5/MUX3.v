module MUX3(
    input [1:0] s,
    input [31:0] src0,src1,src2,
    output reg [31:0] out
);
always@(*)
begin
    case(s)
    2'b00: out=src0;
    2'b01: out=src1;
    default: out = src2;
    endcase
end
endmodule