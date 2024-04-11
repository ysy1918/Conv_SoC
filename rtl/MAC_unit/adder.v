
module adder(A, B, Cin, Sum, Cout, overflow,split);
input [47:0] A, B;
input Cin,split;
output [47:0] Sum;
output Cout,overflow;
wire c1,c2,c3,c4,c5,c6,c7;
adder16bit R1(A[15:0], B[15:0], Cin, Sum[15:0], c1);
adder8bit  R3(A[23:16], B[23:16], c1, Sum[23:16], c2);
adder16bit R2(A[39:24], B[39:24], split ? c2 : Cin, Sum[39:24], c3);
adder4bit  R4(A[43:40], B[43:40], c3, Sum[43:40], c4);
FA_1 A5(A[44], B[44], c4, Sum[44], c5);
FA_1 A6(A[45], B[45], c5, Sum[45], c6);
FA_1 A7(A[46], B[46], c6, Sum[46], c7);
FA_1 A8(A[47], B[47], c7, Sum[47], Cout);

xor(overflow,c6,Cout);

endmodule

module adder4bit(A, B, Cin, Sum, Cout);
input [3:0] A, B;
input Cin;
output [3:0] Sum;
output Cout;
wire c1, c2, c3;
FA_1 A1(A[0], B[0], Cin, Sum[0], c1);
FA_1 A2(A[1], B[1], c1, Sum[1], c2);
FA_1 A3(A[2], B[2], c2, Sum[2], c3);
FA_1 A4(A[3], B[3], c3, Sum[3], Cout);
endmodule

module adder8bit(A, B, Cin, Sum, Cout);
input [7:0] A, B;
input Cin;
output [7:0] Sum;
output Cout;
wire c1;
adder4bit A9(A[3:0], B[3:0], Cin, Sum[3:0], c1);
adder4bit A10(A[7:4], B[7:4], c1, Sum[7:4], Cout);
endmodule

module adder16bit(A, B, Cin, Sum, Cout);
input [15:0] A, B;
input Cin;
output [15:0] Sum;
output Cout;
wire c1, c2, c3;
adder4bit A5(A[3:0], B[3:0], Cin, Sum[3:0], c1);
adder4bit A6(A[7:4], B[7:4], c1, Sum[7:4], c2);
adder4bit A7(A[11:8], B[11:8], c2, Sum[11:8], c3);
adder4bit A8(A[15:12], B[15:12], c3, Sum[15:12], Cout);
endmodule

module shiftright (
    input [15:0] pin,
    output [15:0] pout
);
    assign pout[15] = pin[15];
    assign pout[14] = pin[15];
    assign pout[13] = pin[14];
    assign pout[12] = pin[13];
    assign pout[11] = pin[12];
    assign pout[10] = pin[11];
    assign pout[9] = pin[10];
    assign pout[8] = pin[9];
    assign pout[7] = pin[8];
    assign pout[6] = pin[7];
    assign pout[5] = pin[6];
    assign pout[4] = pin[5];
    assign pout[3] = pin[4];
    assign pout[2] = pin[3];
    assign pout[1] = pin[2];
    assign pout[0] = pin[1];

endmodule

