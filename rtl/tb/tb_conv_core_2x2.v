`timescale  1ns / 1ps

module tb_conv_core_2x2;

// conv_core_2x2 Parameters
parameter PERIOD  = 10;


// conv_core_2x2 Inputs
reg   [8*2*2-1:0]  image                   = 0 ;
reg   [8*2*2-1:0]  filter                  = 0 ;
reg   clk                                  = 0 ;
reg   rst_n                                = 0 ;

// conv_core_2x2 Outputs
wire  [15:0]  conv_out                     ;
//reg [9:0] temp = 0;
//reg [0:7] temp2 = 8'b11110000;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD) rst_n  =  1;
end

conv_core_2x2  u_conv_core_2x2 (
    .image                   ( image     [8*2*2-1:0] ),
    .filter                  ( filter    [8*2*2-1:0] ),
    .clk                     ( clk                   ),
    .rst_n                   ( rst_n                 ),

    .conv_out                ( conv_out  [15:0]      )
);

initial
begin
    #(PERIOD*2) begin
        image = {8'd1,8'd2,8'd3,8'd4};
        filter = {8'd1,8'd2,8'd1,8'd0};
        //temp = temp2[0:7];
    end
    #(PERIOD*4) begin
        image = {8'd2,8'd5,8'd3,8'd4};
        filter = {8'd1,8'd0,8'd3,8'd0};
    end
end

endmodule