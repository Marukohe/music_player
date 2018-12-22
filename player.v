module player(clk,clk_48hz,pause,mode,choice,outdata,testdata);
input clk;
input clk_48hz;
input pause;
input [1:0] mode;
input [2:0] choice;
output reg [15:0] outdata;
//reg [15:0] outdata;
output [1:0] testdata;
//=======================
// reg wire 
//========================
wire [2:0] randomdata;
reg [10:0] readaddr=0;
reg flag = 1;
reg [9:0] musiclen [0:3];
reg [1:0] musicnum = 0;
wire [15:0] micdata [0:2];
//========================
// struct coding
//========================

two_tigers twotigers(readaddr, clk_48hz, 1'b1, micdata[0]);
little_star litterstar(readaddr, clk_48hz, 1'b1, micdata[1]);
fireworks myfireworks(readaddr, clk_48hz, 1'b1, micdata[2]);
//rom3 rom33(readaddr, clk, 1'b1, outdata);

/*
always @(posedge clk)
begin
    if(readaddr == 7'd70)
    begin
        readaddr <= 0;
    end
    else
    begin
      readaddr <= readaddr + 1'b1;
      outdata <= micdata * 65536/48000;
    end
end
*/

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
  musiclen[3] = 4'd10;
end

always @(posedge clk)
begin
if(pause==0)
begin
    case(mode)
        0:begin
            flag<=1;
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
		default: flag <=1;
    endcase
end
else
begin
  outdata <= 0;
end    
end

endmodule 