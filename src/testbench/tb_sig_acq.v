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
//`define PERIOD 5
`define PERIOD 4.5
`define SD 0.1    // synchronous delay, eg. flip flop
`define AD 0.2    // asynchronous delay, eg. combinational logic
`define SEEK_SET 0
`define SEEK_CUR 1
`define SEEK_END 2

module tb_sig_acq();
	
reg clk_in;
reg rst_board;

wire wdi;
	
wire [2:0] led;
	
wire txd0;
reg rxd0;
wire txd1;
reg rxd1;
	
wire cs0;
wire int0;
wire slck0;
wire fs0;
wire sdo0;
reg sdi0;
wire cstart0;
	
wire cs1;
wire int1;
wire slck1;
wire fs1;
wire sdo1;
reg sdi1;
wire cstart1;

wire cs2;
wire int2;
wire slck2;
wire fs2;
wire sdo2;
reg sdi2;
wire cstart2;
	
reg x9b51_st;
reg x9b57_tr;
reg x9b54_tp;
reg x9b63_fsdp;
reg x9b60_agc;
reg x10b1_lmt;
reg x10b4_fht;
reg x10b7_mdp;
reg x10b10_prf;
reg x10b13_frm;
reg x10b16_sdp;
reg x10b19_rdw;
reg x10b34_sd;
reg rad_pwr_on;
	
reg [7:0] bk_din;
reg [7:0] bk_v28_d;
	
wire clk_arm;
wire rst_arm;
wire ssi0_clk;
wire ssi0_fss;
wire ssi0_xdat0;
wire ssi0_xdat1;
wire ssi0_xdat2;
wire ssi0_xdat3;

wire [31:0] count;

integer fp_r;
integer fp_w;


initial 
begin
	
/* 	fp_r = $fopen("din.txt", "r");	
	if (!fp_r)
	begin
		$display("could not open \"din_txt\"");
		$stop;
	end
	
	//fp_w = $fopen("dout_xx.txt", "w");	
	fp_w = $fopen("dout.txt", "w");	
	if (!fp_w)
	begin
		$display("could not open \"dout_txt\"");
		$stop;
	end */
	
	clk_in = 1'b0;
	rst_board = 1'b1;
	rxd0 = 1'b0;
	rxd1 = 1'b0;
	sdi0 = 1'b0;
	sdi1 = 1'b0;
	sdi2 = 1'b0;
	x9b51_st = 1'b0;
	// x9b57_tr = 1'b0;
	// x9b54_tp = 1'b0;
	x9b63_fsdp = 1'b0;
	x9b60_agc = 1'b0;
	x10b1_lmt = 1'b0;
	x10b4_fht = 1'b0;
	x10b7_mdp = 1'b0;
	x10b10_prf = 1'b0;
	x10b13_frm = 1'b0;
	x10b16_sdp = 1'b0;
	x10b19_rdw = 1'b0;
	x10b34_sd = 1'b0;
	rad_pwr_on = 1'b0;
	bk_din = 8'd0;
	bk_v28_d = 8'd0;

	//reset
	@(posedge clk_in);
	#`SD rst_board = 1'b0;
	repeat(100)
		@(posedge clk_in);
	#`SD rst_board = 1'b1;
	@(posedge clk_in);

	
	
	
	
	
	// repeat(1)
		// @(posedge eclk_in);

	// $fclose(fp_r);
	// $fclose(fp_w);
	// $stop;
end

always @(posedge clk_in or negedge rst_board)
	if (!rst_board)
		x9b57_tr <= 1'b0;
	else if (count[9:0]>=10'd100 && count[9:0]<10'd120)
		x9b57_tr <= 1'b1;
	else
		x9b57_tr <= 1'b0;
		
always @(posedge clk_in or negedge rst_board)
	if (!rst_board)
		x9b54_tp <= 1'b0;
	else if (count[10:0]>=11'd400 && count[10:0]<11'd500)
		x9b54_tp <= 1'b1;
	else
		x9b54_tp <= 1'b0;
		

// always @(posedge eclk_in)
	// if (load)
		// $fwrite(fp_w, "%d, %d, \n", data_r, data_i);

always #`PERIOD clk_in = ~clk_in;


//glbl glbl();

timer32 timer32_tb(
	.clk(clk_in),
	.rst(rst_board),

	.clr(1'b0),
	.ena(1'b1),
	
	.count(count),
	.pulse_full(pulse_full),
	.pulse_10ms(pulse_10ms)
	);	

sig_acq sig_acq(
	.clk_in(clk_in),
	.rst_in(rst_board),
	.wdi(wdi),
	
	.led(led),
	
	.txd0(txd0),
	.rxd0(rxd0),
	.txd1(txd1),
	.rxd1(rxd1),
	
	.cs0(cs0),
	.int0(int0),
	.slck0(slck0),
	.fs0(fs0),
	.sdo0(sdo0),
	.sdi0(sdi0),
	.cstart0(cstart0),
	
	.cs1(cs1),
	.int1(int1),
	.slck1(slck1),
	.fs1(fs1),
	.sdo1(sdo1),
	.sdi1(sdi1),
	.cstart1(cstart1),
	
	.cs2(cs2),
	.int2(int2),
	.slck2(slck2),
	.fs2(fs2),
	.sdo2(sdo2),
	.sdi2(sdi2),
	.cstart2(cstart2),
	
	.x9b51_st(x9b51_st),
	.x9b57_tr(x9b57_tr),
	.x9b54_tp(x9b54_tp),
	.x9b63_fsdp(x9b63_fsdp),
	.x9b60_agc(x9b60_agc),
	.x10b1_lmt(x10b1_lmt),
	.x10b4_fht(x10b4_fht),
	.x10b7_mdp(x10b7_mdp),
	.x10b10_prf(x10b10_prf),
	.x10b13_frm(x10b13_frm),
	.x10b16_sdp(x10b16_sdp),
	.x10b19_rdw(x10b19_rdw),
	.x10b34_sd(x10b34_sd),
	.rad_pwr_on(rad_pwr_on),
	
	.bk_din(bk_din),
	.bk_v28_d(bk_v28_d),
	
	.clk_arm(clk_arm),
	.rst_arm(rst_arm),
	.ssi0_clk(ssi0_clk),
	.ssi0_fss(ssi0_fss),
	.ssi0_xdat0(ssi0_xdat0),
	.ssi0_xdat1(ssi0_xdat1),
	.ssi0_xdat2(ssi0_xdat2),
	.ssi0_xdat3(ssi0_xdat3)
	);



endmodule

	
	
	
