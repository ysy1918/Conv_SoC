module conv_core_2x2 (
    input [8*2*2-1:0] image,//8bit*k*(k+3)*C
    input [8*2*2-1:0] filter,
    output [15:0] conv_out,

    input clk,
    input rst_n
);

    reg [4*16-1:0] reg_mult_out;  
    wire  [4*16-1:0]  mult_out;
    wire [31:0] partial_sum;
    wire [3:0] dummy_Cout;

    assign dummy_Cout = 4'b0;

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) reg_mult_out = 64'b0;
            else begin
                reg_mult_out = mult_out;
            end
    end

multiply_8x8  u_multiply_8x8_0 ( //element(0,0)
    .x                       ( filter[8*2*2-1:8*3]   ),
    .y                       ( image[8*2*2-1:8*3]   ),

    .p                       ( mult_out[4*16-1:3*16]   )
);

multiply_8x8  u_multiply_8x8_1 ( //element(0,1)
    .x                       ( filter[8*3-1:8*2]   ),
    .y                       ( image[8*3-1:8*2]   ),

    .p                       ( mult_out[3*16-1:2*16]   )
);

multiply_8x8  u_multiply_8x8_2 ( //element(1,0)
    .x                       ( filter[8*2-1:8]   ),
    .y                       ( image[8*2-1:8]   ),

    .p                       ( mult_out[2*16-1:1*16]   )
);

multiply_8x8  u_multiply_8x8_3 ( //element(1,1)
    .x                       ( filter[7:0]   ),
    .y                       ( image[7:0]   ),

    .p                       ( mult_out[1*16-1:0]   )
);

adder16bit  u_adder16bit1 (
    .A                       ( reg_mult_out[4*16-1:3*16]          ),
    .B                       ( reg_mult_out[3*16-1:2*16]     ),
    .Cin                     ( dummy_Cout[0]        ),

    .Sum                     ( partial_sum[31:16]        ),
    .Cout                    ( dummy_Cout[3]       )
);

adder16bit  u_adder16bit2 (
    .A                       ( reg_mult_out[2*16-1:16]          ),
    .B                       ( reg_mult_out[15:0]     ),
    .Cin                     ( dummy_Cout[0]        ),

    .Sum                     ( partial_sum[15:0]        ),
    .Cout                    ( dummy_Cout[2]       )
);

adder16bit  u_adder16bit3 (
    .A                       ( partial_sum[31:16]          ),
    .B                       ( partial_sum[15:0]     ),
    .Cin                     ( dummy_Cout[0]        ),

    .Sum                     ( conv_out[15:0]        ),
    .Cout                    ( dummy_Cout[1]       )
);
endmodule