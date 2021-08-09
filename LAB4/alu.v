//32λALU   
module alu(
    input [31:0] a,b,
    input [3:0] f,
    output reg [31:0] y,
    output z
); 
assign z = (y==0);
always@(*)
    case(f)
        4'b0000: y <= a & b;
        4'b0001: y <= a | b;
        4'b0010: y <= a + b;
        4'b0110: y <= a - b;
        4'b0111: y <= (a<b)?1:0;
        4'b1100: y <= ~(a|b);
        default: y  <= 0;
    endcase
endmodule