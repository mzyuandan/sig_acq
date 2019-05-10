//--------------------------------------------------------------------------------------------------
//
// Title		: work_ctrl
// Design		: sig_acq
// Author		: mz
// Company		: xkf
// Date			: 2019.5.5
// Description	: Contrl the working fllow of signal acqusition
//
//-------------------------------------------------------------------------------------------------

`timescale 1 ns/ 1 ps

module work_ctrl(
	clk,
	rst,

	latch_baud0, 
	baud_word0, 
	self_loop0, 
	tx_fifo_wen0, 
	tx_fifo_wdata0, 
	tx_fifo_empty0, 
	tx_fifo_full0, 
	tx_fifo_usedw0, 
	rx_fifo_ren0, 
	rx_fifo_rdata0, 
	rx_fifo_empty0, 
	rx_fifo_full0, 
	rx_fifo_usedw0, 
	tx_work0, 
	rx_overflow0, 

	latch_baud1, 
	baud_word1, 
	self_loop1, 
	tx_fifo_wen1, 
	tx_fifo_wdata1, 
	tx_fifo_empty1, 
	tx_fifo_full1, 
	tx_fifo_usedw1, 
	rx_fifo_ren1, 
	rx_fifo_rdata1, 
	rx_fifo_empty1, 
	rx_fifo_full1, 
	rx_fifo_usedw1, 
	tx_work1, 
	rx_overflow1	
	);


input clk;
input rst;


output latch_baud0;
output [15:0] baud_word0;
output self_loop0;
output tx_fifo_wen0;
output [7:0] tx_fifo_wdata0;
input tx_fifo_empty0;
input tx_fifo_full0;
input [4:0] tx_fifo_usedw0;
output rx_fifo_ren0;
input [7:0] rx_fifo_rdata0;
input rx_fifo_empty0;
input rx_fifo_full0;
input [4:0] rx_fifo_usedw0;
input tx_work0;
input rx_overflow0;

output latch_baud1;
output [15:0] baud_word1;
output self_loop1;
output tx_fifo_wen1;
output [7:0] tx_fifo_wdata1;
input tx_fifo_empty1;
input tx_fifo_full1;
input [4:0] tx_fifo_usedw1;
output rx_fifo_ren1;
input [7:0] rx_fifo_rdata1;
input rx_fifo_empty1;
input rx_fifo_full1;
input [4:0] rx_fifo_usedw1;
input tx_work1;
input rx_overflow1;




endmodule
