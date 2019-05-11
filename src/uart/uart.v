//--------------------------------------------------------------------------------------------------
//
// Title		: uart
// Design		: sig_acq
// Author		: mz
// Company		: xkf
// Date			: 2019.5.5
// Description	: Top level of UART
//
//--------------------------------------------------------------------------------------------------

module uart (
	clk,
	clk_h,
	rst,
	//y_uart,
	
	latch_baud,
	baud_word,	
	
	self_loop,
	
	rxd,
	txd,
	
	tx_fifo_wen,
	tx_fifo_wdata,
	tx_fifo_empty,
	tx_fifo_full,
	tx_fifo_usedw,
	
	rx_fifo_ren,
	rx_fifo_rdata,
	rx_fifo_empty,
	rx_fifo_full,
	rx_fifo_usedw,
	
	tx_work,
	rx_overflow
	
	//debug
//	rx_err
	);
	
input clk;
input clk_h;
input rst;

input latch_baud;
input [15:0] baud_word;

input self_loop;

input rxd;
output wire txd;

input tx_fifo_wen;
input [7:0] tx_fifo_wdata;
output wire tx_fifo_empty;
output wire tx_fifo_full;
output wire [11:0] tx_fifo_usedw;

input rx_fifo_ren;
output wire [7:0] rx_fifo_rdata;
output wire rx_fifo_empty;
output wire rx_fifo_full;
output wire [11:0] rx_fifo_usedw;

output wire tx_work;
output wire rx_overflow;

//debug
//output wire rx_err;

wire ena;
wire ena_p1;
wire ena_p2;
wire ena_p3;
wire ena_p4;
wire rxd_rel;

	
baud_gen baud_gen (
	.clk(clk),
	.rst(rst),
	
	.latch(latch_baud),
	.baud_word(baud_word),	
	
	.ena(ena)
	);
	
//debug
//wire [1:0] val_r;
assign  rxd_rel = self_loop ? txd : rxd;
////////////////////////////////////////////////////////////
rx_top rx_top (
	.clk(clk),
	.rst(rst),
	.ena(ena),
	
	.rxd(rxd_rel),
	
	.rclk(clk_h),
	.rx_fifo_ren(rx_fifo_ren),
	.rx_fifo_rdata(rx_fifo_rdata),
	.rx_fifo_empty(rx_fifo_empty),
	.rx_fifo_full(rx_fifo_full),
	.rx_fifo_usedw(rx_fifo_usedw),
	
	.rx_overflow(rx_overflow)
	
	//debug
//	.val_r(val_r)
//	.rx_err(rx_err)
	);


tx_top tx_top (
	.clk(clk),
	.rst(rst),
	.ena(ena),
	
	.wclk(clk_h),
	.tx_fifo_wen(tx_fifo_wen),
	.tx_fifo_wdata(tx_fifo_wdata),
	.tx_fifo_empty(tx_fifo_empty),
	.tx_fifo_full(tx_fifo_full),
	.tx_fifo_usedw(tx_fifo_usedw),
	
	.txd(txd),
	.tx_work(tx_work)
	);

endmodule