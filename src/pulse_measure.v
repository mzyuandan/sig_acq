//--------------------------------------------------------------------------------------------------
//
// Title		: pulse_measure
// Design		: sig_acq
// Author		: mz
// Company		: xkf
// Date			: 2019.5.10
// Description	: Measure the period and width of a pulse signal 
//
//-------------------------------------------------------------------------------------------------


module pulse_measure(
	clk,
	rst,
	ena,
	
	pulse,
	
	count,
	pulse_full,
	
	period,
	width
	);
	
input clk;
input rst;
input ena;

input pulse;

input [31:0] count;
input pulse_full;

output [31:0] period;
output [31:0] width;


reg pulse_r;
reg edge_l2h;
reg edge_h2l;
reg signed [32:0] time_12h;
reg signed [32:0] period_e;
reg signed [32:0] width_e;
reg signed [32:0] period_p;
reg signed [32:0] width_p;


wire signed [32:0] count_s;

assign count_s = {1'b0, count};

always @(posedge clk)
	pulse_r <= pulse;

always @(posedge clk or negedge rst)
	if (!rst)
		edge_l2h <= 1'b0;
	else if (pulse && !pulse_r)
		edge_l2h <= 1'b1;
	else
		edge_l2h <= 1'b0;
		
always @(posedge clk or negedge rst)
	if (!rst)
		edge_h2l <= 1'b0;
	else if (!pulse && pulse_r)
		edge_h2l <= 1'b1;
	else
		edge_h2l <= 1'b0;
		
always @(posedge clk or negedge rst)
	if (!rst)
		time_12h <= 33'd0;
	else if (edge_l2h)
		time_12h <= count_s;
		
always @(posedge clk or negedge rst)
	if (!rst)
		period_e <= 33'd0;
	else if (edge_l2h)
		period_e <= count_s - time_12h;

always @(posedge clk or negedge rst)
	if (!rst)
		width_e <= 33'd0;
	else if (edge_h2l)
		width_e <= count_s - time_12h;

always @(posedge clk or negedge rst)
	if (!rst)
		period_p <= 33'd0;
	else if (period_e<0)
		period_p <= period_e + 32'hFFFFFFFF;
	else
		period_p = period_e;
		
always @(posedge clk or negedge rst)
	if (!rst)
		width_p <= 33'd0;
	else if (width_e<0)
		width_p <= width_e + 32'hFFFFFFFF;
	else
		width_p = width_e;
		
assign period = period_p[31:0];
assign width = width_p[31:0];





endmodule
