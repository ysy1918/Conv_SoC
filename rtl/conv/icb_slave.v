// +FHDR----------------------------------------------------------------------------
// Project Name  : Soc_lab1
// Author        : LKai-Xu
// Created On    : 2022/06/04 20:50
// Last Modified : 2023/03/21 20:56
// File Name     : icb_slave.v
// Description   : icb slave module
//
//
// ---------------------------------------------------------------------------------
// Modification History:
// Date         By              Version                 Change Description
// ---------------------------------------------------------------------------------
// 2022/06/04   LKai-Xu         1.0                     Original
// 2023/03/21   Lisp           
// -FHDR----------------------------------------------------------------------------

`define IMAGE1_ADDR    12'h000
`define IMAGE2_ADDR    12'h004
`define IMAGE3_ADDR    12'h008
`define IMAGE4_ADDR    12'h00c//pass 16 8bit operand in 1 cycle at most
`define FILTER1_ADDR   12'h010
`define FILTER2_ADDR   12'h040
`define FILTER3_ADDR   12'h080
`define CONTROL_ADDR   12'h0c0
`define SUM_ADDR       12'h100


module icb_slave(
    // icb bus
    input               icb_cmd_valid,
    output  reg         icb_cmd_ready,
    input               icb_cmd_read,
    input       [31:0]  icb_cmd_addr,
    input       [31:0]  icb_cmd_wdata,
    input       [3:0]   icb_cmd_wmask,

    output  reg         icb_rsp_valid,
    input               icb_rsp_ready,
    output  reg [31:0]  icb_rsp_rdata,
    output              icb_rsp_err,

    // clk & rst_n
    input           clk,
    input           rst_n,

    // reg output
    output  reg [31:0]  IMAGE1,
    output  reg [31:0]  IMAGE2,
    output  reg [31:0]  IMAGE3,
    output  reg [31:0]  IMAGE4,
    output  reg [31:0]  FILTER1,
    output  reg [31:0]  FILTER2,
    output  reg [31:0]  FILTER3,
    output  reg [31:0]  FILTER4,
    output  reg [31:0]  CONTROL,
    input  reg [31:0]  SUM

);

assign icb_rsp_err = 1'b0;

// cmd ready, icb_cmd_ready
always@(posedge clk)
begin
    if(!rst_n) begin
        icb_cmd_ready <= 1'b0;
    end
    else begin
        if(icb_cmd_valid & icb_cmd_ready) begin
            icb_cmd_ready <= 1'b0;
        end
        else if(icb_cmd_valid) begin
            icb_cmd_ready <= 1'b1;
        end
        else begin
            icb_cmd_ready <= icb_cmd_ready;
        end
    end
end

// ADDR and PARAM setting
always@(posedge clk)
begin
    if(!rst_n) begin
        IMAGE1 <= 32'h0;
        IMAGE2 <= 32'h0;
        IMAGE3 <= 32'h0;
        IMAGE4 <= 32'h0;
        FILTER1 <= 32'h0;
        FILTER2 <= 32'h0;
        FILTER3 <= 32'h0;
        CONTROL <= 32'h0;//32'h0 idle, 32'h1 slide image, 32'h2 change image row, 32'h4 change filter,
        //
    end
    else begin
        if(icb_cmd_valid & icb_cmd_ready & !icb_cmd_read) begin
            case(icb_cmd_addr[11:0])
                `IMAGE1_ADDR:  IMAGE1 <= icb_cmd_wdata;
                `IMAGE2_ADDR:  IMAGE2 <= icb_cmd_wdata;
                `IMAGE3_ADDR:  IMAGE3 <= icb_cmd_wdata;
                `IMAGE4_ADDR:  IMAGE4 <= icb_cmd_wdata;
                `FILTER1_ADDR:  FILTER1 <= icb_cmd_wdata;
                `FILTER2_ADDR:  FILTER2 <= icb_cmd_wdata;
                `FILTER3_ADDR:  FILTER3 <= icb_cmd_wdata;
                `CONTROL_ADDR:  CONTROL <= icb_cmd_wdata;
            endcase
        end
        else begin
            IMAGE1 <=IMAGE1;
            IMAGE2 <=IMAGE2;
            IMAGE3 <=IMAGE3;
            IMAGE4 <=IMAGE4;
            FILTER1 <= FILTER1;
            FILTER2 <= FILTER2;
            FILTER3 <= FILTER3;
            CONTROL <= CONTROL;
        end
    end
end


// response valid, icb_rsp_valid
always@(posedge clk)
begin
    if(!rst_n) begin
        icb_rsp_valid <= 1'h0;
    end
    else begin
        if(icb_cmd_valid & icb_cmd_ready) begin
            icb_rsp_valid <= 1'h1;
        end
        else if(icb_rsp_valid & icb_rsp_ready) begin
            icb_rsp_valid <= 1'h0;
        end
        else begin
            icb_rsp_valid <= icb_rsp_valid;
        end
    end
end

// read data, icb_rsp_rdata
always@(posedge clk)
begin
    if(!rst_n) begin
        icb_rsp_rdata <= 32'h0;
    end
    else begin
        if(icb_cmd_valid & icb_cmd_ready & icb_cmd_read) begin
            case(icb_cmd_addr[11:0])
                `IMAGE1_ADDR:  icb_rsp_rdata <= IMAGE1;
                `IMAGE2_ADDR:  icb_rsp_rdata <= IMAGE2;
                `IMAGE3_ADDR:  icb_rsp_rdata <= IMAGE3;
                `IMAGE4_ADDR:  icb_rsp_rdata <= IMAGE4;
                `FILTER1_ADDR:  icb_rsp_rdata <= FILTER1;
                `FILTER2_ADDR:  icb_rsp_rdata <= FILTER2;
                `FILTER3_ADDR:  icb_rsp_rdata <= FILTER3;
                `CONTROL_ADDR:  icb_rsp_rdata <= CONTROL;
                `SUM_ADDR: icb_rsp_rdata <= SUM;
            endcase
        end
        else begin
            icb_rsp_rdata <= 32'h0;
        end
    end
end

endmodule
