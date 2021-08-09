//BranchÄ£¿é
module Branch(
    input [31:0] a,b,
    output BR_out
);
assign BR_out = (a==b);
endmodule