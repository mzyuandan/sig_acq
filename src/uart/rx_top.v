//--------------------------------------------------------------------------------------------------
//
// Title		: rx_top
// Design		: sig_acq
// Author		: mz
// Company		: xkf
// Date			: 2019.5.5
// Description	: Top level of RX
//
//--------------------------------------------------------------------------------------------------

module rx_top (
	clk,
	rst,
	ena,
	
	rxd,
	
	rclk,
	rx_fifo_ren,
	rx_fifo_rdata,
	rx_fifo_empty,
	rx_fifo_full,
	rx_fifo_usedw,
	
	rx_overflow
	
	//debug
//	val_r
//	rx_err
	);
	
input clk;
input rst;
input ena;

input rxd;

input rclk;
input rx_fifo_ren;
output wire [7:0] rx_fifo_rdata;
output wire rx_fifo_empty;
output wire rx_fifo_full;
output wire [11:0] rx_fifo_usedw;

output reg rx_overflow;

wire val;
wire [7:0] data;
wire no_stop;

wire rx_fifo_wfull;
reg rx_fifo_wen;
reg rx_data_nw;
reg [7:0] rx_fifo_wdata;

reg rx_fifo_wfull_r;

always @(posedge clk or negedge rst)
	if (!rst)
		rx_fifo_wfull_r <= 1'b0;
	else
		rx_fifo_wfull_r <= rx_fifo_wfull;

always @(posedge clk or negedge rst)
	if (!rst)
		rx_overflow <= 1'b0;
	else
		if (!rx_fifo_wfull && rx_fifo_wfull_r)
			rx_overflow <= 1'b0;
	else 
		if (val && rx_data_nw)
			rx_overflow <= 1'b1;
			
always @(posedge clk or negedge rst)
	if (!rst)
		rx_fifo_wen <= 1'b0;
	else
		if (rx_data_nw && !rx_fifo_wfull && rx_fifo_wfull_r)
		rx_fifo_wen <= 1'b1;
	else
		if (!rx_fifo_wfull)
		rx_fifo_wen <= val;
	
		
always @(posedge clk or negedge rst)
	if (!rst)
		rx_data_nw <= 1'b0;
	else
		if (val && rx_fifo_wfull && !rx_overflow)
		rx_data_nw <= 1'b1;
	else
		if (rx_data_nw && (val || rx_fifo_wen))
		rx_data_nw <= 1'b0;
			
always @(posedge clk or negedge rst)
	if (!rst)
		rx_fifo_wdata <= 8'd0;
	else
		if (val)
			rx_fifo_wdata <= data;
		
rx_sft rx_sft (
	.clk(clk),
	.rst(rst),
	.ena(ena),
	
	.rxd(rxd),
	
	.val(val),
	.data(data),
	.no_stop(no_stop)
	);
	
//assign rx_fifo_wen = ~rx_fifo_wfull & val;
//assign rx_fifo_wdata = data;

uart_fifo rx_fifo (	
	.aclr(~rst),
	.data(rx_fifo_wdata),
	.rdclk(rclk),
	.rdreq(rx_fifo_ren),
	.wrclk(clk),
	.wrreq(rx_fifo_wen),
	.q(rx_fifo_rdata),
	.rdempty(rx_fifo_empty),
	.rdfull(rx_fifo_full),
	.rdusedw(rx_fifo_usedw),
	.wrfull(rx_fifo_wfull)
	);
	
	
//debug
//reg [7:0] rx_cnt;
//output reg rx_err;
//always @(posedge clk or negedge rst)
//	if (!rst)
//		rx_cnt <= 8'd0;
//	else 
//		if (rx_fifo_wen)
//			rx_cnt <= rx_cnt + 1'd1;
//
//always @(posedge clk or negedge rst)
//	if (!rst)
//		rx_err <= 1'b0;
//	else 
//		if (rx_fifo_wen && rx_fifo_wdata!=rx_cnt)
//			rx_err <= 1'b1;


//output reg [1:0] val_r;
//always @(posedge rclk or negedge rst)
//	if (!rst)
//		val_r <= 2'd0;
//	else
//			val_r <= {val_r[0], val};

	
endmodule