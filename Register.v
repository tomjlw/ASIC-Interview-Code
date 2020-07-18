module reg_file
# (parameter B = 8, W = 2)
(
	clk, we_en, w_addr, r_data, w_dat, r_data
);

input wire clk, wr_en;
input wire [W-1:0] w_addr, r_addr;
input wire [B-1:0] w_data;
output wire [B-1:0] r_data;

reg [B-1:0] array_reg [2**W-1:0]

always @(posedge clk) begin
	if (wr_en)
		array_reg[w_addr] <= w_data;
end

assign r_ = array_reg[r_addr];

endmodule
