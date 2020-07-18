module mod_m_counter
# (
	parameter M = 8, N = 4
  )

( clk, reset, q, max_tick);

input wire  clk,
input wire reset,
output reg [N-1:0] q

always @ (posedge clk or posedge reset) begin
	if (!reset) begin
		q <= 0;
	end else begin
		if (q == M - 1)
			q <= 0;
			max_tick = 1;
		else
	    	q <= q + 1;
	end
end

endmodule
