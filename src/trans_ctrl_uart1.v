//--------------------------------------------------------------------------------------------------
//
// Title		: trans_ctrl_uart1
// Design		: sig_acq
// Author		: mz
// Company		: xkf
// Date			: 2019.5.10
// Description	: Transmittion contrl of UART1 
//
//-------------------------------------------------------------------------------------------------


module trans_ctrl_uart1(
	clk,
	rst,
	ena,
	
	pulse0,
	pulse1,
	pulse2,
	pulse3,
	pulse4,
	pulse5,
	pulse6,
	pulse7,
	pulse8,
	pulse9,
	pulse10,
	pulse11,
	
	count,
	pulse_full,
	pulse_10ms,
	
	tx_fifo_wen, 
	tx_fifo_wdata, 
	tx_fifo_full, 
	tx_fifo_usedw
	);
	
parameter VERSION = 16'd0;
parameter NUM_PULSE = 12;
parameter HEAD = 32'h7FFF7FFF;
	
input clk;
input rst;
input ena;

input pulse0;
input pulse1;
input pulse2;
input pulse3;
input pulse4;
input pulse5;
input pulse6;
input pulse7;
input pulse8;
input pulse9;
input pulse10;
input pulse11;

input [31:0] count;
input pulse_full;
input pulse_10ms;

output reg tx_fifo_wen; 
output reg [7:0] tx_fifo_wdata; 
input tx_fifo_full; 
input [11:0] tx_fifo_usedw;

wire [11:0] pulse;
wire [31:0] period[NUM_PULSE-1:0];
wire [31:0] width[NUM_PULSE-1:0];

reg trans;
reg [2:0] cnt_byte;
reg [4:0] cnt_byteX8;
wire [4:0] cnt_signal;
reg tx_fifo_wen_p;

wire [15:0] version_l;
wire [31:0] head_l;
wire [15:0] num_pulse_l;
//wire [4:0] num_pulse_m1;

assign version_l = VERSION;
assign head_l = HEAD;
assign num_pulse_l = NUM_PULSE;
//assign num_pulse_m1 = NUM_PULSE - 1'd1;

assign pulse = {pulse11, pulse10, pulse9, pulse8, pulse7, pulse6, 
				pulse5, pulse4, pulse3, pulse2, pulse1, pulse0};
				
genvar i;
generate
	for(i=0; i<12; i=i+1)
	begin: pm
		pulse_measure pulse_measure(
			.clk(clk),
			.rst(rst),
			.ena(ena),
			
			.pulse(pulse[i]),
			
			.count(count),
			.pulse_full(pulse_full),
			
			.period(period[i]),
			.width(width[i])
			);
	end
endgenerate


always @(posedge clk or negedge rst)
	if (!rst)
		trans <= 1'b0;
	else if (pulse_10ms && ena)
		trans <= 1'b1;
	else if (cnt_byte==3'd7 && cnt_byteX8==num_pulse_l)
		trans <= 1'b0;

always @(posedge clk or negedge rst)
	if (!rst)
		cnt_byte <= 3'd0;
	else if (pulse_10ms)
		cnt_byte <= 3'd0;
	else if (tx_fifo_wen_p)
		cnt_byte <= cnt_byte + 1'd1;
		
always @(posedge clk or negedge rst)
	if (!rst)
		cnt_byteX8 <= 5'd0;
	else if (pulse_10ms)
		cnt_byteX8 <= 5'd0;
	else if (tx_fifo_wen_p && cnt_byte==3'b111)
		cnt_byteX8 <= cnt_byteX8 + 1'd1;
		
always @(posedge clk or negedge rst)
	if (!rst)
		tx_fifo_wen_p <= 1'b0;
	else if ((cnt_byte==3'd7 && cnt_byteX8==num_pulse_l) || (tx_fifo_usedw==12'd2000))
		tx_fifo_wen_p <= 1'b0;
	else if (trans && tx_fifo_usedw<12'd2000)
		tx_fifo_wen_p <= 1'b1;
	
		
always @(posedge clk)
	tx_fifo_wen <= tx_fifo_wen_p;
	
assign cnt_signal = cnt_byteX8 - 1'd1;
		
always @(posedge clk or negedge rst)
	if (!rst)
		tx_fifo_wdata <= 8'd0;
	else if (tx_fifo_wen_p && cnt_byteX8==5'd0)
		case (cnt_byte)
			3'd0 : tx_fifo_wdata <= head_l[7:0];
			3'd1 : tx_fifo_wdata <= head_l[15:8];
			3'd2 : tx_fifo_wdata <= head_l[23:16];
			3'd3 : tx_fifo_wdata <= head_l[31:24];
			3'd4 : tx_fifo_wdata <= version_l[7:0];
			3'd5 : tx_fifo_wdata <= version_l[15:8];
			3'd6 : tx_fifo_wdata <= num_pulse_l[7:0];
			3'd7 : tx_fifo_wdata <= num_pulse_l[15:8];
		endcase
	else if (tx_fifo_wen_p && cnt_byteX8>5'd0)
		case (cnt_byte)
			3'd0 : tx_fifo_wdata <= cnt_signal;
			3'd1 : tx_fifo_wdata <= width[cnt_signal][7:0];
			3'd2 : tx_fifo_wdata <= width[cnt_signal][15:8];
			3'd3 : tx_fifo_wdata <= width[cnt_signal][23:16];
			3'd4 : tx_fifo_wdata <= period[cnt_signal][7:0];
			3'd5 : tx_fifo_wdata <= period[cnt_signal][15:8];
			3'd6 : tx_fifo_wdata <= period[cnt_signal][23:16];
			3'd7 : tx_fifo_wdata <= period[cnt_signal][31:24];
		endcase




endmodule
