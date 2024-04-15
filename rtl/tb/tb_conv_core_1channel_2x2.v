`timescale  1ns / 1ps

module tb_conv_core_1channel_2x2;

// conv_core_1channel_2x2 Parameters
parameter PERIOD  = 10;


// conv_core_1channel_2x2 Inputs
reg   [8*2*(2+3)-1:0]  image               = 0 ;
reg   [8*2*2-1:0]  filter                  = 0 ;
reg   clk                                  = 0 ;
reg   rst_n                                = 0 ;

// conv_core_1channel_2x2 Outputs
wire  [4*16-1:0]  conv_out                 ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD) rst_n  =  1;
end

conv_core_1channel_2x2  u_conv_core_1channel_2x2 (
    .image                   ( image     [8*2*(2+3)-1:0] ),
    .filter                  ( filter    [8*2*2-1:0]     ),
    .clk                     ( clk                       ),
    .rst_n                   ( rst_n                     ),

    .conv_out                ( conv_out  [4*16-1:0]      )
);

initial
begin
    image = {8'd1, 8'd2, 8'd3, 8'd4, 8'd1, 8'd2, 8'd3, 8'd4, 8'd1, 8'd2};
    filter = {8'd1,8'd2,8'd1,8'd0};

end

endmodule