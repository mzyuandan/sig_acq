//--------------------------------------------------------------------------------------------------
//
// Title		: pulse_gen
// Design		: sig_acq
// Author		: mz
// Company		: xkf
// Date			: 2019.5.13
// Description	: pulse signal generation, for test use, do not included in fianl design!
//
//-------------------------------------------------------------------------------------------------


module pulse_gen(
	clk,
	rst,

	clr,
	ena,
	
	pulse0,
	pulse1
	);

//parameter COUNT_10MS = 32'd1105919;
parameter COUNT_10MS = 19;
	
input clk;
input rst;
input ena;

input clr;

output reg pulse0;
output reg pulse1;

reg [31:0] count;


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
		pulse0 <= 1'b0;
	else if (count[9:0]>=10'd100 && count[9:0]<10'd120)
		pulse0 <= 1'b1;
	else
		pulse0 <= 1'b0;
		
always @(posedge clk or negedge rst)
	if (!rst)
		pulse1 <= 1'b0;
	else if (count[10:0]>=11'd400 && count[10:0]<11'd500)
		pulse1 <= 1'b1;
	else
		pulse1 <= 1'b0;



endmodule
