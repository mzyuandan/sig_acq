//--------------------------------------------------------------------------------------------------
//
// Title		: tb_wb_ale
// Design		: sig_acq
// Author		: mz
// Company		: xkf
// Date			: 2019.5.11
// Description	: Testbench for top module sig_acq
//
//-------------------------------------------------------------------------------------------------


`timescale 1ns / 1ps

`define PERIOD0 4.5
`define PERIOD1 270
`define PERIOD2 33.75
`define PERIOD3 20

module pll (
	inclk0,
	c0,
	c1,
	c2,
	c3,
	locked);

	input  inclk0;
	output  c0;
	output	 reg  c1;
	output	 reg  c2;
	output	 reg  c3;
	output	 locked;
	
	
initial 
begin
	c1 = 1'b0;
	c2 = 1'b0;
	c3 = 1'b0;
end
	
//always #`PERIOD0 c0 = ~c0;
always #`PERIOD1 c1 = ~c1;
always #`PERIOD2 c2 = ~c2;
always #`PERIOD3 c3 = ~c3;

assign c0  = inclk0;
assign locked = 1'b1;
	
	
endmodule