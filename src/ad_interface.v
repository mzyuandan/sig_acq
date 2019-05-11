//--------------------------------------------------------------------------------------------------
//
// Title		: ad_interface
// Design		: sig_acq
// Author		: mz
// Company		: xkf
// Date			: 2019.5.11
// Description	: Interface to the ADC (TLC3548)
//
//-------------------------------------------------------------------------------------------------


module ad_interface(
	clk,
	rst,
	ena,

	init_adc,
	cfg_adc,
	st_adc,

	cs_l,
	int_l,
	slck,
	fs,
	sdo,
	sdi,
	cstart,
	
	val_dat,
	ad_dat0,
	ad_dat1,
	ad_dat2,
	ad_dat3,
	ad_dat4,
	ad_dat5,
	ad_dat6,
	ad_dat7	
	);

parameter NUM_CLK_ADC = 121;
parameter NUM_CLK_CFG = 20;
	
input clk;
input rst;
input ena;

input init_adc;
input cfg_adc;
input st_adc;

output cs_l;
output int_l;
output slck;
output fs;
output sdo;
input sdi;
output cstart;

output val_dat;
output [13:0] ad_dat0;
output [13:0] ad_dat1;
output [13:0] ad_dat2;
output [13:0] ad_dat3;
output [13:0] ad_dat4;
output [13:0] ad_dat5;
output [13:0] ad_dat6;
output [13:0] ad_dat7;

reg init_en;
reg cfg_en;
reg [6:0] num_clk;
reg [6:0] cnt_conv;
reg [2:0] cnt_chan;


always @(posedge clk or negedge rst)
	if (!rst)
		cs_l <= 1'b1;
	else if (ena)
		cs_l <= 1'b0;
	else
		cs_l <= 1'b1;
	
always @(posedge clk or negedge rst)
	if (!rst)
		init_en <= 1'b0;
	else if (init_adc || cfg_adc)
		init_en <= 1'b1;
	else if (init_en && cnt_conv==NUM_CLK_CFG)
		init_en <= 1'b0;
		
always @(posedge clk or negedge rst)
	if (!rst)
		cfg_en <= 1'b0;
	else if (cfg_adc)
		cfg_en <= 1'b1;
	else if (cfg_en && cnt_conv==NUM_CLK_CFG)
		cfg_en <= 1'b0;
		
always @(posedge clk or negedge rst)
	if (!rst)
		num_clk <= 7'd0;
	else if (fs && (init_en || cfg_en))
		num_clk <= NUM_CLK_CFG;
	else
		num_clk <= 1'b0;
	
always @(posedge clk or negedge rst)
	if (!rst)
		fs <= 1'b0;
	else if (init_adc || (cnt_conv==num_clk && cnt_chan<3'd7))
		fs <= 1'b1;
	else
		fs <= 1'b0;

always @(posedge clk or negedge rst)
	if (!rst)
		cnt_conv <= 3'd0;
	else if (fs)
		cnt_conv <= 3'd0;
	else if (cnt_conv<num_clk)
		cnt_conv <= cnt_conv + 1'd1;
		
always @(posedge clk or negedge rst)
	if (!rst)
		cnt_chan <= 3'd0;
	else if (enc && cnt_chan==3'd7))
		cnt_chan <= 3'd0;
	else if (fs)
		cnt_chan <= cnt_chan + 1'd1;
		
always @(posedge clk or negedge rst)
	if (!rst)
		out_reg <= 16'd0;
	else if (fs && init_en)
		out_reg <= 16'hA000;
	else if (fs && cfg_en)
		out_reg <= 16'hA940;
	else if (fs)
		out_reg <= cnt_chan;



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
	//else if (count[19:0]==10'd0)	//10ms
	else if (ena && count[9:0]==10'd0)	//10us, for test
		pulse_10ms <= 1'b1;
	else
		pulse_10ms <= 1'b0;



endmodule
