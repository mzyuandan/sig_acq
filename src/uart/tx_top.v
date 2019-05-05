//--------------------------------------------------------------------------------------------------
//
// Title		: tx_top
// Design		: sig_acq
// Author		: mz
// Company		: xkf
// Date			: 2019.5.5
// Description	: Top level of TX
//
//--------------------------------------------------------------------------------------------------

module tx_top (
	clk,
	rst,
	ena,
	
	wclk,
	tx_fifo_wen,
	tx_fifo_wdata,
	tx_fifo_empty,
	tx_fifo_full,
	tx_fifo_usedw,
	
	txd,
	tx_work
	);
	
input clk;
input rst;
input ena;

input wclk;
input tx_fifo_wen;
input [7:0] tx_fifo_wdata;
output wire tx_fifo_empty;
output wire tx_fifo_full;
output wire [4:0] tx_fifo_usedw;

output wire txd;
output wire tx_work;

wire tx_fifo_rempty;
reg tx_fifo_rempty_r;
reg tx_fifo_empt_fall;
reg tx_fifo_ren_burst;
wire [7:0] tx_fifo_rdata;
reg tx_ld;
wire tx_fifo_ren_auto;
wire tx_fifo_ren;

assign tx_fifo_ren = tx_fifo_ren_auto | tx_fifo_ren_burst;

always @(posedge clk or negedge rst)
	if (!rst)
		tx_fifo_rempty_r <= 1'b0;
	else
		tx_fifo_rempty_r <= tx_fifo_rempty;
		
always @(posedge clk or negedge rst)
	if (!rst)
		tx_fifo_empt_fall <= 1'b0;
	else
		if (!tx_fifo_rempty && tx_fifo_rempty_r)
			tx_fifo_empt_fall <= 1'b1;
	else if ((tx_fifo_rempty && !tx_fifo_rempty_r) || tx_fifo_ren_burst)
		tx_fifo_empt_fall <= 1'b0;
		
always @(posedge clk or negedge rst)
	if (!rst)
		tx_fifo_ren_burst <= 1'b0;
	else
		if (ena && !tx_work && tx_fifo_empt_fall)
			tx_fifo_ren_burst <= 1'b1;
	else
		tx_fifo_ren_burst <= 1'b0;
		
always @(posedge clk or negedge rst)
	if (!rst)
		tx_ld <= 1'b0;
	else
		tx_ld <= tx_fifo_ren;
			

tx_sft tx_sft (
	.clk(clk),
	.rst(rst),
	.ena(ena),
	
	.tx_fifo_rempty(tx_fifo_rempty),
	.tx_fifo_rempty_r(tx_fifo_rempty_r),
	.act_p(tx_fifo_ren),		
	.act(tx_ld),
	.data(tx_fifo_rdata),
	
	.txd(txd),
	.work(tx_work),
	.tx_fifo_ren(tx_fifo_ren_auto)
	);
	
uart_fifo tx_fifo (
	.aclr(~rst),
	.data(tx_fifo_wdata),
	.rdclk(clk),
	.rdreq(tx_fifo_ren),
	.wrclk(wclk),
	.wrreq(tx_fifo_wen),
	.q(tx_fifo_rdata),
	.rdempty(tx_fifo_rempty),
	.wrfull(tx_fifo_full),
	.wrempty(tx_fifo_empty),
	.wrusedw(tx_fifo_usedw)
	);

	
endmodule