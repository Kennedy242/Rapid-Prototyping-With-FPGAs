`timescale 1ns / 1ps
`default_nettype none

// After bouncing has stopped, 
// the input must be stable for
// 65,535 pos clock edges before 
// debounced will change

module debounce_tb;

    // Inputs
    reg reset;
    reg data_in;
    reg clk;

    // Outputs
    wire data_debounced;

    // Test signal
    reg button_push;

    // Instantiate the Units Under Test (UUT)
    debounce debounce_UUT (
        .clk(clk),
        .reset(reset),
        .data_in(data_in),
        .data_debounced(data_debounced)
    );

    // system clock
	always begin 
		clk = 1'b0;
		forever #10 clk = ~clk;
	end

    // Stimulus for UUT
	initial begin
		// Initialize Inputs
		reset = 1;
        data_in = 0;
        button_push = 0;
        
		// Wait 100 ns for global reset to finish
		#20;
        reset = 0;

        // simulate bouncing
        #0.5 data_in = 1;
        button_push = 1;
        #0.5 data_in = 0;
        #0.5 data_in = 1;
        #0.5 data_in = 0;
        #0.5 data_in = 1;
        #0.5 data_in = 0;
        #0.5 data_in = 1;
        #0.5 data_in = 0;
        #0.5 data_in = 1;
        #0.5 data_in = 0;
        #0.5 data_in = 1;
        button_push = 0;
        // end of simulated bounce

	    #2000000 // 2ms
        // simulate bouncing again
        button_push = 1;
        #0.5 data_in = 1;
        #0.5 data_in = 0;
        #0.5 data_in = 1;
        #0.5 data_in = 0;
        #0.5 data_in = 1;
        #0.5 data_in = 0;
        #0.5 data_in = 1;
        #0.5 data_in = 0;
        #0.5 data_in = 1;
        #0.5 data_in = 0;
        button_push = 0;
        // end of simulated bounce
	end
endmodule