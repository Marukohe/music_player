module keyboard(clk,clrn,kbd_clk,kbd_data,freq,reset,hexc1,hexc2,hexc3,hexc4,hexc5,hexc6,wren);
	input clk,clrn; //时钟，使能
	input kbd_clk;  //键盘时钟
	input kbd_data;  //键盘数据
	reg nextdata_n=0;
	wire [7:0] k_data;
	reg [7:0] data=0;
	output reg [15:0] freq;
	output reg reset;
	
	wire ready;
	wire overflow;
	reg [1:0] model=0;
	output reg [6:0] hexc1;
	output reg [6:0] hexc2;
	output reg [6:0] hexc3;
	output reg [6:0] hexc4;
	output reg [6:0] hexc5;
	output reg [6:0] hexc6;
	output reg wren;
	reg [7:0] cntkey=0;
	
	
	reg [7:0] memory [0:255];
	reg [7:0] memorydata;
	initial
	begin
		$readmemh("D:/My_design/My_eighth_fpga/input.txt",memory,0,255);
	end
	
	ps2_keyboard inst(
    .clk(clk),
    .clrn(clrn),
    .ps2_clk(kbd_clk),
    .ps2_data(kbd_data),
    .data(k_data),
    .ready(ready),
    .nextdata_n(nextdata_n),
    .overflow(overflow)
    );
	 
	 
	always @(posedge clk)
	begin
	if(ready)
	begin
		nextdata_n<=1;
		case(model[1:0])
			0:
			   if(k_data!=8'b11110000 && nextdata_n==0)
				begin
					data<=k_data;
					cntkey<=cntkey+1'b1;
					model<=1;
					wren <= 1;
				end
			1:
				if(k_data==8'b11110000)
				begin
					data<=k_data;
					model<=2;
					wren <= 0;
				end
			2:
				if(k_data!=8'b11110000)
				begin
					data<=8'b11110000;
					model<=0;
					wren <= 0;
				end
			endcase
	end
	else
	begin
		nextdata_n<=0;
	end
	end

	 
	 always @(posedge clk)
	 begin
	 case(data[7:0])
		8'h1c: begin freq = 16'h0106; reset = 1'b1; end
		8'h1b: begin freq = 16'h0126; reset = 1'b1; end
		8'h23: begin freq = 16'h014a; reset = 1'b1; end
		8'h2b: begin freq = 16'h015d; reset = 1'b1; end
		8'h34: begin freq = 16'h0188; reset = 1'b1; end
		8'h33: begin freq = 16'h01b8; reset = 1'b1; end
		8'h3b: begin freq = 16'h01ee; reset = 1'b1; end
		8'h42: begin freq = 16'h020b; reset = 1'b1; end
		8'h4b: begin freq = 16'h024b; reset = 1'b1; end
		8'h4c: begin freq = 16'h0293; reset = 1'b1; end
		8'h52: begin freq = 16'h02ba; reset = 1'b1; end 
		8'h5d: begin freq = 16'h0310; reset = 1'b1; end
		8'h5a: begin freq = 16'h0370; reset = 1'b1; end
		default: begin freq = 16'h0000; reset = 1'b0; end
	 endcase
	 
		case(data[3:0])
		0: hexc1=7'b1000000;  //0
		1: hexc1=7'b1111001;  //1
		2: hexc1=7'b0100100;  //2
		3: hexc1=7'b0110000;  //3
		4: hexc1=7'b0011001;  //4
		5: hexc1=7'b0010010;  //5
		6: hexc1=7'b0000010;  //6
		7: hexc1=7'b1111000;  //7
		8: hexc1=7'b0000000;  //8
		9: hexc1=7'b0010000;  //9
		10: hexc1=7'b0001000;  //10
		11: hexc1=7'b0000011;  //11
		12: hexc1=7'b1000110;  //12
		13: hexc1=7'b0100001;  //13
		14: hexc1=7'b0000110;  //14
		15: hexc1=7'b0001110;  //15
		default: hexc1=7'b0000000;
	 endcase 
	 
	 case(data[7:4])
		0: hexc2=7'b1000000;  //0
		1: hexc2=7'b1111001;  //1
		2: hexc2=7'b0100100;  //2
		3: hexc2=7'b0110000;  //3
		4: hexc2=7'b0011001;  //4
		5: hexc2=7'b0010010;  //5
		6: hexc2=7'b0000010;  //6
		7: hexc2=7'b1111000;  //7
		8: hexc2=7'b0000000;  //8
		9: hexc2=7'b0010000;  //9
		10: hexc2=7'b0001000;  //10
		11: hexc2=7'b0000011;  //11
		12: hexc2=7'b1000110;  //12
		13: hexc2=7'b0100001;  //13
		14: hexc2=7'b0000110;  //14
		15: hexc2=7'b0001110;  //15
		default: hexc2=7'b0000000;
	 endcase
	
	 memorydata=memory[data];
	 
	 case(memorydata[3:0])
		0: hexc3=7'b1000000;  //0
		1: hexc3=7'b1111001;  //1
		2: hexc3=7'b0100100;  //2
		3: hexc3=7'b0110000;  //3
		4: hexc3=7'b0011001;  //4
		5: hexc3=7'b0010010;  //5
		6: hexc3=7'b0000010;  //6
		7: hexc3=7'b1111000;  //7
		8: hexc3=7'b0000000;  //8
		9: hexc3=7'b0010000;  //9
		10: hexc3=7'b0001000;  //10
		11: hexc3=7'b0000011;  //11
		12: hexc3=7'b1000110;  //12
		13: hexc3=7'b0100001;  //13
		14: hexc3=7'b0000110;  //14
		15: hexc3=7'b0001110;  //15
		default: hexc3=7'b0000000;
	 endcase
	
	 case(memorydata[7:4])
		0: hexc4=7'b1000000;  //0
		1: hexc4=7'b1111001;  //1
		2: hexc4=7'b0100100;  //2
		3: hexc4=7'b0110000;  //3
		4: hexc4=7'b0011001;  //4
		5: hexc4=7'b0010010;  //5
		6: hexc4=7'b0000010;  //6
		7: hexc4=7'b1111000;  //7
		8: hexc4=7'b0000000;  //8
		9: hexc4=7'b0010000;  //9
		10: hexc4=7'b0001000;  //10
		11: hexc4=7'b0000011;  //11
		12: hexc4=7'b1000110;  //12
		13: hexc4=7'b0100001;  //13
		14: hexc4=7'b0000110;  //14
		15: hexc4=7'b0001110;  //15
		default: hexc4=7'b0000000;
	 endcase
	 
	 if(data==8'b11110000)
	 begin
		hexc1=7'b1111111;
		hexc2=7'b1111111;
		hexc3=7'b1111111;
		hexc4=7'b1111111;
	 end
	 
 	 case(cntkey[3:0])
		0: hexc5=7'b1000000;  //0
		1: hexc5=7'b1111001;  //1
		2: hexc5=7'b0100100;  //2
		3: hexc5=7'b0110000;  //3
		4: hexc5=7'b0011001;  //4
		5: hexc5=7'b0010010;  //5
		6: hexc5=7'b0000010;  //6
		7: hexc5=7'b1111000;  //7
		8: hexc5=7'b0000000;  //8
		9: hexc5=7'b0010000;  //9
		10: hexc5=7'b0001000;  //10
		11: hexc5=7'b0000011;  //11
		12: hexc5=7'b1000110;  //12
		13: hexc5=7'b0100001;  //13
		14: hexc5=7'b0000110;  //14
		15: hexc5=7'b0001110;  //15
		default: hexc5=7'b0000000;
	 endcase
	
	 case(cntkey[7:4])
		0: hexc6=7'b1000000;  //0
		1: hexc6=7'b1111001;  //1
		2: hexc6=7'b0100100;  //2
		3: hexc6=7'b0110000;  //3
		4: hexc6=7'b0011001;  //4
		5: hexc6=7'b0010010;  //5
		6: hexc6=7'b0000010;  //6
		7: hexc6=7'b1111000;  //7
		8: hexc6=7'b0000000;  //8
		9: hexc6=7'b0010000;  //9
		10: hexc6=7'b0001000;  //10
		11: hexc6=7'b0000011;  //11
		12: hexc6=7'b1000110;  //12
		13: hexc6=7'b0100001;  //13
		14: hexc6=7'b0000110;  //14
		15: hexc6=7'b0001110;  //15
		default: hexc6=7'b0000000;
	 endcase
		 
		 
	end
	

	
endmodule 