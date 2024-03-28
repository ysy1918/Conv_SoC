//module multiply_8x8_or_two_8x4(A, B, S, S1, S2, split);
module multiply_8x8(A, B, S);
    input [7:0] A, B;
    output [15:0] S;
    //output [11:0] S1, S2;
    //input split;
    // split = 0, 8x8
    // split = 1, two 8x4
    
    wire [15:0] p0,p1,p2,p3,p4,p5,p6;
    wire [15:0] p0_2,p1_2,p2_2,p3_2,p4_2,p5_2,p6_2;
    wire [15:0] zeros;
    wire [7:0] neg_ab7;
    //wire [7:0] neg_ab3;
    wire sign = A[7];
    //wire sign1= A[3];
    wire [9:0] cout;//no use
    wire cin;
    wire [7:0] one_8bit;

    //wire split = 0;

    assign zeros = 16'b0;
    assign cin = 0;
    assign one_8bit = 8'b00000001;

    adder8bit a9(~(B[7]? A : 8'b0),one_8bit,cin,neg_ab7,cout[8]);
    //adder8bit a10(~(B[3]? A : 8'b0),one_8bit,cin,neg_ab3,cout[9]);

    /*wire [15:0] ab0=(!split) ? {sign&B[0],(B[0]? A : 8'b0),7'b0} : {sign1&B[0],(B[0]? A : 8'b0),7'b0};
    wire [15:0] ab1=(!split) ? {sign&B[1],(B[1]? A : 8'b0),7'b0} : {sign1&B[1],(B[1]? A : 8'b0),7'b0};
    wire [15:0] ab2=(!split) ? {sign&B[2],(B[2]? A : 8'b0),7'b0} : {sign1&B[2],(B[2]? A : 8'b0),7'b0};
    wire [15:0] ab3=(!split) ? {sign&B[3],(B[3]? A : 8'b0),7'b0} : {neg_ab3[7],(B[3]? neg_ab3 : 8'b0),7'b0};*/
    wire [15:0] ab0={sign&B[0],(B[0]? A : 8'b0),7'b0};
    wire [15:0] ab1={sign&B[1],(B[1]? A : 8'b0),7'b0};
    wire [15:0] ab2={sign&B[2],(B[2]? A : 8'b0),7'b0};
    wire [15:0] ab3={sign&B[3],(B[3]? A : 8'b0),7'b0};
    wire [15:0] ab4={sign&B[4],(B[4]? A : 8'b0),7'b0};
    wire [15:0] ab5={sign&B[5],(B[5]? A : 8'b0),7'b0};
    wire [15:0] ab6={sign&B[6],(B[6]? A : 8'b0),7'b0};
    wire [15:0] ab7={neg_ab7[7],(B[7]? neg_ab7 : 8'b0),7'b0};

    adder16bit a1(ab0,16'b0,cin,p0_2,cout[0]);
    adder16bit a2(ab1,p0,cin,p1_2,cout[1]);
    adder16bit a3(ab2,p1,cin,p2_2,cout[2]);
    adder16bit a4(ab3,p2,cin,p3_2,cout[3]);
    //adder16bit a5(ab4,(!split)?p3:zeros,cin,p4_2,cout[4]);// zeros换成16‘b0的话p3失去signed性质
    adder16bit a5(ab4,p3,cin,p4_2,cout[4]);
    adder16bit a6(ab5,p4,cin,p5_2,cout[5]);
    adder16bit a7(ab6,p5,cin,p6_2,cout[6]);
    adder16bit a8(ab7,p6,cin,S,cout[7]);

    //assign S1 = p3[15:4];
    //assign S2 = S[15:4];

    shiftright u_shiftright1(
        .pout(p0),
        .pin(p0_2)
    );

    shiftright u_shiftright2(
        .pout(p1),
        .pin(p1_2)
    );

    shiftright u_shiftright3(
        .pout(p2),
        .pin(p2_2)
    );

    shiftright u_shiftright4(
        .pout(p3),
        .pin(p3_2)
    );

    shiftright u_shiftright5(
        .pout(p4),
        .pin(p4_2)
    );

    shiftright u_shiftright6(
        .pout(p5),
        .pin(p5_2)
    );

    shiftright u_shiftright7(
        .pout(p6),
        .pin(p6_2)
    );

endmodule
