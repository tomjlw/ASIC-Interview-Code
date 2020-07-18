module bin2bcd
(
	clk, reset, start, bin, ready, done_tick, bcd3, bcd2, bcd1, bcd0
	);

localparam [1:0] idle = 2'b00, op = 2'b01, done = 2'b10;

reg [1:0] state_reg, state_next;
reg [12:0] p2s_reg, p2s_next;
reg [3:0] n_reg, n_next, bcd3_reg, bcd2_reg, bcd1_reg, bcd0_reg;
reg [3:0] bcd3_next, bcd2_next, bcd1_next, bcd0_next;
wire [3:0] bcd3_tmp, bcd2_tmp, bcd1_tmp, bcd0_tmp;

always @(posedge clk or posedge reset) begin
	if (reset) begin
		state_reg <= idle;
		p2s_reg <= 0;
		n_reg <= 0;
		bcd3_reg <= 0;
		bcd2_reg <= 0;
		bcd1_reg <= 0;
		bcd0_reg <= 0;
	end
	else begin
		state_reg <= state_next;
		p2s_reg <= p2s_next;
		n_reg <= n_next;
		bcd3_reg <= bcd3_next;
		bcd2_reg <= bcd2_next;
		bcd1_reg <= bcd1_next;
		bcd0_reg <= bcd0_next;
	end
end


always @(*) begin
	state_next = state_reg;
	ready = 1'b0;
	done_tick = 1'b0;
	p2s_next = p2s_reg;
	bcd0_next = bcd0_reg;
	bcd1_next = bcd1_reg;
	bcd2_next = bcd2_reg;
	bcd3_next = bcd3_reg;
	n_next = n_reg;

	case (state_reg)
		idle:
			begin
				ready = 1'b1;
				if (start)
					begin
						state_next = op;
						bcd3_next = 0;
						bcd2_next = 0;
						bcd1_next = 0;
						bcd0_next = 0;
						n_next = 4'b1101;
						p2s_next = bin;
						state_next = op;
					end
			end

		op:
			begin
				p2s_next = p2s_reg << 1;
				bcd0_next = {bcd0_tmp[2:0], p2s_reg[12]};
				bcd1_next = {bcd1_tmp[2:0], bcd0_tmp[2:0]};
				bcd2_next = {bcd2_tmp[2:0], bcd1_tmp[2:0]};
				bcd3_next = {bcd3_tmp[2:0], bcd2_tmp[2:0]};
				n_next = n_reg - 1;
				if (n_next == 0)
					state_next = done;
			end

		done:
			begin
				done_tick = 1'b1;
				state_next = idle;
			end

		default: state_next = idle;
	endcase
end

assign bcd0_tmp = (bcd0_reg > 4) ? bcd0_reg + 3 : bcd0_reg;
assign bcd1_tmp = (bcd1_reg > 4) ? bcd1_reg + 3 : bcd1_reg;
assign bcd2_tmp = (bcd2_reg > 4) ? bcd2_reg + 3 : bcd2_reg;
assign bcd3_tmp = (bcd3_reg > 4) ? bcd3_reg + 3 : bcd3_reg;

assign bcd0 = bcd0_reg;
assign bcd1 = bcd1_reg;
assign bcd2 = bcd2_reg;
assign bcd3 = bcd3_reg;

endmodule
