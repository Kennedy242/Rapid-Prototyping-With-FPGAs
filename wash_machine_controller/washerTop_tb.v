`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// 
// Module Name: washerTop 
// Project Name:  Wash_machine_controller
//
//////////////////////////////////////////////////////////////////////////////////
module washerTop_tb;

    // Inputs
    reg clk;
    reg reset;
    reg Start;
    reg Door;
    reg [1:0] load;

    // outputs
    wire Agitator;
    wire Motor;
    wire Pump;
    wire Speed;
    wire Water;


    // Instantiate the Unit Under Test (UUT)
    washerTop washerTop(
        .reset(reset),
        .clk(clk),
        .Start(Start),
        .Door(Door),
        .load(load),
        .Agitator(Agitator),
        .Motor(Motor),
        .Pump(Pump),
        .Speed(Speed),
        .Water(Water)
    );

    // set clock signal
    always begin 
		clk = 1'b0;
		forever #5 clk = ~clk;
	end

    initial begin
		// Initialize Inputs
		load = 2'b00;
        Door = 1'b0;
        Start = 1'b0;
        reset = 1'b1;

		// Wait 100 ns for global reset to finish
		#100;

        // start first load
        #5 reset = 1'b0; Start = 1'b1;
        #10 Start = 1'b0;

        // start second load
        #325 reset = 1'b1; load = 2'b01;
        #10 reset = 1'b0; Start = 1'b1;
        #10 Start = 1'b0;

        // start third load
        #350 reset = 1'b1; load = 2'b10;
        #10 reset = 1'b0; Start = 1'b1;
        #10 Start = 1'b0;

        // start fourth load (test door)
        #375 reset = 1'b1;
        #10 reset = 1'b0; Start = 1'b1;
        #10 Start = 1'b0;
        #305 Door = 1;
        #20 Door = 0;
    end
endmodule