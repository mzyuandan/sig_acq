//--------------------------------------------------------------------------------------------------
//
// Title		: timer32
// Design		: sig_acq
// Author		: mz
// Company		: xkf
// Date			: 2019.5.10
// Description	: 28bit timer, with working clock 110.592MHz
//
//-------------------------------------------------------------------------------------------------

`timescale 1 ns/ 1 ps

module timer32(
	clk,
	rst,

	clr,
	ena,
	
	count,
	pulse_full,
	pulse_10ms
	);

parameter COUNT_10MS = 32'd1105919;
	
input clk;
input rst;

input clr;

output reg [27:0] count;
output reg pulse_full;
output reg pulse_10ms;


always @(posedge clk or negedge rst)
	if (!rst)
		count <= 32'd0;
	else if (clr)
		count <= 32'd0;
	else if (ena && count==32'hFFFFFFFF)
		count <= 32'd0;
	else if (ena)
		count <= count + 1'd1;

always @(posedge clk or negedge rst)
	if (!rst)
		pulse_full <= 1'b0;
	else if (clr)
		pulse_full <= 1'b0;
	else if (ena && count==32'hFFFFFFFF)
		pulse_full <= 1'b1;
	else
		pulse_full <= 1'b0;
		
always @(posedge clk or negedge rst)
	if (!rst)
		pulse_10ms <= 1'b0;
	else if (clr)
		pulse_10ms <= 1'b0;
	else if (ena && count==COUNT_10MS)
		pulse_10ms <= 1'b1;
	else
		pulse_10ms <= 1'b0;



endmodule