`timescale 1ns / 1ps
`default_nettype none

// After bouncing has stopped, 
// the input must be stable for
// 65,535 pos clock edges before 
// debounced will change

module debounce_tb;

    // Inputs
    reg data_in;
    reg clk;

    // Outputs
    wire data_debounced;

    // Test signal
    reg button_push;

    // Instantiate the Units Under Test (UUT)
    debounce debounce_UUT (
        .clk(clk),
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
        data_in = 0;
        button_push = 0;

        #20;
        
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

	    #2000000 // 2ms
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

    // self checking testbench
	integer testbench_error = 0;
    reg test_signal = 0;

    initial begin
		#10 $display("*************** test begin *******************");
		#1310750  test_signal = ~test_signal; 
            if(data_debounced !== 1) begin
            $display("Data_debounced expected to be 1. Actual %d", data_debounced);
            testbench_error = testbench_error + 1;
            end
        #3310770 test_signal = ~test_signal; 
            if(data_debounced !== 0) begin
            $display("Data_debounced expected to be 1. Actual %d", data_debounced);
            testbench_error = testbench_error + 1;
            end
    end

    // end of simulation checks
	initial begin 
		#1600000 if (testbench_error == 0) $display("Test passed!");
		else $display("Test failed with %d errors", testbench_error);
	end
endmodule