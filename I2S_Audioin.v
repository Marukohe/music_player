module I2S_Audioin(AUD_XCK,
                 reset_n,
                 //AUD_BCK,
				 AUD_DATA,
				 AUD_LRCK,
				 audiodata
				 //AUD_96CLK
				 );
input AUD_XCK;
input reset_n;
//output reg AUD_96CLK;
reg AUD_BCK;
//output reg AUD_BCK;
input AUD_DATA;
output reg AUD_LRCK;
output reg [15:0] audiodata;
//=================================
//test
//=================================
reg [7:0] datacount; 

////
//input [3:0] voi;
////

reg [7:0] bck_counter;
reg [7:0] lr_counter;
wire [7:0] bitaddr;


//generate BCK 1.536MHz

always @ (posedge AUD_XCK or negedge reset_n)
begin
       if(!reset_n)
		 begin
		    bck_counter <= 8'd0;
			 AUD_BCK     <= 1'b0;
		 end
		 else
		 begin
		    
			 if(bck_counter >= 8'd5) //div XCK by 12
			 begin
			     bck_counter <= 8'd0;
				  AUD_BCK <= ~AUD_BCK;
			 end
			 else
			   bck_counter <= bck_counter + 8'd1;
		 end
		 
end

//generate LRCK, 48kHz, at negedge of BCK

always @ (negedge AUD_BCK or negedge reset_n)
begin
       if(!reset_n)
		 begin
		    lr_counter <= 8'd0;
			 AUD_LRCK     <= 1'b0;
		 end
		 else
		 begin
		    
			 if(lr_counter >= 8'd15) //div BCK by 32
			 begin
			     lr_counter <= 8'd0;
				  AUD_LRCK <= ~AUD_LRCK;
			 end
			 else
			   lr_counter <= lr_counter + 8'd1;
		end
		 
end


//send data, input data avaible at posedge of lrclk, prepared at the posedge of bck

assign  bitaddr  = 8'd15- lr_counter;
//assign  audiodata[bitaddr[3:0]] = AUD_DATA;
always @(*)
begin
	audiodata[bitaddr[3:0]] = AUD_DATA;
end

endmodule 