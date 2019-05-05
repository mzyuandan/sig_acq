//--------------------------------------------------------------------------------------------------
//
// Title		: led_blink
// Design		: sig_acq
// Author		: mz
// Company		: xkf
// Date			: 2019.5.5
// Description	: Blinking the led
//
//-------------------------------------------------------------------------------------------------

module led_blink(
	clk,
	rst,
	led_out
	);
	
input clk;
input rst;
output reg led_out;

reg pll_lock_d;
reg [24:0] cnt;

parameter LOW_LEN = 25'd12500000;
		
always @(posedge clk, negedge rst)
	if (!rst)
		led_out <= 1'b1;
	else if (cnt==LOW_LEN)
		led_out <= ~led_out;

always @(posedge clk, negedge rst)
	if (!rst)
		cnt <= 24'd0;
	else if (cnt==LOW_LEN)
		cnt <= 24'd0;
	else
		cnt <= cnt + 1'd1;	
		
endmodule

	
	
	