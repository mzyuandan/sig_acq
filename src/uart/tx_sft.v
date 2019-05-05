//--------------------------------------------------------------------------------------------------
//
// Title		: tx_sft
// Design		: sig_acq
// Author		: mz
// Company		: xkf
// Date			: 2019.5.5
// Description	: Shift register for TX
//
//--------------------------------------------------------------------------------------------------

module tx_sft (
	clk,
	rst,
	ena,
	
	tx_fifo_rempty,
	tx_fifo_rempty_r,
	act_p,
	act,
	data,
	
	txd,
	work,
	tx_fifo_ren
	);
	
input clk;
input rst;
input ena;
input tx_fifo_rempty;
input tx_fifo_rempty_r;
input act_p;
input act;
input [7:0] data;
output wire txd;
output reg work;
output reg tx_fifo_ren;

reg [7:0] cnt;
reg [7:0] data_r;
reg [9:0] data_sft;
reg data_val;
reg tx_fifo_nr;


always @(posedge clk or negedge rst)
	if (!rst)
		data_r <= 8'd0;
	else 
		if (act)
			data_r <= data;
		
always @(posedge clk or negedge rst)
	if (!rst)
		data_val <= 1'b0;
	else 
		if (act)
			data_val <= 1'b1;
	else 
		if (ena && data_val && (cnt==8'd159 || !work))
			data_val <= 1'b0;
			
always @(posedge clk or negedge rst)
	if (!rst)
		work <= 1'b0;
	else 
		if (ena && data_val && (cnt==8'd159 || !work))
			work <= 1'b1;
	else
		if (ena && !data_val && cnt==8'd159)
			work <= 1'b0;
			
always @(posedge clk or negedge rst)
	if (!rst)
		cnt <= 8'd0;
	else 
		if (ena && act && !work)
			cnt <= 8'd0;
	else
		if (ena && cnt==8'd159)
		cnt <= 8'd0;
	else
		if (ena && work)
			cnt <= cnt + 1'd1;
	
always @(posedge clk or negedge rst)
	if (!rst)
		tx_fifo_nr <= 1'b0;
	else 
		if (ena && tx_fifo_rempty && data_val && (cnt==8'd159 || !work))
			tx_fifo_nr <= 1'b1;
	else 
		if (ena && !tx_fifo_rempty && data_val && (cnt==8'd159 || !work))
			tx_fifo_nr <= 1'b0;
	
			
always @(posedge clk or negedge rst)
	if (!rst)
		tx_fifo_ren <= 1'b0;
	else 
		if (ena && !tx_fifo_rempty && data_val && (cnt==8'd159 || !work))
			tx_fifo_ren <= 1'b1;
	else
		if (work && !data_val && tx_fifo_nr && !tx_fifo_rempty && tx_fifo_rempty_r)
			tx_fifo_ren <= 1'b1;
	else
		tx_fifo_ren <= 1'b0;
		
always @(posedge clk or negedge rst)
	if (!rst)
		data_sft <= 10'h3ff;
	else 
		if (ena && data_val && (cnt==8'd159 || !work))
			data_sft <= {1'b1, data_r, 1'b0};
	else
		if (ena && work && cnt[3:0]==4'hf)
			data_sft <= {1'b1, data_sft[9:1]};
			
assign txd = data_sft[0];
	
endmodule