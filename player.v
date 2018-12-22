module player(clk,clk_48hz,pause,mode,choice,outdata,testdata,
		CLOCK_50,PS2_CLK,PS2_DAT,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5);
input clk;
input clk_48hz;
input pause;
input [2:0] mode;
input [2:0] choice;
output reg [15:0] outdata;
//reg [15:0] outdata;
output [1:0] testdata;

input CLOCK_50;
inout PS2_CLK;
inout PS2_DAT;
output		 [6:0]		HEX0;
output		 [6:0]		HEX1;
output		 [6:0]		HEX2;
output		 [6:0]		HEX3;
output		 [6:0]		HEX4;
output		 [6:0]		HEX5;
wire reset1;
//=======================
// reg wire 
//========================
wire [2:0] randomdata;   //随机播放音乐号
reg [10:0] readaddr=0;   //rom读地址
reg flag = 1;            
reg flag1 = 1;
reg [9:0] musiclen [0:3]; //每首音乐长度
reg [1:0] musicnum = 0;   //音乐号
wire [15:0] micdata [0:4]; //音乐数据

reg keywrite = 0;
reg keyread = 0;
reg [8:0] keyraddr;
reg [8:0] keywaddr;
wire [15:0] keyoutput;
wire wren;
reg [8:0] keycnt=0;
reg [2:0] readcnt;
//========================
// struct coding
//========================


//=====================================
//key play
//=====================================
keyboard mykeybord(CLOCK_50,1'b1,PS2_CLK,PS2_DAT,keyoutput,reset1,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,wren);

keyplay mykeyplay(keyoutput,keyraddr,clk_48hz,keyread,keywaddr,CLOCK_50,keywrite&wren,micdata[4]);


//==============================================
//four songs
//==============================================
two_tigers twotigers(readaddr, clk_48hz, 1'b1, micdata[0]);
little_star litterstar(readaddr, clk_48hz, 1'b1, micdata[1]);
fireworks myfireworks(readaddr, clk_48hz, 1'b1, micdata[2]);
hope myhope(readaddr, clk_48hz, 1'b1, micdata[3]);


random myrandom(clk,randomdata);
assign testdata = musicnum;

//=================================================================
//mode : 0 for play in order, 1 for random play, 2 for chosse play
//==================================================================
always @(*)
begin
  musiclen[0] = 9'd270;
  musiclen[1] = 9'd220;
  musiclen[2] = 9'd260;
  musiclen[3] = 9'd260;
end

always @(posedge clk)
begin
if(pause==0)
begin
    case(mode)
        0:begin
            flag<=1;
				keyread <= 0;
				keyraddr <= 0;
				keywrite <= 0;
            if(readaddr>=musiclen[musicnum])
            begin
              readaddr <= 0;
              if(musicnum == 2'b11)
                musicnum <= 0;
              else
                musicnum <= musicnum+1'b1;
            end
            else
            begin
              readaddr <= readaddr+1'b1;
              outdata <= micdata[musicnum] * 65536/48000;
            end
          end
        1:begin
				keyread <= 0;
				keyraddr <= 0;
				keywrite <= 0;
            if(flag)
            begin
              musicnum = randomdata;
              flag <= 0;
              readaddr <= 0;
            end
            if(readaddr>=musiclen[musicnum])
            begin
              readaddr <= 0;
              flag<=1;
              //musicnum <= musicnum+1'b1;
            end
            else
            begin
              readaddr <= readaddr+1'b1;
              outdata <= micdata[musicnum] * 65536/48000;
            end
          end
        2:begin
				keyread <= 0;
				keyraddr <= 0;
				keywrite <= 0;
            musicnum <= choice;
            flag <= 1;
            if(readaddr>=musiclen[musicnum])
            begin
              readaddr <= 0;
            end
            else
            begin
              readaddr <= readaddr+1'b1;
              outdata <= micdata[musicnum] * 65536/48000;
            end
           end
			3:begin
				keywrite <= 1'b1;
				keyread <= 1'b0;
				if(wren)
				begin
					keywaddr <= keywaddr+1'b1;
					keycnt <= keycnt+1'b1;
				end
			  end
			4:begin
				keyread <=1'b1;
				keywrite <= 1'b0;
				if(keyraddr >= keycnt)
					keyraddr <= 0;
				else
				begin
					if(readcnt >= 2'b11)
					begin
						readcnt <= 0;
						keyraddr <= keyraddr+1'b1;
					end
					else
						readcnt <= readcnt+1'b1;
				end		
				outdata <= micdata[4] * 65536/48000;
			  end
		default: flag <=1;
    endcase
end
else
begin
  outdata <= 0;
end    
end

endmodule 