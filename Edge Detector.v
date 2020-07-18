module edge_detect
(
input wire clk, reset, level;
output tick;
)

localparam [1:0] zero=2'b00, edg=2'b01, one=2'b10;
reg [1:0] state_reg, state_next;

always @(posedge clk or posedge reset) begin
	if (reset)
		state_reg <= zero;
	else
		state_reg <= state_next
end

always @(*) begin
	state_next = state_reg;
	tick = 1'b0;
	case (state_reg)
		zero: 
			if (level)
				state_next = edg;
			
		edg:
			if (level) begin
				tick =1'b1;
				state_next = one;
			else
				state_next = zero;
			end
		one:
			if (~level)
				state_next = zero;
		default:
				state_next = 0;
	endcase
end
endmodule
