`timescale 1ns / 1ps
`default_nettype none

////////////////////////////////////////////////////////////////////////////////
// 
// Module Name:   washerFSM_tb.v
// Project Name:  Wash_machine_controller
//
////////////////////////////////////////////////////////////////////////////////

module washerFSM_tb;

	// Inputs
	reg clk;
   reg reset;
	reg Door;
	reg Start;
	reg Td;
	reg Tf;
	reg Tr;
	reg Ts;
	reg Tw;

	// Outputs
	wire Agitator;
	wire Motor;
	wire Pump;
	wire R;
	wire Speed;
	wire Water;


	// Instantiate the Unit Under Test (UUT)
	washerFSM uut (
		.clk(clk), 
      .reset(reset),
		.Door(Door), 
		.Start(Start), 
		.Td(Td), 
		.Tf(Tf), 
		.Tr(Tr), 
		.Ts(Ts), 
		.Tw(Tw), 
		.Agitator(Agitator), 
		.Motor(Motor), 
		.Pump(Pump), 
		.R(R), 
		.Speed(Speed), 
		.Water(Water)
	);


    always begin 
		clk = 1'b0;
		forever #5 clk = ~clk;
	end

	initial begin
		// Initialize Inputs
        reset = 1;
		Door = 0;
		Start = 0;
		Td = 0;
		Tf = 0;
		Tr = 0;
		Ts = 0;
		Tw = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
        // first load
        #10 reset = 0; Start = 1; // move to fill 1

        #20 Start = 0; Tf = 1; // move to wash

        #20 Tf = 0; Tw = 1; // move to drain 1

        #10 Tw = 0; Td = 1; // move to fill 2

        #20 Td = 0; Tf = 1; // move to rise

        #40 Tf = 0; Tr = 1; // move to drain 2

        #10 Tr = 0; Td = 1; // move to spin 

        #80 Td = 0; Ts = 1; //move to idle

        #20 reset = 1;

        // second load
        #10 reset = 0; Start = 1; // move to fill 1

        #20 Start = 0; Tf = 1; // move to wash

        #20 Tf = 0; Tw = 1; // move to drain 1

        #10 Tw = 0; Td = 1; // move to fill 2

        #20 Td = 0; Tf = 1; // move to rise

        #40 Tf = 0; Tr = 1; // move to drain 2

        #10 Tr = 0; Td = 1; // move to spin 

        #10 Door = 1;

        #20 Door = 0;

        #80 Td = 0; Ts = 1; //move to idle

        #20 reset = 1;
	end
endmodule

