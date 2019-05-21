//--------------------------------------------------------------------------------------------------
//
// Title		: sig_acq
// Design		: sig_acq
// Author		: mz
// Company		: xkf
// Date			: 2019.5.5
// Description	: top level design of sig_acq
//
//-------------------------------------------------------------------------------------------------


module sig_acq(
	clk_in,
	rst_in,
	wdi,
	
	led,
	
	txd0,
	rxd0,
	txd1,
	rxd1,
	
	cs0,
	int0,
	sclk0,
	fs0,
	sdo0,
	sdi0,
	cstart0,
	
	cs1,
	int1,
	sclk1,
	fs1,
	sdo1,
	sdi1,
	cstart1,
	
	cs2,
	int2,
	sclk2,
	fs2,
	sdo2,
	sdi2,
	cstart2,
	
	x9b51_st,
	x9b57_tr,
	x9b54_tp,
	x9b63_fsdp,
	x9b60_agc,
	x10b1_lmt,
	x10b4_fht,
	x10b7_mdp,
	x10b10_prf,
	x10b13_frm,
	x10b16_sdp,
	x10b19_rdw,
	x10b34_sd,
	rad_pwr_on,
	
	bk_din,
	bk_v28_d,
	
	clk_arm,
	rst_arm,
	ssi0_clk,
	ssi0_fss,
	ssi0_xdat0,
	ssi0_xdat1,
	ssi0_xdat2,
	ssi0_xdat3
	);
	
parameter VERSION = 16'd0;	
parameter NUM_ANALOG = 14;
parameter NUM_DIGITAL = 2;
parameter NUM_PULSE = 12;


input clk_in;
input rst_in;
output wdi;	

output [2:0] led;

input rxd0;	
output txd0;
input rxd1;
output txd1;

output cs0;
input int0;
output sclk0;
output fs0;
output sdo0;
input  sdi0;
output cstart0;
	
output cs1;
input int1;
output sclk1;
output fs1;
output sdo1;
input  sdi1;
output cstart1;
	
output cs2;
input int2;
output sclk2;
output fs2;
output sdo2;
input  sdi2;
output cstart2;
	
input x9b51_st;
input x9b57_tr;
input x9b54_tp;
input x9b63_fsdp;
input x9b60_agc;
input x10b1_lmt;
input x10b4_fht;
input x10b7_mdp;
input x10b10_prf;
input x10b13_frm;
input x10b16_sdp;
input x10b19_rdw;
input x10b34_sd;
input rad_pwr_on;
	
input [7:0] bk_din;
input [7:0] bk_v28_d;

output clk_arm;
output rst_arm;
output ssi0_clk;
output ssi0_fss;
output ssi0_xdat0;
output ssi0_xdat1;
output ssi0_xdat2;
output ssi0_xdat3;

wire clk_110p592m;
wire clk_184p32k;
wire clk_14p7456m;
wire clk_25m;
wire locked;
wire clk;
wire clk_l;
wire clk_u;
wire rst;
wire init_done;
wire ena;

wire led_blnk;
wire x9b54_tp_test;
wire x9b57_tr_test;

wire [31:0] count;
wire pulse_full;
wire pulse_10ms;
wire [15:0] cnt_10ms;
wire pulse_1s;

wire init_adc;

wire latch_baud0;
wire [15:0] baud_word0;
//wire self_loop0;
wire tx_fifo_wen0;
wire [7:0] tx_fifo_wdata0;
//wire tx_fifo_empty0;
wire tx_fifo_full0;
wire [11:0] tx_fifo_usedw0;
//wire rx_fifo_full0;
//wire rx_fifo_empty0;
//wire [11:0] rx_fifo_usedw0;
//wire rx_fifo_ren0;
//wire [7:0] rx_fifo_rdata0;
//wire tx_work0;
//wire rx_overflow0;

wire latch_baud1;
wire [15:0] baud_word1;
//wire self_loop1;
wire tx_fifo_wen1;
wire [7:0] tx_fifo_wdata1;
//wire tx_fifo_empty1;
wire tx_fifo_full1;
wire [11:0] tx_fifo_usedw1;
//wire rx_fifo_full1;
//wire rx_fifo_empty1;
//wire [11:0] rx_fifo_usedw1;
//wire rx_fifo_ren1;
//wire [7:0] rx_fifo_rdata1;
//wire tx_work1;
//wire rx_overflow1;
	
assign clk_arm = clk_25m;
assign led = {x9b54_tp_test, x9b57_tr_test, led_blnk};

pll pll (
	.inclk0(clk_in),
	.c0(clk_110p592m),
	.c1(clk_184p32k),
	.c2(clk_14p7456m),
	.c3(clk_25m),
	.locked(locked)
	);
	
