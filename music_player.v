
//=======================================================
//  This code is generated by Terasic System Builder
//=======================================================

module music_player(

	//////////// CLOCK //////////
	input 		          		CLOCK2_50,
	input 		          		CLOCK3_50,
	input 		          		CLOCK4_50,
	input 		          		CLOCK_50,

	//////////// KEY //////////
	input 		     [3:0]		KEY,

	//////////// SW //////////
	input 		     [9:0]		SW,

	//////////// LED //////////
	output		     [9:0]		LEDR,

	//////////// Seg7 //////////
	output		     [6:0]		HEX0,
	output		     [6:0]		HEX1,
	output		     [6:0]		HEX2,
	output		     [6:0]		HEX3,
	output		     [6:0]		HEX4,
	output		     [6:0]		HEX5,

	//////////// SDRAM //////////
	output		    [12:0]		DRAM_ADDR,
	output		     [1:0]		DRAM_BA,
	output		          		DRAM_CAS_N,
	output		          		DRAM_CKE,
	output		          		DRAM_CLK,
	output		          		DRAM_CS_N,
	inout 		    [15:0]		DRAM_DQ,
	output		          		DRAM_LDQM,
	output		          		DRAM_RAS_N,
	output		          		DRAM_UDQM,
	output		          		DRAM_WE_N,

	//////////// Video-In //////////
	input 		          		TD_CLK27,
	input 		     [7:0]		TD_DATA,
	input 		          		TD_HS,
	output		          		TD_RESET_N,
	input 		          		TD_VS,

	//////////// VGA //////////
	output		          		VGA_BLANK_N,
	output		     [7:0]		VGA_B,
	output		          		VGA_CLK,
	output		     [7:0]		VGA_G,
	output		          		VGA_HS,
	output		     [7:0]		VGA_R,
	output		          		VGA_SYNC_N,
	output		          		VGA_VS,

	//////////// Audio //////////
	input 		          		AUD_ADCDAT,
	inout 		          		AUD_ADCLRCK,
	inout 		          		AUD_BCLK,
	output		          		AUD_DACDAT,
	inout 		          		AUD_DACLRCK,
	output		          		AUD_XCK,

	//////////// PS2 //////////
	inout 		          		PS2_CLK,
	inout 		          		PS2_CLK2,
	inout 		          		PS2_DAT,
	inout 		          		PS2_DAT2,

	//////////// ADC //////////
	output		          		ADC_CONVST,
	output		          		ADC_DIN,
	input 		          		ADC_DOUT,
	output		          		ADC_SCLK,

	//////////// I2C for Audio and Video-In //////////
	output		          		FPGA_I2C_SCLK,
	inout 		          		FPGA_I2C_SDAT,

	//////////// IR //////////
	input 		          		IRDA_RXD,
	output		          		IRDA_TXD
);



//=======================================================
//  REG/WIRE declarations
//=======================================================

wire clk_i2c;
wire clk_mic;
wire reset;
wire [15:0] audiodata;
wire [15:0] musicdata;
wire [15:0] recorddata;
wire [15:0] repeatdata;
reg [15:0] outputdata;
reg [17:0] rptraddr=0;
reg [17:0] rptwaddr=0;
reg [17:0] rptcnt = 0;
//reg [17:0] 
//=======================================================
//  Structural coding
//=======================================================

assign reset = ~KEY[0];

audio_clk u1(CLOCK_50, reset,AUD_XCK, LEDR[9]);


//I2C part
clkgen #(10000) my_i2c_clk(CLOCK_50,reset,1'b1,clk_i2c);  //10k I2C clock

clkgen #(16) my_i2c_clk1(CLOCK_50,reset,1'b1,clk_mic);  //2Hz music clock

player myplayer(clk_mic,AUD_DACLRCK,SW[0],{SW[1],SW[2],SW[3]},{SW[4],SW[5],SW[6]},musicdata,LEDR[5:4],
					CLOCK_50,PS2_CLK,PS2_DAT,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,SW[7]);

I2C_Audio_Config myconfig(clk_i2c, KEY[0],FPGA_I2C_SCLK,FPGA_I2C_SDAT,LEDR[2:0]);

I2S_Audio myaudio(AUD_XCK, KEY[0], AUD_BCLK, AUD_DACDAT, AUD_DACLRCK, outputdata);

Sin_Generator sin_wave(AUD_DACLRCK, KEY[0], musicdata, audiodata);//

I2S_Audioin myaudioin(AUD_XCK, KEY[0], AUD_ADCDAT, AUD_ADCLRCK, recorddata);

repeater myrepeater(recorddata,rptraddr,AUD_ADCLRCK,SW[8],rptwaddr,AUD_ADCLRCK,~KEY[1],repeatdata);

always @(posedge AUD_ADCLRCK)
begin
	if(KEY[1]==0)
	begin	
		if(rptwaddr >= 18'd199999)
		begin
			rptwaddr <= 0;
			rptcnt <= 0;
		end
		else
		begin
			rptwaddr <= rptwaddr+1'b1;
			rptcnt <= rptcnt+1'b1;
		end
	end
	if(KEY[0]==0)
	begin
		rptwaddr <= 0;
		rptcnt <= 0;
	end
end

always @(posedge AUD_ADCLRCK)
begin
	if(SW[8])
	begin
		if(rptraddr >= rptcnt+8'hff)
			rptraddr <= 0;
		else
			rptraddr <= rptraddr+1'b1;
			//rptcnt <= rptcnt+1'b1;
	end
end

always @(posedge AUD_ADCLRCK)
begin
	if(SW[8])
	 outputdata <= repeatdata;
	else
	 outputdata <= audiodata;
end

endmodule
