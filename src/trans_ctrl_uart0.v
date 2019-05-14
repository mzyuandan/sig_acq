//--------------------------------------------------------------------------------------------------
//
// Title		: trans_ctrl_uart0
// Design		: sig_acq
// Author		: mz
// Company		: xkf
// Date			: 2019.5.11
// Description	: Transmittion contrl of UART0 
//
//-------------------------------------------------------------------------------------------------


module trans_ctrl_uart0(
	clk,
	clk_l,
	rst,
	ena,
	
	init_adc,
	
	cs_l0,
	int_l0,
	sclk0,
	fs0,
	sdo0,
	sdi0,
	cstart0,
	
	cs_l1,
	int_l1,
	sclk1,
	fs1,
	sdo1,
	sdi1,
	cstart1,
	
	digital0,
	digital1,
	
	count,
	pulse_full,
	pulse_10ms,
	cnt_10ms,
	
	tx_fifo_wen, 
	tx_fifo_wdata, 
	tx_fifo_full, 
	tx_fifo_usedw
	);

parameter VERSION = 16'd0;
parameter NUM_ANALOG = 14;
parameter NUM_DIGITAL = 2;
parameter NUM_SIGNAL = 16;
parameter NUM_WORD_M1 = 17;
parameter HEAD = 32'h7FFF7FFF;
	
input clk;
input clk_l;
input rst;
input ena;

input init_adc;

output cs_l0;
input int_l0;
output sclk0;
output fs0;
output sdo0;
input sdi0;
output cstart0;

output cs_l1;
input int_l1;
output sclk1;
output fs1;
output sdo1;
input sdi1;
output cstart1;

input digital0;
input digital1;

input [31:0] count;
input pulse_full;
input pulse_10ms;
input [15:0] cnt_10ms;

output reg tx_fifo_wen; 
output reg [7:0] tx_fifo_wdata; 
input tx_fifo_full; 
input [11:0] tx_fifo_usedw;

reg st_adc;
reg st_adc_p;
reg st_adc_pr;
reg [10:0] cnt_st;

wire val_dat0;
wire [13:0] ad_dat00;
wire [13:0] ad_dat01;
wire [13:0] ad_dat02;
wire [13:0] ad_dat03;
wire [13:0] ad_dat04;
wire [13:0] ad_dat05;
wire [13:0] ad_dat06;
wire [13:0] ad_dat07;

wire val_dat1;
wire [13:0] ad_dat10;
wire [13:0] ad_dat11;
wire [13:0] ad_dat12;
wire [13:0] ad_dat13;
wire [13:0] ad_dat14;
wire [13:0] ad_dat15;
wire [13:0] ad_dat16;
wire [13:0] ad_dat17;

reg val_dat;
reg val_dat_r;

reg trans;
reg [1:0] cnt_byte;
reg [4:0] cnt_byteX4;
wire [4:0] cnt_signal;
reg tx_fifo_wen_p;
wire [6:0] state;

wire [15:0] version_l;
wire [31:0] head_l;
wire [15:0] num_analog_l;
wire [15:0] num_digital_l;
wire [15:0] num_signal_l;
//wire [4:0] num_pulse_m1;

assign version_l = VERSION;
assign head_l = HEAD;
assign num_analog_l = NUM_ANALOG;
assign num_digital_l = NUM_DIGITAL;
assign num_signal_l = NUM_SIGNAL;
//assign num_pulse_m1 = NUM_PULSE - 1'd1;

