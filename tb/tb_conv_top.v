`timescale  1ns / 1ps

module tb_conv_top;

// conv_top Parameters
parameter PERIOD             = 10 ;
parameter SIZE               = 8  ;
parameter ADDR_WIDTH         = 9  ;
parameter DATA_WIDTH         = 8  ;
parameter STRIDE_IMAGE_READ  = 15 ;
parameter ADDR_FILTER        = 256;

// conv_top Inputs
reg   clk                                  = 1 ;
reg   rst_n                                = 0 ;
reg   icb_cmd_valid                        = 0 ;
reg   icb_cmd_read                         = 0 ;
reg   [31:0]  icb_cmd_addr                 = 0 ;
reg   [31:0]  icb_cmd_wdata                = 0 ;
reg   icb_rsp_valid                        = 0 ;

// conv_top Outputs
wire  icb_cmd_ready                        ;
wire  icb_rsp_ready                        ;
wire  [31:0]  icb_rsp_rdata                ;
wire  icb_rsp_err                          ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) rst_n  =  1;
end

conv_top #(
    .SIZE              ( SIZE              ),
    .ADDR_WIDTH        ( ADDR_WIDTH        ),
    .DATA_WIDTH        ( DATA_WIDTH        ),
    .STRIDE_IMAGE_READ ( STRIDE_IMAGE_READ ),
    .ADDR_FILTER       ( ADDR_FILTER       ))
 u_conv_top (
    .clk                     ( clk                   ),
    .rst_n                   ( rst_n                 ),
    .icb_cmd_valid           ( icb_cmd_valid         ),
    .icb_cmd_read            ( icb_cmd_read          ),
    .icb_cmd_addr            ( icb_cmd_addr   [31:0] ),
    .icb_cmd_wdata           ( icb_cmd_wdata  [31:0] ),
    .icb_rsp_valid           ( icb_rsp_valid         ),

    .icb_cmd_ready           ( icb_cmd_ready         ),
    .icb_rsp_ready           ( icb_rsp_ready         ),
    .icb_rsp_rdata           ( icb_rsp_rdata  [31:0] ),
    .icb_rsp_err             ( icb_rsp_err           )
);

initial
begin
    #(PERIOD*3) begin
        icb_cmd_valid <= 1;
        icb_cmd_wdata <= 32'b1;
        icb_cmd_addr <= 32'h1004_2040;
    end

    #(PERIOD*5) begin
        icb_cmd_valid <= 1;
        icb_cmd_read <= 1;
    end
end

endmodule