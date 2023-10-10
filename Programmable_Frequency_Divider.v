`timescale 1ps / 1fs
module new_freq_divider(
	 input [31:0] in_freq,
	 input clk,
	 output reg [11:0] d,
	 output reg [11:0] q,
	 output reg pulse_0,
	 output reg pulse_1,
	 output reg pulse_2,
	 output reg pulse_n2,
	 output reg f_out
    );
	 
	 //used for division purpose
	 wire [31:0] max_freq;
	 reg [31:0] quotient;
	 
	 //value depends on clock, value changes when clock changes
	 assign max_freq = 32'b1110_1110_0110_1011_0010_1000_0000_0000;
	 
	 //block that calculates d value from input frequency
	 always @(in_freq)
		begin
		quotient = max_freq/in_freq;
		d = (quotient[11:0]-1);
		end
	 
	 //initializing q and f_out values to 0
	 initial q = 0;
	 initial f_out = 0;
	 
	 //Down Counter
	 always @(posedge clk)
		begin
		if (q == 0)
			begin
			q <= d;
			end
		else 
			begin
			q <= q-1;
			end
		end
	 
	 //Generating pulse_0
	 always @(posedge clk)
		begin
		if( q == d)
			pulse_0 <= 1;
		else
			pulse_0 <= 0;
		end
	 
	 //Generating pulse_1
	 always @(negedge clk)
		begin
		if( q == (d-1))
			pulse_1 <= 1;
		else
			pulse_1 <= 0;
		end
	 
	 //Generating pulse_2
	 always @(posedge clk)
		begin
		if(d[0] == 0)
			begin
			if( q == ((d-1)/2))
				pulse_2 <= 1;
			else
			   pulse_2 <= 0;
			end
		else if( d[0] == 1)
			begin
			if( q == (d/2))
				pulse_2 <= 1;
			else
				pulse_2 <= 0;
			end
		end
		
	 //Generating pulse_n2
	 always @(pulse_0, pulse_1, pulse_2)
		begin
		if( d[0] == 0)
			pulse_n2 = pulse_1 | pulse_2;
		else if( d[0] == 1 )
			pulse_n2 = pulse_0 | pulse_2;
		end
	 
	 //Comment when synthesizing
	 //When d = 1 i.e. n=2
	 always @(negedge clk)
		begin
		if( d == 2'h01 )
			pulse_n2 = pulse_0 & pulse_1;
		end
	
			
	 //D flip flop to create pulse_n
	 always @(posedge pulse_n2)
		begin
		f_out = ~f_out;
		end
		
	 //Comment when synthesizing
	 //When d = 0 i.e. n=1
	 always @(clk)
		begin
		if( d == 1'b0 )
			f_out = clk;
		end
	
endmodule
