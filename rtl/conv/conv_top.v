module conv_top (
input clk,
input rst_n,

    // icb slave
input                           icb_cmd_valid,
output                          icb_cmd_ready,
input                           icb_cmd_read,
input       [31:0]              icb_cmd_addr,
input       [31:0]              icb_cmd_wdata,

input                          icb_rsp_valid,
output                           icb_rsp_ready,
output      [31:0]              icb_rsp_rdata,
output                          icb_rsp_err 

);
    parameter SIZE = 8;
    parameter ADDR_WIDTH  = 9;
    parameter DATA_WIDTH  = 8;
    parameter STRIDE_IMAGE_READ = 15;
    parameter ADDR_FILTER = 240;

    reg [8*2*5*3-1:0] image;
    reg [8*2*2*3-1:0] filter;
    //reg cal_begin;
    reg [7:0] status;
    reg [6:0] size_cnt;
    reg [3:0] col_cnt;
    reg [3:0] wr_cnt;
    reg [1:0] row_cnt;
    reg [1:0] stablizer;

    //wire [6:0]   SIZE;
    wire [31:0]  SUM;
    wire  [3:0]  icb_cmd_wmask;
    wire [31:0]  CONTROL;
    wire EN;
    wire [3:0] col_cnt_next;

    wire [4*16-1:0] conv_out;

    // sram_col100 Inputs
    reg   [ADDR_WIDTH-1:0]  addr_r;
    reg   [ADDR_WIDTH-1:0]  addr_w;
    reg   we;
    reg   re;

    // sram_col100 Outputs
    wire  [16*DATA_WIDTH-1:0]  dout;

    assign EN = CONTROL[0];
    assign col_cnt_next = col_cnt + 1;

//FSM 
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        status <= 'b0;
        addr_r <= 9'd240;
        addr_w <= 9'b1_1000_0000;
        //cal_begin <= 0;
        size_cnt <= 'b0;
        col_cnt <= 'b0;
        wr_cnt <= 'b0;
        row_cnt <= 'b0;
        stablizer <= 'b0;
        we <= 0;
        re <= 1;
        image <= 'b0;
        filter <= 'b0;
    end
    else if( EN && (status == 0) ) begin //setup filter
        stablizer <= stablizer + 1'b1;
        case (stablizer)
            2'b00: begin
                col_cnt <= 4'b1;
                wr_cnt <= 4'b1;
                //cal_begin <= 0;
                addr_r <= 9'd0;
                we <= 0;
            end
            2'b01: begin 
                status <= 8'h4;
                addr_r <= col_cnt * STRIDE_IMAGE_READ + 135 * row_cnt;
                col_cnt <= col_cnt + 4'b0001;
                wr_cnt <= wr_cnt + 4'b0001;
            end
            default: stablizer <= 'b0;
        endcase        
    end
    else if(EN && (status == 4) && col_cnt < 4'b0011) begin //load image
        if(stablizer == 2'b01) begin //wait 1 cycle 
            stablizer <= stablizer + 1'b1;
            wr_cnt <= wr_cnt + 4'b0001;
        end
        else begin
            stablizer <= 'b0;
            status <= 8'h4;
            addr_r <= col_cnt * STRIDE_IMAGE_READ + 135 * row_cnt; //addr_r+15
            col_cnt <= col_cnt + 4'b0001;
            wr_cnt <= wr_cnt + 4'b0001;
        end
            /*stablizer <= 'b0;
            status <= 8'h4;
            addr_r <= col_cnt * STRIDE_IMAGE_READ + 135 * row_cnt; //addr_r+15
            col_cnt <= col_cnt + 4'b0001;*/
        //if(col_cnt_next >= 4'h2) cal_begin <= 1;
        //else cal_begin <= 0;
       
    end
    else if(EN && ( ( (status == 4) && col_cnt >= 4'b0011 ) || (status == 1) ) ) begin //busy
        if(col_cnt == 4'b1000) begin // to load
            col_cnt <= 4'b0;
            wr_cnt <= 'b0;
            row_cnt <= row_cnt +1;
            addr_r <= col_cnt * STRIDE_IMAGE_READ + 135 * row_cnt;
            status <= 8'h4;
            stablizer <= 2'b01;
        end
        else begin //go on cal
            col_cnt <= col_cnt + 4'b0001;
            wr_cnt <= wr_cnt + 4'b0001;
            //cal_begin <= 1;
            addr_r <= STRIDE_IMAGE_READ * col_cnt + 135 * row_cnt;
            status <= 8'h1;
        end
        
    end

    if(wr_cnt >= 4'h5) begin
            we <= 1;
            addr_w <= addr_w + 9'b0_0000_0100;
    end  //wait 1 cycle for conv output
    else if (wr_cnt == 4'h4) we <= 0;
end

//FSM end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        image <= 'b0;
        filter <= 'b0;
    end
    else begin
        case (status)
            8'h1:begin //busy
                image[8*5*3-1:0] <= image[8*2*5*3-1:8*5*3];
                if(col_cnt != 4'h8) //padding
                image[8*2*5*3-1:8*5*3] <= dout[15*DATA_WIDTH-1:0];
                else image[8*2*5*3-1:8*5*3] <= 'b0;
            end 
            8'h4:begin //setup/load image
                image[8*5*3-1:0] <= image[8*2*5*3-1:8*5*3];
                image[8*2*5*3-1:8*5*3] <= dout[15*DATA_WIDTH-1:0];
            end
            8'h0:begin //setup filter
                filter = dout[12*DATA_WIDTH-1:0];
            end //always first do, refresh anyway, no need wait for EN.
            default: ; //idle
        endcase

    end
end



conv_core_full_2x2  u_conv_core_full_2x2 (
    .image                   ( image      ),
    .filter                  ( filter     ),
    .clk                     ( clk    ),
    .rst_n                   ( rst_n      ),

    .conv_out                ( conv_out   )
    //.EN                      ( cal_begin         )
);

icb_slave  u_icb_slave (
    .icb_cmd_valid           ( icb_cmd_valid   ),
    .icb_cmd_read            ( icb_cmd_read    ),
    .icb_cmd_addr            ( icb_cmd_addr    ),
    .icb_cmd_wdata           ( icb_cmd_wdata   ),
    .icb_cmd_wmask           ( icb_cmd_wmask   ),
    .icb_rsp_ready           ( icb_rsp_ready   ),
    .clk                     ( clk             ),
    .rst_n                   ( rst_n           ),
    .SUM                     ( SUM             ),

    .icb_cmd_ready           ( icb_cmd_ready   ),
    .icb_rsp_valid           ( icb_rsp_valid   ),
    .icb_rsp_rdata           ( icb_rsp_rdata   ),
    .icb_rsp_err             ( icb_rsp_err     ),
    //.SIZE                    ( SIZE            ),
    .CONTROL                 ( CONTROL         )
);

sram #(
    .ADDR_WIDTH ( 9 ),
    .DATA_WIDTH ( 8 ))
 u_sram (
    .clk                     ( clk    ),
    .addr_r                    ( addr_r   ),
    .addr_w                    ( addr_w  ),
    .din                     ( conv_out    ),
    .we                      ( we     ),
    .re                      ( re     ),

    .dout                    ( dout   )
);
endmodule