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

`define SIZE_ADDR      12'h000
`define CONTROL_ADDR   12'h040
`define SUM_ADDR       12'h080
`define BASE_ADDR      32'h1004_2000


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
    output  reg [6:0] SIZE,
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
        SIZE <= 32'h0;
        CONTROL <= 32'h0;//32'h0 idle, 32'h1 begin,
        //
    end
    else begin
        if(icb_cmd_valid & icb_cmd_ready & !icb_cmd_read) begin
            case(icb_cmd_addr[11:0])
                `SIZE_ADDR: SIZE <= icb_cmd_wdata;
                `CONTROL_ADDR:  CONTROL <= icb_cmd_wdata;
            endcase
        end
        else begin
            SIZE <=SIZE;
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
                `SIZE_ADDR:  icb_rsp_rdata <= SIZE;
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
