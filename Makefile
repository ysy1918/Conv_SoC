
	vsim -gui -novopt work.tb_conv_top
	add wave -position end  sim:/tb_conv_top/u_conv_top/image
	add wave -position end  sim:/tb_conv_top/u_conv_top/filter
	add wave -position end  sim:/tb_conv_top/u_conv_top/cal_begin
	add wave -position end  sim:/tb_conv_top/u_conv_top/status
	add wave -position end  sim:/tb_conv_top/u_conv_top/col_cnt
	add wave -position end  sim:/tb_conv_top/u_conv_top/stablizer
	add wave -position end  sim:/tb_conv_top/u_conv_top/CONTROL
	add wave -position end  sim:/tb_conv_top/u_conv_top/EN
	add wave -position end  sim:/tb_conv_top/u_conv_top/col_cnt_next
	add wave -position end  sim:/tb_conv_top/u_conv_top/conv_out
	add wave -position end  sim:/tb_conv_top/u_conv_top/addr_r
	add wave -position end  sim:/tb_conv_top/u_conv_top/addr_w
	add wave -position end  sim:/tb_conv_top/u_conv_top/we
	add wave -position end  sim:/tb_conv_top/u_conv_top/re
	add wave -position end  sim:/tb_conv_top/u_conv_top/dout
	add wave -position end  sim:/tb_conv_top/u_conv_top/u_conv_core_full_2x2/u_conv_core_1channel_2x2_1/image
	add wave -position end  sim:/tb_conv_top/u_conv_top/u_conv_core_full_2x2/u_conv_core_1channel_2x2_2/image
	add wave -position end  sim:/tb_conv_top/u_conv_top/u_conv_core_full_2x2/u_conv_core_1channel_2x2_3/image
	add wave -position 18  sim:/tb_conv_top/u_conv_top/u_conv_core_full_2x2/u_conv_core_1channel_2x2_1/filter
	add wave -position 19  sim:/tb_conv_top/u_conv_top/u_conv_core_full_2x2/u_conv_core_1channel_2x2_2/filter
	add wave -position 20  sim:/tb_conv_top/u_conv_top/u_conv_core_full_2x2/u_conv_core_1channel_2x2_3/filter
	add wave -position end  sim:/tb_conv_top/u_conv_top/u_conv_core_full_2x2/u_conv_core_1channel_2x2_1/conv_out
	add wave -position end  sim:/tb_conv_top/u_conv_top/u_conv_core_full_2x2/u_conv_core_1channel_2x2_2/conv_out
	add wave -position end  sim:/tb_conv_top/u_conv_top/u_conv_core_full_2x2/u_conv_core_1channel_2x2_3/conv_out
	add wave -position end  sim:/tb_conv_top/u_conv_top/u_conv_core_full_2x2/u_conv_core_1channel_2x2_1/u_conv_core_2x2_0/image
	add wave -position end  sim:/tb_conv_top/u_conv_top/u_conv_core_full_2x2/u_conv_core_1channel_2x2_1/u_conv_core_2x2_0/filter
	add wave -position end  sim:/tb_conv_top/u_conv_top/u_conv_core_full_2x2/u_conv_core_1channel_2x2_1/u_conv_core_2x2_0/conv_out
	add wave -position end  sim:/tb_conv_top/u_conv_top/u_conv_core_full_2x2/u_conv_core_1channel_2x2_2/u_conv_core_2x2_0/filter
	add wave -position 27  sim:/tb_conv_top/u_conv_top/u_conv_core_full_2x2/u_conv_core_1channel_2x2_2/u_conv_core_2x2_0/image
	run 300000