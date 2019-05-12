//--------------------------------------------------------------------------------------------------
//
// Title		: init_ctrl
// Design		: sig_acq
// Author		: mz
// Company		: xkf
// Date			: 2019.5.10
// Description	: Initialize the baudrate of UARTs and generate 
//				  the initialization signal to the ADC (TLC3548) 
//
//-------------------------------------------------------------------------------------------------

module init_ctrl(
	clk,
	clk_l,
	clk_u,
	rst,
	locked,
	
	latch_baud0,
	baud_word0, 
	latch_baud1,
	baud_word1,
	
	init_adc,

	done
	);
	
parameter WAIT_LEN_U = 16'd200;
parameter INIT_ST_U = 16'd100;
parameter BAUD_WORD0_SET = 16'd2;
parameter WAIT_LEN_L = 16'd30;
parameter INIT_ST_L = 16'd4;
	
input clk;
input clk_l;
input clk_u;
input rst;
input locked;

output reg latch_baud0;
output [15:0] baud_word0; 
output reg latch_baud1;
output [15:0] baud_word1;

output reg init_adc;

output reg done;

reg locked_ur;
reg [15:0] cnt_u;
reg done_u;

reg locked_lr;
reg [15:0] cnt_l;
reg done_l;


always @(posedge clk_u)
	locked_ur <= locked;

always @(posedge clk_u or negedge rst)
	if (!rst)
		cnt_u <= 16'd0;
	else if (locked && !locked_ur)
		cnt_u <= 16'd0;
	else if (!done_u)
		cnt_u <= cnt_u + 1'd1;	
		
always @(posedge clk_u or negedge rst)
	if (!rst)
		done_u <= 1'b0;
	else if (locked && !locked_ur)
		done_u <= 1'b0;
	else if (cnt_u==WAIT_LEN_U)
		done_u <= 1'b1;

always @(posedge clk_u or negedge rst)
	if (!rst)
		latch_baud0 <= 1'b0;
	else if (cnt_u==INIT_ST_U)
		latch_baud0 <= 1'b1;
	else
		latch_baud0 <= 1'b0;
		
assign baud_word0 = BAUD_WORD0_SET;

always @(posedge clk_u or negedge rst)
	if (!rst)
		latch_baud1 <= 1'b0;
	else if (cnt_u==INIT_ST_U)
		latch_baud1 <= 1'b1;
	else
		latch_baud1 <= 1'b0;
		
assign baud_word1 = BAUD_WORD0_SET;
		

always @(posedge clk_l)
	locked_lr <= locked;

always @(posedge clk_l or negedge rst)
	if (!rst)
		cnt_l <= 16'd0;
	else if (locked && !locked_lr)
		cnt_l <= 16'd0;
	else if (!done_l)
		cnt_l <= cnt_l + 1'd1;	
		
always @(posedge clk_l or negedge rst)
	if (!rst)
		done_l <= 1'b0;
	else if (locked && !locked_lr)
		done_l <= 1'b0;
	else if (cnt_l==WAIT_LEN_L)
		done_l <= 1'b1;	
		
always @(posedge clk_l or negedge rst)
	if (!rst)
		init_adc <= 1'b0;
	else if (cnt_l==INIT_ST_L)
		init_adc <= 1'b1;
	else
		init_adc <= 1'b0;
		
always @(posedge clk or negedge rst)
	if (!rst)
		done <= 1'b0;
	else if (done_u && done_l)
		done <= 1'b1;
	else
		done <= 1'b0;
		
endmodule

	
	
	