//--------------------------------------------------------------------------------------------------
//
// Title		: rx_sft
// Design		: sig_acq
// Author		: mz
// Company		: xkf
// Date			: 2019.5.5
// Description	: Shift register for RX
//
//--------------------------------------------------------------------------------------------------

module rx_sft (
	clk,
	rst,
	ena,
	
	rxd,
	
	val,
	data,
	no_stop
	);
	
input clk;
input rst;
input ena;
input rxd;
output reg val;
output reg [7:0] data;
output reg no_stop;

reg rxd_r;
reg rxds_p;
reg rxds;
reg rxds_r;
reg start_hf;
reg [3:0] cnt_smp;
reg work;
reg [3:0] cnt_bit;
reg st_dec;

parameter POS = 4'd8;
parameter BIT_NUM_ALL = 4'd9;

always @(posedge clk or negedge rst)
	if (!rst)
		rxd_r <= 1'b0;
	else 
			rxd_r <= rxd;

always @(posedge clk or negedge rst)
	if (!rst)
		rxds_p <= 1'b0;
	else 
			rxds_p <= rxd_r;
			
always @(posedge clk or negedge rst)
	if (!rst)
		rxds <= 1'b0;
	else 
		if (ena)
			rxds <= rxds_p;
			
always @(posedge clk or negedge rst)
	if (!rst)
		rxds_r <= 1'b0;
	else 
		if (ena)
			rxds_r <= rxds;
			
always @(posedge clk or negedge rst)
	if (!rst)
		start_hf <= 1'b0;
//	else
//		if (ena && cnt_smp==POS && start_hf)
//		start_hf <= 1'b0;
	else 
		if (ena && !rxds && rxds_r && !start_hf && st_dec)
			start_hf <= 1'b1;
	else
		if (ena && cnt_smp==POS && start_hf && rxds==1'b0)
			start_hf <= 1'b0;
		
always @(posedge clk or negedge rst)
	if (!rst)
		cnt_smp <= 4'd0;
	else 
		if (ena && !rxds && rxds_r && !start_hf && st_dec)
			cnt_smp <= 4'd15;
	else 
		if (ena && cnt_smp==4'd0)
			cnt_smp <= 4'd15;
	else
		if (ena && (start_hf ||work) )
			cnt_smp <= cnt_smp - 1'd1;
		
always @(posedge clk or negedge rst)
	if (!rst)
		work <= 1'b0;
	else
		if (ena && cnt_bit==BIT_NUM_ALL && cnt_smp==4'd0)
		work <= 1'b0;
	else 
		if (ena && cnt_smp==POS && start_hf && rxds==1'b0)
			work <= 1'b1;
			
always @(posedge clk or negedge rst)
	if (!rst)
		st_dec <= 1'b1;
	else
		if (ena && cnt_bit==BIT_NUM_ALL && cnt_smp==POS)
		st_dec <= 1'b1;
	else 
		if (ena && cnt_smp==POS && start_hf && rxds==1'b0)
			st_dec <= 1'b0;
			
always @(posedge clk or negedge rst)
	if (!rst)
		cnt_bit <= 4'd0;
	else
		if (start_hf)
			cnt_bit <= 4'd0;
	else
		if (ena && cnt_bit==BIT_NUM_ALL && cnt_smp==4'd0)
		cnt_bit <= 4'd0;
	else 
		if (ena && cnt_smp==4'd0 && work)
			cnt_bit <= cnt_bit + 1'd1;
			
always @(posedge clk or negedge rst)
	if (!rst)
		data <= 8'd0;
	else
		if (ena && cnt_bit!=BIT_NUM_ALL && cnt_bit!=4'd0 && cnt_smp==POS)
			data <= {rxds, data[7:1]};

always @(posedge clk or negedge rst)
	if (!rst)
		val <= 1'b0;
	else
		if (ena && cnt_bit==BIT_NUM_ALL && cnt_smp==POS && rxds)
			val <= 1'b1;
	else
		val <= 1'b0;
		
always @(posedge clk or negedge rst)
	if (!rst)
		no_stop <= 1'b0;
	else
		if (ena && rxds)
			no_stop <= 1'b0;
	else
		if (ena && cnt_bit==BIT_NUM_ALL && cnt_smp==POS && !rxds)
			no_stop <= 1'b1;		
	
	
endmodule