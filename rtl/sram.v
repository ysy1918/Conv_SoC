
module sram #(
    parameter ADDR_WIDTH = 9,
    parameter DATA_WIDTH = 8
) (
    input clk,
    input [ADDR_WIDTH-1:0] addr_r,
    input [ADDR_WIDTH-1:0] addr_w,
    input [8*DATA_WIDTH-1:0] din, 
    input we,
    input re,
    output reg [16*DATA_WIDTH-1:0] dout
);

    reg [DATA_WIDTH-1:0] mem_r [512-1:0];//conv: 0~383 read, 384~511 write
    reg [7:0] i;

    always @(posedge clk) begin
        if(re) begin
            dout[DATA_WIDTH-1:0] <= mem_r[addr_r];
            dout[2*DATA_WIDTH-1:1*DATA_WIDTH] <= mem_r[addr_r+1];
            dout[3*DATA_WIDTH-1:2*DATA_WIDTH] <= mem_r[addr_r+2];
            dout[4*DATA_WIDTH-1:3*DATA_WIDTH] <= mem_r[addr_r+3];
            dout[5*DATA_WIDTH-1:4*DATA_WIDTH] <= mem_r[addr_r+4];
            dout[6*DATA_WIDTH-1:5*DATA_WIDTH] <= mem_r[addr_r+5];
            dout[7*DATA_WIDTH-1:6*DATA_WIDTH] <= mem_r[addr_r+6];
            dout[8*DATA_WIDTH-1:7*DATA_WIDTH] <= mem_r[addr_r+7];
            dout[9*DATA_WIDTH-1:8*DATA_WIDTH] <= mem_r[addr_r+8];
            dout[10*DATA_WIDTH-1:9*DATA_WIDTH] <= mem_r[addr_r+9];  
            dout[11*DATA_WIDTH-1:10*DATA_WIDTH] <= mem_r[addr_r+10];  
            dout[12*DATA_WIDTH-1:11*DATA_WIDTH] <= mem_r[addr_r+11];  
            dout[13*DATA_WIDTH-1:12*DATA_WIDTH] <= mem_r[addr_r+12];  
            dout[14*DATA_WIDTH-1:13*DATA_WIDTH] <= mem_r[addr_r+13];  
            dout[15*DATA_WIDTH-1:14*DATA_WIDTH] <= mem_r[addr_r+14];  
            dout[16*DATA_WIDTH-1:15*DATA_WIDTH] <= mem_r[addr_r+15];
        end
        if(we) begin
            mem_r[addr_w] <= din[7:0];
            mem_r[addr_w+1] <= din[15:8];
            mem_r[addr_w+2] <= din[23:16];
            mem_r[addr_w+3] <= din[31:24];
            mem_r[addr_w+4] <= din[39:32];
            mem_r[addr_w+5] <= din[47:40];
            mem_r[addr_w+6] <= din[55:48];
            mem_r[addr_w+7] <= din[63:56];
        end
    end



    initial $readmemb("C:/Users/13069/Desktop/class_file/Master/SoC/CNN_accelerator/Conv_SoC/auxi/data.bin", mem_r);


endmodule 

