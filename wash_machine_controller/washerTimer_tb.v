`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// 
// Module Name:    washerTimer_tb 
// Project Name:  Wash_machine_controller
//
//////////////////////////////////////////////////////////////////////////////////
module testbenchy(
    );
	 
	 // Inputs
	reg [1:0] load;
	reg clk;
	reg R;
	reg hold;

	// Outputs
	wire Td;
	wire Tf;
	wire Tr;
	wire Ts;
	wire Tw;

	// Instantiate the Unit Under Test (UUT)
	washerTimer uut (
		.load(load), 
		.clk(clk), 
		.R(R), 
		.hold(hold),
		.Td(Td), 
		.Tf(Tf), 
		.Tr(Tr), 
		.Ts(Ts), 
		.Tw(Tw)
	);

	always begin 
		clk = 1'b0;
		forever #5 clk = ~clk;
	end
	initial begin
		// Initialize Inputs
		load = 2'b00;
		R = 1'b1;
		hold = 1'b0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		#5 R = 1'b0; 

		#150 R =  1'b1; load = 2'b01;
		#5 R = 1'b0;

		#150 R =  1'b1; load = 2'b10;
		#5 R = 1'b0;

		#20 hold = 1;
	end

endmodule
