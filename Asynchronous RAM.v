module asynchronus_ram
#(parameter ADDR_WDITH = 8, DATA_WDITH =1)

(
	clk, we, addr, din, dout
)

input wire clk, we;
input wire [ADDR_WDITH-1:0] addr;
input wire [DATA_WDITH-1:0] din;
output wire [DATA_WDITH-1:0] dout;

reg [DATA_WDITH-1:0] ram [2*ADDR_WDITH-1:0]

always @(posedge clk) begin
	if (we)
		ram[addr] <= din;
end

assign dout = ram[addr];

endmodule
