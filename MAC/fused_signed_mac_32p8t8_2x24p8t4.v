module fused_signed_mac_32p8t8_2x24p8t4 (
    input split,
    input [47:0] in,
    input [7:0] a,
    input [7:0] b,
    output [47:0] out
);



wire [47:0] add_op2;
wire [15:0] S;
wire [11:0] S1,S2;
wire cin, cout1, overflow1;

    assign add_op2 = (split) ? {12'b0,S1,12'b0,S2} : {32'b0, S};
    assign cin = 1'b0;

    /*multiply_8x8_or_two_8x4(a, b, S, S1, S2, split);
    adder(add_op1_32, add_op2_32, 0, out32, cout1, overflow1);
    adder(add_op1_24_1, add_op2_24_1, 0, out_temp1, cout2, overflow2);
    adder(add_op1_24_2, add_op2_24_2, 0, out_temp2, cout3, overflow3);*/

multiply_8x8_or_two_8x4  u_multiply_8x8_or_two_8x4 (
    .A                       ( a        ),
    .B                       ( b        ),
    .split                    ( split     ),

    .S                   ( S    ),
    .S1                  ( S1   ),
    .S2                  ( S2   )
);

adder  u_adder1 (
    .A                       ( in          ),
    .B                       ( add_op2     ),
    .Cin                     ( cin        ),

    .Sum                     ( out        ),
    .Cout                    ( cout1       ),
    .overflow                ( overflow1   ),
    .split                    ( split     )
);
endmodule