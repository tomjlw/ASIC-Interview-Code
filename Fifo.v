module fifo
#(
parameter B = 8, W = 4;
)
(
input wire clk, reset;
input wire rd, wr;
input wire [B-1:0] w_data;
output wire empty, full;
output wire [B-1:0] r_data;
)

reg [B-1:0] array_reg [W-1:0];
reg [W-1:0] w_ptr_reg, w_next_reg, w_succ_reg;
reg [W-1:0] r_ptr_reg, r_next_reg, r_succ_reg;
reg full_reg, empty_reg, full_next, empty_next;
wire wr_en;

always @(posedge clk) begin
		if (wr_en) begin
			array_reg[w_ptr_reg] <= w_data;
		end
	end
	
	assign r_data = array_reg[w_ptr_reg];
	assign wr_en = wr & empty_reg;

	always @(posedge clk or posedge reset) begin
		if (reset) begin
			w_ptr_reg <= 0;
			r_ptr_reg <= 0;
			full_reg <= 0;
			empty_reg <= 1;
		end
		else begin
			w_ptr_reg <= w_ptr_next;
			r_ptr_reg <= r_ptr_next;
			full_reg <= full_next;
			empty_reg <= empty_next;
		end	
	end
	
	always @(*) begin
		w_ptr_succ = w_ptr_succ + 1;
		r_ptr_succ = r_ptr_succ + 1;
		w_ptr_next <= w_ptr_reg;
		r_ptr_next <= r_ptr_reg;
		full_next <= full_reg;
		empty_next <= empty_reg;
		case({wr, rd})
		2'b01:
			if(~empty_reg) begin
				r_ptr_next = r_ptr_succ;
				full_next = 1'b0;
				if (r_ptr_succ == w_ptr_reg) begin
					empty_next = 1'b1; 
				end
			end
		2'b10:
			if(~full_reg) begin
				w_ptr_next = w_ptr_succ;
				empty_next = 1'b0;
				if (w_ptr_succ == r_ptr_reg) begin
					full_next = 1'b1; 
				end
			end
		2'b11:
			w_ptr_next = w_ptr_succ;
			r_ptr_next = r_ptr_succ;
		endcase
	end
assign full = full_reg;
assign empty = empty_reg;		
endmodule
