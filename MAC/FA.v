`timescale 1ns / 1ps
module FA(input A, input B, input Cin, output Sum, output Cout 
    );
wire p,r,s;
xor (p,A,B);
xor (Sum,p,Cin);
and(r,p,Cin);
and(s,A,B);
or(Cout,r,s);

endmodule
