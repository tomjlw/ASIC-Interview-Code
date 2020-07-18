moduel n_divider#(parameter N=3)(clk, rst，clk_div);
input clk, rst;
output clk_div
reg sig_f;
reg sig_r;
reg [N-1:0] cnt_r;
reg [N-1:0] cnt_f;

wire clk_f;
assign clk_f = ~clk;

always @(posedge clk or negedge rst) begin
    if (rst==0) begin
        cnt_r <= 0;
        sig_r <= 0;
    end
    else begin 
            cnt_r <= cnt_r+1
            if(cnt_r <= (N-1)/2) begin
                sig_r <= ~sig_r；
            end
            else if(cnt_r <= (N-1)) begin
                sig_r <= ~sig_r；
                cnt_r <= 0;
            end
    end
end

always @(posedge clk_f or negedge rst) begin
    if (rst==0) begin
        cnt_f <= 0;
        sig_f <= 0;
    end
    else begin 
            cnt_f <= cnt_f+1
            if(cnt_f <= (N-1)/2) begin
                sig_f <= ~sig_f；
            end
            else if(cnt_f <= (N-1)) begin
                sig_f <= ~sig_f；
                cnt_f <= 0;
            end
    end
end

reg div_reg;
reg [N-1:0] div_cnt;
always @(posedge clk or negedge rst) begin
    if(rst==0) begin
        div_cnt <= 0;
        div_reg <= 0;
    end
    else begin
        if(div_cnt == (N/2-1)) begin
            div_cnt <= 0;
            div_reg <= ~div_reg
        end
    end
end

assign clk_div = (N==1)?clk:(N%2==1)?sig_f || sig_r:div_reg;