gsig_gen clk_gen (
	.ena(1'b1),
	.inclk(clk_110p592m),
	.outclk(clk)
	);
	
gsig_gen clk_l_gen (
	.ena(1'b1),
	.inclk(clk_184p32k),
	.outclk(clk_l)
	);
	
gsig_gen clk_u_gen (
	.ena(1'b1),
	.inclk(clk_14p7456m),
	.outclk(clk_u)
	);
	
gsig_gen rst_gen (
	.ena(1'b1),
	.inclk(rst_in),
	.outclk(rst)
	);
	
led_blink led_blink(
	.clk(clk_25m),
	.rst(rst),
	.led_out(led_blnk)
	);
	
led_blink wdi_gen(
	.clk(clk_25m),
	.rst(rst),
	.led_out(wdi)
	);
	
init_ctrl init_ctrl(
	.clk(clk),
	.clk_l(clk_l),
	.clk_u(clk_u),
	.rst(rst),
	.locked(locked),
	
	.latch_baud0(latch_baud0),
	.baud_word0(baud_word0), 
	.latch_baud1(latch_baud1),
	.baud_word1(baud_word1),
	
	.init_adc(init_adc),

	.done(ena)
	);
	
	
timer32 timer32(
	.clk(clk),
	.rst(rst),

	.clr(1'b0),
	.ena(ena),
	
	.count(count),
	.pulse_full(pulse_full),
	.pulse_10ms(pulse_10ms),
	.cnt_10ms(cnt_10ms),
	.pulse_1s(pulse_1s)
	);	
	
trans_ctrl_uart0 trans_ctrl_uart0(
	.clk(clk),
	.clk_l(clk_l),
	.rst(rst),
	.ena(ena),
	
	.init_adc(init_adc),
	
	.cs_l0(cs0),
	.int_l0(int0),
	.sclk0(sclk0),
	.fs0(fs0),
	.sdo0(sdo0),
	.sdi0(sdi0),
	.cstart0(cstart0),
	
	.cs_l1(cs1),
	.int_l1(int1),
	.sclk1(sclk1),
	.fs1(fs1),
	.sdo1(sdo1),
	.sdi1(sdi1),
	.cstart1(cstart1),
	
	.digital0(x9b60_agc),
	.digital1(rad_pwr_on),
	
	.count(count),
	.pulse_full(pulse_full),
	.pulse_10ms(pulse_10ms),
	.cnt_10ms(cnt_10ms),
	
	.tx_fifo_wen(tx_fifo_wen0), 
	.tx_fifo_wdata(tx_fifo_wdata0), 
	.tx_fifo_full(tx_fifo_full0), 
	.tx_fifo_usedw(tx_fifo_usedw0)
	);
	
trans_ctrl_uart1 #(
	.VERSION(VERSION),
	.NUM_PULSE(NUM_PULSE)
	) trans_ctrl_uart1(
	.clk(clk),
	.rst(rst),
	.ena(ena),
	.pulse_1s(pulse_1s),
	
	.pulse0(x9b51_st),
	.pulse1(x9b57_tr),
	.pulse2(x9b54_tp),
	.pulse3(x9b63_fsdp),
	.pulse4(x10b1_lmt),
	.pulse5(x10b4_fht),
	.pulse6(x10b7_mdp),
	.pulse7(x10b10_prf),
	.pulse8(x10b13_frm),
	.pulse9(x10b16_sdp),
	.pulse10(x10b19_rdw),
	.pulse11(x10b34_sd),
	
	.count(count),
	.pulse_full(pulse_full),
	.pulse_10ms(pulse_10ms),
	.cnt_10ms(cnt_10ms),
	
	.tx_fifo_wen(tx_fifo_wen1), 
	.tx_fifo_wdata(tx_fifo_wdata1), 
	.tx_fifo_full(tx_fifo_full1), 
	.tx_fifo_usedw(tx_fifo_usedw1)
	);


uart uart0 (
	.clk(clk_u),
	.clk_h(clk),
	.rst(rst),
	
	.latch_baud(latch_baud0),
	.baud_word(baud_word0),	
	
	.self_loop(1'b0),
	
	.rxd(rxd0),
	.txd(txd0),
	
	.tx_fifo_wen(tx_fifo_wen0),
	.tx_fifo_wdata(tx_fifo_wdata0),
	//.tx_fifo_empty(tx_fifo_empty0),
	.tx_fifo_full(tx_fifo_full0),
	.tx_fifo_usedw(tx_fifo_usedw0)
	
	//.rx_fifo_ren(rx_fifo_ren0),
	//.rx_fifo_rdata(rx_fifo_rdata0),
	//.rx_fifo_empty(rx_fifo_empty0),
	//.rx_fifo_full(rx_fifo_full0),
	//.rx_fifo_usedw(rx_fifo_usedw0),
	
	//.tx_work(tx_work0),
	//.rx_overflow(rx_overflow0)
	
//	.rx_err(rx_err0)
	);
	
uart uart1 (
	.clk(clk_u),
	.clk_h(clk),
	.rst(rst),
	
	.latch_baud(latch_baud1),
	.baud_word(baud_word1),	
	
	.self_loop(1'b0),
	
	.rxd(rxd1),
	.txd(txd1),
	
	.tx_fifo_wen(tx_fifo_wen1),
	.tx_fifo_wdata(tx_fifo_wdata1),
	//.tx_fifo_empty(tx_fifo_empty1),
	.tx_fifo_full(tx_fifo_full1),
	.tx_fifo_usedw(tx_fifo_usedw1)
	
	//.rx_fifo_ren(rx_fifo_ren1),
	//.rx_fifo_rdata(rx_fifo_rdata1),
	//.rx_fifo_empty(rx_fifo_empty1),
	//.rx_fifo_full(rx_fifo_full1),
	//.rx_fifo_usedw(rx_fifo_usedw1),
	
	//.tx_work(tx_work1),
	//.rx_overflow(rx_overflow1)
	
//	.rx_err(rx_err1)
	);
	
	
// Code beloww this is for test
pulse_gen pulse_gen(
	.clk(clk),
	.rst(rst),

	.clr(1'b0),
	.ena(1'b1),
	
	.pulse0(x9b57_tr_test),
	.pulse1(x9b54_tp_test)
	);


endmodule
