module random(clk,outputdata);
input clk;
output reg [2:0] outputdata;
reg [7:0] hexo=8'hff;

always @(posedge clk)
	begin
		hexo[0]<=hexo[7];
		hexo[1]<=hexo[0];
		hexo[2]<=hexo[1]^hexo[7];
		hexo[3]<=hexo[2]^hexo[7];
		hexo[4]<=hexo[3]^hexo[7];
		hexo[5]<=hexo[4];
		hexo[6]<=hexo[5]^hexo[7];
		hexo[7]<=hexo[6];
        outputdata <= hexo[2:0];
	end 

endmodule