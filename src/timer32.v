//--------------------------------------------------------------------------------------------------
//
// Title		: timer32
// Design		: sig_acq
// Author		: mz
// Company		: xkf
// Date			: 2019.5.10
// Description	: 32bit timer, with working clock 110.592MHz
//
//-------------------------------------------------------------------------------------------------


module timer32(
	clk,
	rst,

	clr,
	ena,
	
	count,
	pulse_full,
	pulse_10ms,
	cnt_10ms,
	pulse_1s
	);

//parameter COUNT_10MS = 32'd1105919;
parameter COUNT_10MS = 19;
	
input clk;
input rst;
input ena;

input clr;

output reg [31:0] count;
output reg pulse_full;
output reg pulse_10ms;
output reg [15:0] cnt_10ms;
output reg pulse_1s;


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
	else if (count==32'hFFFFFFFF)
		pulse_full <= 1'b1;
	else
		pulse_full <= 1'b0;
		
always @(posedge clk or negedge rst)
	if (!rst)
		pulse_10ms <= 1'b0;
	else if (clr)
		pulse_10ms <= 1'b0;
	//else if (ena && count[19:0]==20'd0)	//10ms
	else if (ena && count[26:0]==32'd0)	//10us, for test
		pulse_10ms <= 1'b1;
	else
		pulse_10ms <= 1'b0;
		
always @(posedge clk or negedge rst)
	if (!rst)
		cnt_10ms <= 1'b0;
	else if (clr)
		cnt_10ms <= 1'b0;
	else if (ena && pulse_10ms)	//10us, for test
		cnt_10ms <= cnt_10ms + 1'd1;

always @(posedge clk or negedge rst)
	if (!rst)
		pulse_1s <= 1'b0;
	else if (clr)
		pulse_1s <= 1'b0;
	else if (ena && count[25:0]==32'd0)
	//else if (ena && count[16:0]==32'd0)	//1ms, for test
		pulse_1s <= 1'b1;
	else
		pulse_1s <= 1'b0;


endmodule