always @(posedge clk or negedge rst)
	if (!rst)
		st_adc_p <= 1'b0;
	else if (ena && pulse_10ms)
		st_adc_p <= 1'b1;
	else if (ena && cnt_st==11'd2047)
		st_adc_p <= 1'b0;
		
always @(posedge clk_l)
	st_adc_pr <= st_adc_p;
		
always @(posedge clk or negedge rst)
	if (!rst)
		cnt_st <= 11'd0;
	else if (ena && pulse_10ms)
		cnt_st <= 11'd0;
	else if (st_adc_p)
		cnt_st <= cnt_st + 1'd1;
		
always @(posedge clk_l)
	if (!rst)
		st_adc <= 1'b0;
	else if (st_adc_p && !st_adc_pr)
		st_adc <= 1'b1;
	else
		st_adc <= 1'b0;

ad_interface ad_interface0(
	.clk(clk_l),
	.rst(rst),

	.init_adc(init_adc),
	.st_adc(st_adc),

	.cs_l(cs_l0),
	.int_l(int_l0),
	.sclk(sclk0),
	.fs(fs0),
	.sdo(sdo0),
	.sdi(sdi0),
	.cstart(cstart0),
	
	.val_dat(val_dat0),
	.ad_dat0(ad_dat00),
	.ad_dat1(ad_dat01),
	.ad_dat2(ad_dat02),
	.ad_dat3(ad_dat03),
	.ad_dat4(ad_dat04),
	.ad_dat5(ad_dat05),
	.ad_dat6(ad_dat06),
	.ad_dat7(ad_dat07)	
	);
	
ad_interface ad_interface1(
	.clk(clk_l),
	.rst(rst),

	.init_adc(init_adc),
	.st_adc(st_adc),

	.cs_l(cs_l1),
	.int_l(int_l1),
	.sclk(sclk1),
	.fs(fs1),
	.sdo(sdo1),
	.sdi(sdi1),
	.cstart(cstart1),
	
	.val_dat(val_dat1),
	.ad_dat0(ad_dat10),
	.ad_dat1(ad_dat11),
	.ad_dat2(ad_dat12),
	.ad_dat3(ad_dat13),
	.ad_dat4(ad_dat14),
	.ad_dat5(ad_dat15),
	.ad_dat6(ad_dat16),
	.ad_dat7(ad_dat17)	
	);
	
always @(posedge clk)
		val_dat <= val_dat0 && val_dat1;
		
always @(posedge clk)
		val_dat_r <= val_dat;

always @(posedge clk or negedge rst)
	if (!rst)
		trans <= 1'b0;
	else if (ena && val_dat && !val_dat_r)
		trans <= 1'b1;
	else if (cnt_byte==2'd3 && cnt_byteX4==NUM_WORD_M1)
		trans <= 1'b0;

always @(posedge clk or negedge rst)
	if (!rst)
		cnt_byte <= 2'd0;
	else if (val_dat && !val_dat_r)
		cnt_byte <= 2'd0;
	else if (tx_fifo_wen_p)
		cnt_byte <= cnt_byte + 1'd1;
		
always @(posedge clk or negedge rst)
	if (!rst)
		cnt_byteX4 <= 5'd0;
	else if (val_dat && !val_dat_r)
		cnt_byteX4 <= 5'd0;
	else if (tx_fifo_wen_p && cnt_byte==2'b11)
		cnt_byteX4 <= cnt_byteX4 + 1'd1;
		
always @(posedge clk or negedge rst)
	if (!rst)
		tx_fifo_wen_p <= 1'b0;
	else if ((cnt_byte==2'd3 && cnt_byteX4==NUM_WORD_M1) || (tx_fifo_usedw==12'd2000))
		tx_fifo_wen_p <= 1'b0;
	else if (trans && tx_fifo_usedw<12'd2000)
		tx_fifo_wen_p <= 1'b1;
	
		
always @(posedge clk)
	tx_fifo_wen <= tx_fifo_wen_p;
	
assign cnt_signal = cnt_byteX4 - 2'd2;
		
assign state = {cnt_byteX4, cnt_byte};

always @(posedge clk or negedge rst)
	if (!rst)
		tx_fifo_wdata <= 8'd0;
	else if (tx_fifo_wen_p)
		case (state)
			7'b0000000 : tx_fifo_wdata <= head_l[7:0];
			7'b0000001 : tx_fifo_wdata <= head_l[15:8];
			7'b0000010 : tx_fifo_wdata <= head_l[23:16];
			7'b0000011 : tx_fifo_wdata <= head_l[31:24];
			
			7'b0000100 : tx_fifo_wdata <= version_l[7:0];
			7'b0000101 : tx_fifo_wdata <= version_l[15:8];
			7'b0000110 : tx_fifo_wdata <= num_signal_l[7:0];
			7'b0000111 : tx_fifo_wdata <= num_signal_l[15:8];
			
			7'b0001000 : tx_fifo_wdata <= {3'd0, cnt_signal};
			7'b0001001 : tx_fifo_wdata <= 8'h33;
			7'b0001010 : tx_fifo_wdata <= {7'd0, digital0};
			7'b0001011 : tx_fifo_wdata <= 8'd0;
			
			7'b0001100 : tx_fifo_wdata <= {3'd0, cnt_signal};
			7'b0001101 : tx_fifo_wdata <= 8'h33;
			7'b0001110 : tx_fifo_wdata <= {7'd0, digital1};
			7'b0001111 : tx_fifo_wdata <= 8'd0;
			
			7'b0010000 : tx_fifo_wdata <= {3'd0, cnt_signal};
			7'b0010001 : tx_fifo_wdata <= 8'hCC;
			7'b0010010 : tx_fifo_wdata <= ad_dat02[7:0];
			7'b0010011 : tx_fifo_wdata <= {2'd0, ad_dat02[13:8]};
			
			7'b0010100 : tx_fifo_wdata <= {3'd0, cnt_signal};
			7'b0010101 : tx_fifo_wdata <= 8'hCC;
			7'b0010110 : tx_fifo_wdata <= ad_dat03[7:0];
			7'b0010111 : tx_fifo_wdata <= {2'd0, ad_dat03[13:8]};
			
			7'b0011000 : tx_fifo_wdata <= {3'd0, cnt_signal};
			7'b0011001 : tx_fifo_wdata <= 8'hCC;
			7'b0011010 : tx_fifo_wdata <= ad_dat04[7:0];
			7'b0011011 : tx_fifo_wdata <= {2'd0, ad_dat04[13:8]};
			
			7'b0011100 : tx_fifo_wdata <= {3'd0, cnt_signal};
			7'b0011101 : tx_fifo_wdata <= 8'hCC;
			7'b0011110 : tx_fifo_wdata <= ad_dat05[7:0];
			7'b0011111 : tx_fifo_wdata <= {2'd0, ad_dat05[13:8]};
			
			7'b0100000 : tx_fifo_wdata <= {3'd0, cnt_signal};
			7'b0100001 : tx_fifo_wdata <= 8'hCC;
			7'b0100010 : tx_fifo_wdata <= ad_dat06[7:0];
			7'b0100011 : tx_fifo_wdata <= {2'd0, ad_dat06[13:8]};
			
			7'b0100100 : tx_fifo_wdata <= {3'd0, cnt_signal};
			7'b0100101 : tx_fifo_wdata <= 8'hCC;
			7'b0100110 : tx_fifo_wdata <= ad_dat07[7:0];
			7'b0100111 : tx_fifo_wdata <= {2'd0, ad_dat07[13:8]};
			
			7'b0101000 : tx_fifo_wdata <= {3'd0, cnt_signal};
			7'b0101001 : tx_fifo_wdata <= 8'hCC;
			7'b0101010 : tx_fifo_wdata <= ad_dat10[7:0];
			7'b0101011 : tx_fifo_wdata <= {2'd0, ad_dat10[13:8]};
			
			7'b0101100 : tx_fifo_wdata <= {3'd0, cnt_signal};
			7'b0101101 : tx_fifo_wdata <= 8'hCC;
			7'b0101110 : tx_fifo_wdata <= ad_dat11[7:0];
			7'b0101111 : tx_fifo_wdata <= {2'd0, ad_dat11[13:8]};
			
			7'b0110000 : tx_fifo_wdata <= {3'd0, cnt_signal};
			7'b0110001 : tx_fifo_wdata <= 8'hCC;
			7'b0110010 : tx_fifo_wdata <= ad_dat12[7:0];
			7'b0110011 : tx_fifo_wdata <= {2'd0, ad_dat12[13:8]};
			
			7'b0110100 : tx_fifo_wdata <= {3'd0, cnt_signal};
			7'b0110101 : tx_fifo_wdata <= 8'hCC;
			7'b0110110 : tx_fifo_wdata <= ad_dat13[7:0];
			7'b0110111 : tx_fifo_wdata <= {2'd0, ad_dat13[13:8]};
			
			7'b0111000 : tx_fifo_wdata <= {3'd0, cnt_signal};
			7'b0111001 : tx_fifo_wdata <= 8'hCC;
			7'b0111010 : tx_fifo_wdata <= ad_dat17[7:0];
			7'b0111011 : tx_fifo_wdata <= {2'd0, ad_dat17[13:8]};
			
			7'b0111100 : tx_fifo_wdata <= {3'd0, cnt_signal};     
			7'b0111101 : tx_fifo_wdata <= 8'hCC;     
			7'b0111110 : tx_fifo_wdata <= ad_dat14[7:0];     
			7'b0111111 : tx_fifo_wdata <= {2'd0, ad_dat14[13:8]};     
			
			7'b1000000 : tx_fifo_wdata <= {3'd0, cnt_signal};
			7'b1000001 : tx_fifo_wdata <= 8'hCC;
			7'b1000010 : tx_fifo_wdata <= ad_dat15[7:0];
			7'b1000011 : tx_fifo_wdata <= {2'd0, ad_dat15[13:8]};
			
			7'b1000100 : tx_fifo_wdata <= {3'd0, cnt_signal};
			7'b1000101 : tx_fifo_wdata <= 8'hCC;
			7'b1000110 : tx_fifo_wdata <= ad_dat16[7:0];
			7'b1000111 : tx_fifo_wdata <= {2'd0, ad_dat16[13:8]};
			
			default	   : tx_fifo_wdata <= 8'd0;
		endcase



endmodule
