module conv_core_full_2x2 (
    input [8*2*(2+3)*3-1:0] image,//8bit*k*(k+3)*C
    input [8*2*2*3-1:0] filter,
    output [4*16-1:0] conv_out,

    input clk_spi,
    input rst_n
);

//4 conv, each conv 4 mult
    wire [8*2*2-1:0] filter1, filter2, filter3;
    wire [8*2*(2+3)-1:0] image1, image2, image3;
    wire  [16*4-1:0]  channel_out1, channel_out2, channel_out3;
    reg [63:0] out;

    assign image1 = image[8*2*(2+3)*1-1:0];
    assign image2 = image[8*2*(2+3)*2-1:8*2*(2+3)*1];
    assign image3 = image[8*2*(2+3)*3-1:8*2*(2+3)*2];

    assign filter1 = filter[8*2*2-1:0];
    assign filter2 = filter[8*2*2*2-1:8*2*2];
    assign filter3 = filter[8*2*2*3-1:8*2*2*2];
    assign conv_out = out;

    always @(posedge clk_spi or negedge rst_n) begin
        if(!rst_n && (channel_out1 == 0) && (channel_out2 == 0) && (channel_out3 == 0)) out = 0;//output reset last
            else begin
                out[4*16-1:3*16] = channel_out1[4*16-1:3*16] + channel_out2[4*16-1:3*16] + channel_out3[4*16-1:3*16];
                out[3*16-1:2*16] = channel_out1[3*16-1:2*16] + channel_out2[3*16-1:2*16] + channel_out3[3*16-1:2*16];
                out[2*16-1:1*16] = channel_out1[2*16-1:1*16] + channel_out2[2*16-1:1*16] + channel_out3[2*16-1:1*16];
                out[1*16-1:0*16] = channel_out1[1*16-1:0*16] + channel_out2[1*16-1:0*16] + channel_out3[1*16-1:0*16];
            end

    end
    

// mult
    conv_core_1channel_2x2  u_conv_core_1channel_2x2_1 (
    .image                   ( image1      ),
    .filter                  ( filter1     ),
    .clk                     ( clk        ),
    .rst_n                   ( rst_n      ),

    .conv_out                ( channel_out1   )
    );

    conv_core_1channel_2x2  u_conv_core_1channel_2x2_2 (
    .image                   ( image2      ),
    .filter                  ( filter2     ),
    .clk                     ( clk        ),
    .rst_n                   ( rst_n      ),

    .conv_out                ( channel_out2   )
    );

    conv_core_1channel_2x2  u_conv_core_1channel_2x2_3 (
    .image                   ( image3      ),
    .filter                  ( filter3     ),
    .clk                     ( clk        ),
    .rst_n                   ( rst_n      ),

    .conv_out                ( channel_out3   )
    );

    
endmodule