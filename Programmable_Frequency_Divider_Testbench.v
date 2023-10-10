`timescale 1ps / 1fs
module new_freq_divider_tb;

	// Inputs
	reg [31:0] in_freq;
	reg clk;

	// Outputs
	wire [11:0] d;
	wire [11:0] q;
	wire pulse_0;
	wire pulse_1;
	wire pulse_2;
	wire pulse_n2;
	wire f_out;

	// Instantiate the Unit Under Test (UUT)
	new_freq_divider uut (
		.in_freq(in_freq), 
		.clk(clk), 
		.d(d), 
		.q(q), 
		.pulse_0(pulse_0), 
		.pulse_1(pulse_1), 
		.pulse_2(pulse_2), 
		.pulse_n2(pulse_n2), 
		.f_out(f_out)
	);
	
	// Clock frequency is set to 4GHz
	always #125 clk = ~clk;
	
	// Divide 4GHz into 50MHz
	initial begin
		in_freq = 32'b0000_0010111110101111000010000000; //50MHz
		clk = 0;
	end
      
endmodule

