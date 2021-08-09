//32Î»Ñ¡ÔñÆ÷
module MUX(
    input s,
    input [31:0] src0,src1,
    output reg [31:0] out
);
always@(*)
begin
    if(s==0) out = src0;
    else out = src1;
end
endmodule