module conv_core_1channel_2x2 (
    input [8*2*(2+3)-1:0] image,//8bit*k*(k+3)*C
    input [8*2*2-1:0] filter,
    output [4*16-1:0] conv_out,

    input clk,
    input rst_n
);
//4 conv, each conv 4 mult
    /*wire [8*2*2-1:0] filter1, filter2, filter3;
    wire [8*2*(2+3)-1:0] image1, image2, image3;
    reg [16*8*3-1:0] reg_mult_out;
    wire  [16*8*3-1:0]  mult_out;

    assign image1 = image[8*2*(2+3)*1-1:0];
    assign image2 = image[8*2*(2+3)*2-1:8*2*(2+3)*1];
    assign image3 = image[8*2*(2+3)*3-1:8*2*(2+3)*2];

    assign filter1 = filter[8*2*2-1:0];
    assign filter2 = filter[8*2*2*2-1:8*2*2];
    assign filter3 = filter[8*2*2*3-1:8*2*2*2];
    reg [16*16-1:0] reg_mult_out;
    wire  [16*16-1:0]  mult_out;*/

// mult

conv_core_2x2  u_conv_core_2x2_0 (
    .image                   ( {image[55:40], image[15:0]}      ),
    .filter                  ( filter     ),
    .clk                     ( clk        ),
    .rst_n                   ( rst_n      ),

    .conv_out                ( conv_out[15:0]   )
);

conv_core_2x2  u_conv_core_2x2_1 (
    .image                   ( {image[63:48], image[23:8]}      ),
    .filter                  ( filter     ),
    .clk                     ( clk        ),
    .rst_n                   ( rst_n      ),

    .conv_out                ( conv_out[31:16]   )
);

conv_core_2x2  u_conv_core_2x2_2 (
    .image                   ( {image[71:56], image[31:16] }     ),
    .filter                  ( filter     ),
    .clk                     ( clk        ),
    .rst_n                   ( rst_n      ),

    .conv_out                ( conv_out[47:32]   )
);

conv_core_2x2  u_conv_core_2x2_3 (
    .image                   ( {image[79:64], image[39:24] }     ),
    .filter                  ( filter     ),
    .clk                     ( clk        ),
    .rst_n                   ( rst_n      ),

    .conv_out                ( conv_out[63:48]   )
);

endmodule