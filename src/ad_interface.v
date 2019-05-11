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

	init_adc,
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

parameter NUM_CLK_ADC = 24;
parameter NUM_CLK_CFG = 24;
parameter NUM_CLK = 24;
parameter NUM_LOAD = 20;
	
input clk;
input rst;

input init_adc;
input st_adc;

output cs_l;
input int_l;
output slck;
output reg fs;
output sdo;
input sdi;
output cstart;

output reg val_dat;
output reg [13:0] ad_dat0;
output reg [13:0] ad_dat1;
output reg [13:0] ad_dat2;
output reg [13:0] ad_dat3;
output reg [13:0] ad_dat4;
output reg [13:0] ad_dat5;
output reg [13:0] ad_dat6;
output reg [13:0] ad_dat7;


reg int_l_r;
reg init_en;
reg cfg_en;
reg chan_sel;
reg fifo_rd;
reg fs_cfg;
reg fs_chan;
reg fs_fifo;
reg [6:0] num_clk;
reg [6:0] cnt_conv;
reg [2:0] cnt_chan;
reg shift;
reg [15:0] out_reg;
reg [13:0] in_reg;

always @(posedge clk)
	int_l_r <= int_l;

assign cs_l = 1'b0;
	
always @(posedge clk or negedge rst)
	if (!rst)
		init_en <= 1'b0;
	else if (init_adc)
		init_en <= 1'b1;
	else if (init_en && cnt_conv==NUM_CLK)
		init_en <= 1'b0;
		
always @(posedge clk or negedge rst)
	if (!rst)
		cfg_en <= 1'b0;
	else if (st_adc)
		cfg_en <= 1'b1;
	else if (cfg_en && cnt_conv==NUM_CLK)
		cfg_en <= 1'b0;
		
always @(posedge clk or negedge rst)
	if (!rst)
		chan_sel <= 1'b0;
	else if (cfg_en && cnt_conv==NUM_CLK)
		chan_sel <= 1'b1;
	else if (chan_sel && cnt_conv==NUM_CLK && cnt_chan<3'd7)
		chan_sel <= 1'b0;
		
always @(posedge clk or negedge rst)
	if (!rst)
		fifo_rd <= 1'b0;
	else if (!int_l && int_l_r)
		fifo_rd <= 1'b1;
	else if (fifo_rd && cnt_conv==NUM_CLK && cnt_chan<3'd7)
		fifo_rd <= 1'b0;
		
// always @(posedge clk or negedge rst)
	// if (!rst)
		// num_clk <= 7'd0;
	// else if (fs && (init_en || cfg_en || fifo_rd))
		// num_clk <= NUM_CLK_CFG;
	// else
		// num_clk <= NUM_CLK_ADC;

always @(posedge clk or negedge rst)
	if (!rst)
		fs_cfg <= 1'b0;
	else if (init_adc || st_adc || (!int_l && int_l_r) || (cnt_conv==NUM_CLK && cnt_chan<3'd7))
		fs_cfg <= 1'b1;
	else
		fs_cfg <= 1'b0;
		
always @(posedge clk or negedge rst)
	if (!rst)
		fs_fifo <= 1'b0;
	else if ((!int_l && int_l_r) || (fifo_rd && cnt_conv==NUM_CLK && cnt_chan!=3'd0))
		fs_fifo <= 1'b1;
	else
		fs_fifo <= 1'b0;
		
always @(posedge clk or negedge rst)
	if (!rst)
		fs_chan <= 1'b0;
	else if (chan_sel && cnt_conv==NUM_CLK && cnt_chan!=3'd0)
		fs_chan <= 1'b1;
	else
		fs_chan <= 1'b0;

always @(posedge clk)
	fs <= fs_cfg || fs_fifo || fs_chan;

always @(posedge clk or negedge rst)
	if (!rst)
		cnt_conv <= 7'd0;
	else if (fs)
		cnt_conv <= 7'd0;
	else if (cnt_conv<NUM_CLK)
		cnt_conv <= cnt_conv + 1'd1;
		
always @(posedge clk or negedge rst)
	if (!rst)
		cnt_chan <= 3'd0;
	else if (st_adc)
		cnt_chan <= 3'd0;
	else if (fs && (chan_sel || fifo_rd))
		cnt_chan <= cnt_chan + 1'd1;
	
always @(posedge clk or negedge rst)
	if (!rst)
		shift <= 1'b0;
	else if (fs)
		shift <= 1'b1;
	else if (cnt_conv==6'd13)
		shift <= 1'b0;
	
assign state = {fifo_rd, chan_sel, cfg_en, init_en};	

always @(posedge clk or negedge rst)
	if (!rst)
		out_reg <= 16'd0;
	else if (fs)
		case (state)
			4'b0001: out_reg <= 16'hA000;
			4'b0010: out_reg <= 16'hAA40;
			4'b0100: out_reg <= cnt_chan;
			4'b1000: out_reg <= cnt_chan;
		endcase
	else if (shift)
		out_reg <= {out_reg[14:0], 1'b0};
		
assign slck = clk;
assign sdo = out_reg[15];
assign cstart = 1'b1;

always @(posedge clk or negedge rst)
	if (!rst)
		in_reg <= 14'd0;
	else if (shift && fifo_rd)
		in_reg <= {in_reg[13:1], sdi};
	else if (shift && fifo_rd && cnt_conv==NUM_LOAD)
		in_reg <= 16'd0;

always @(posedge clk or negedge rst)
	if (!rst)
		val_dat <= 1'b0;
	else if (st_adc)
		val_dat <= 1'b0;
	else if (shift && fifo_rd && cnt_conv==NUM_LOAD)
		val_dat <= 1'b1;

always @(posedge clk or negedge rst)
	if (!rst) begin
		ad_dat0 <= 14'd0;
		ad_dat1 <= 14'd0;
		ad_dat2 <= 14'd0;
		ad_dat3 <= 14'd0;
		ad_dat4 <= 14'd0;
		ad_dat5 <= 14'd0;
		ad_dat6 <= 14'd0;
		ad_dat7 <= 14'd0;
	end
	else if (fifo_rd && cnt_conv==NUM_LOAD+1'd1)
		case (cnt_chan)
			3'd0: ad_dat7 <= in_reg;
			3'd1: ad_dat0 <= in_reg;
			3'd2: ad_dat1 <= in_reg;
			3'd3: ad_dat2 <= in_reg;
			3'd4: ad_dat3 <= in_reg;
			3'd5: ad_dat4 <= in_reg;
			3'd6: ad_dat5 <= in_reg;
			3'd7: ad_dat6 <= in_reg;
		endcase


endmodule