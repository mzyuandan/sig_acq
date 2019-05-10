//--------------------------------------------------------------------------------------------------
//
// Title		: init_ctrl
// Design		: sig_acq
// Author		: mz
// Company		: xkf
// Date			: 2019.5.10
// Description	: Initialize the baudrate of UARTs and all orther devices 
//
//-------------------------------------------------------------------------------------------------

module init_ctrl(
	clk,
	rst,
	locded,
	
	latch_baud0,
	baud_word0, 
	latch_baud1,
	baud_word1,

	done
	);
	
parameter WAIT_LEN = 16'd32728;
parameter INIT_ST = 16'd1000;
parameter BAUD_WORD0_SET = 16'd1000;
parameter BAUD_WORD0_SET = 16'd1000;
	
input clk;
input rst;
input locded;

output reg latch_baud0;
output reg [15:0] baud_word0; 
output reg latch_baud1;
output reg [15:0] baud_word1;

output reg done;

reg locked_r;
reg [15:0] cnt = 16'd0;



always @(posedge clk or negedge rst)
	locked_r <= locked;

always @(posedge clk or negedge rst)
	if (!rst)
		cnt <= 16'd0;
	else if (locked && !locked_r)
		cnt <= 16'd0;
	else if (!done)
		cnt <= cnt + 1'd1;	
		
always @(posedge clk clk or negedge rst)
	if (!rst)
		done <= 1'b0;
	else if (locked && !locked_r)
		done <= 1'b0;
	else if (cnt==WAIT_LEN)
		done <= 1'b1;

always @(posedge clk clk or negedge rst)
	if (!rst)
		latch_baud0 <= 1'b0;
	else if (cnt==INIT_ST)
		latch_baud0 <= 1'b1;
	else
		latch_baud0 <= 1'b0;
		
assign baud_word0 = 16'd
			
		
endmodule

	
	
	