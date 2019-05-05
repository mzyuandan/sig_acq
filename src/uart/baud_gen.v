//--------------------------------------------------------------------------------------------------
//
// Title		: baud_gen
// Design		: sig_acq
// Author		: mz
// Company		: xkf
// Date			: 2019.5.5
// Description	: Baud rate generate for UART
//
//--------------------------------------------------------------------------------------------------

module baud_gen (
	clk,
	rst,
	//y_uart,
	
	latch,
	baud_word,	
	
	ena
	);
	
input clk;
input rst;
//input y_uart;
input latch;
input [15:0] baud_word;
output reg ena;
//wire y_l;

reg [15:0] cnt;
reg [15:0] baud_word_r;

//assign y_l = y_uart && latch;
always @(posedge clk or negedge rst)
	if (!rst)
		cnt <= 16'h0006;
	else 
		if (latch)
			cnt <= baud_word - 1'd1;
	else
		if (cnt==16'd0)
			cnt <= baud_word_r;
	else
		cnt <= cnt - 1'd1;
		
always @(posedge clk or negedge rst)
	if (!rst)
		baud_word_r <= 16'h0006;
	else 
		if (latch)
			baud_word_r <= baud_word - 1'd1;
			
always @(posedge clk or negedge rst)
	if (!rst)
		ena <= 1'b0;
	else 
		if (cnt==16'd0)
			ena <= 1'b1;
	else
		ena <= 1'b0;
	
endmodule