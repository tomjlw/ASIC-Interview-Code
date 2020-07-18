module hunter(
clk,
rst_n,
a, // 5 cents
b, // 10 cents
y,
z
);
input clk,rst_n;
input a,b;
output reg y,z;

reg CS,NS;

parameter S0=1'b0;
parameter  S1=1'b1;
//同步时序描述状态转移
always@(posedge clk or negedge rst_n)
	if(!rst_n)
		CS<=S0;
	else
		CS<=NS;
//使用组合逻辑判断转移状态条件
always@(CS or a or b)
	begin
		{y,z}=2'b00;
		NS=1'bz;//状态机初始化，不定态的好处，综合器对不定态x的处理是don't care，仿真时可以考察设计FSM完备状态。
		case(CS)
			S0:begin
					if(a&~b)//投入5分的时候
						begin
							{y,z}=2'b00;
							NS=S1;
						end
					else if(~a&b)//投入10分的时候
						begin
							{y,z}=2'b10;
							NS=S0;
						end
					end
			 S1:begin
			 		 if(a&~b)//再次投入5分
			 		 	begin
			 		 		{y,z}=2'b10;
			 		 		NS=S0；
			 		 	end
			 		 else  if(~a&b)
			 		 	begin
			 		 		{y,z}=2'b11;
			 		 		NS=S0;
			 		 	end
			 	   end
			 default:
			 		NS=S0;
			 endcase
	end
	endmodule
