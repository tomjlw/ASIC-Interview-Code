module low_freq_counter
(
clk, reset, start, si, bcd3, bcd2, bcd1, bcd0
	);

input wire clk, reset, start, si;
output wire [3:0] bcd3, bcd2, bcd1, bcd0;

localparam [1:0] idle = 2'b00, count = 2'b01, frq = 2'b10, b2b = 2'b11;

reg [1:0] state_reg, state_next;
wire [9:0] prd;
wire [19:0] dvsr, dvnd, quo;
reg prd_start, div_start, b2b_start;
wire prd_done_tick, div_done_tick, b2b_done_tick;

period_couter prd_count_unit(.clk(clk), .reset(reset), .start(prd_start), .si(si), .ready(), 
	.done_tick(prd_done_tick), .prd(prd));
div #(.W(20), .CBIT(5)) (.clk(clk), .reset(reset), .start(div_start), .dvsr(dvsr), .dvnd(dvnd), 
	.quo(quo), .rmd(), .ready(), .done_tick(div_done_tick));
bin2bcd b2d_unit(.clk(clk), .reset(reset), .start(b2b_start), .bin(quo[12:0]), .ready(), 
	.done_tick(b2b_done_tick), .bcd3(bcd3), .bcd2(bcd2), .bcd1(bcd1), .bcd0(bcd0));

assign dvnd = 20'd1000000;
assign dvsr = {10'b0, prd};

always @(posedge clk or posedge reset) begin
	if (reset) begin
		state_reg <= idle;
	end
	else 
		state_reg <= state_next;
	end
end

always @(*) begin
	state_next = 1'b0;
	div_start = 1'b0;
	b2b_start = 1'b0;

	case (state_reg)
		idle:
			if (start)
				begin
					prd_start = 1'b1;
					state_next = count;
				end

		count:
			if (prd_done_tick)
				begin
					div_start = 1'b1;
					state_next = frq;
				end

		frq:
			if (div_done_tick)
				begin
					b2b_start = 1'b1;
					state_next = b2b;
				end

		b2b: 
			if (b2b_done_tick) begin
				state_next = idle;
			end
	endcase
end
