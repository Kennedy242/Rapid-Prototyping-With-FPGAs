`timescale 1ns / 1ps
`default_nettype none

module reset_sync_tb();
    
    // Inputs
    reg clk;
    reg reset;
    
    // Outputs
    wire reset_sync;
    
    // Instantiate the Unit Under Test (UUT)
    reset_sync reset_sync(
        .clk(clk),
        .set(reset),
        .data_q(reset_sync)
    );
    
    // System clock
    always begin 
        clk = 1'b0;
        forever #10 clk = ~clk;
    end
    
    // Stimulus for UUT
    initial begin
        // Initialize inputs
        reset = 1;
        
        // Wait 100 ns for global reset to finish
        #100;

        // Start stimulus
        #10 reset = 0;
        
        #34 reset = 1;
    end
    
    // self checking testbench
    integer testbench_error = 0;
    reg test_signal = 0;
    
    initial begin
        #10 $display("*************** test begin *******************");

        #99 test_signal = ~test_signal; 
        if (reset !== 1) begin 
            $display("Reset expected to be 1. Actual %d", reset);
            testbench_error = testbench_error + 1;
            end 
            if (reset_sync !== 1) begin 
            $display("Reset_sync expected to be 1. Actual %d", reset_sync);
            testbench_error = testbench_error + 1;
            end 
        #2 test_signal = ~test_signal;
        if (reset !== 0) begin 
            $display("Reset expected to be 0. Actual %d", reset);
            testbench_error = testbench_error + 1;
            end 
            if (reset_sync !== 1) begin 
            $display("Reset_sync expected to be 1. Actual %d", reset_sync);
            testbench_error = testbench_error + 1;
            end 
        #11 test_signal = ~test_signal;
        if (reset !== 0) begin 
            $display("Reset expected to be 0. Actual %d", reset);
            testbench_error = testbench_error + 1;
            end 
            if (reset_sync !== 0) begin 
            $display("Reset_sync expected to be 0. Actual %d", reset_sync);
            testbench_error = testbench_error + 1;
            end 
        #21 test_signal = ~test_signal;
        if (reset !== 0) begin 
            $display("Reset expected to be 0. Actual %d", reset);
            testbench_error = testbench_error + 1;
            end 
            if (reset_sync !== 0) begin 
            $display("Reset_sync expected to be 0. Actual %d", reset_sync);
            testbench_error = testbench_error + 1;
            end 
        #2 
        test_signal = ~test_signal;
        if (reset !== 1) begin 
            $display("Reset expected to be 1. Actual %d", reset);
            testbench_error = testbench_error + 1;
            end 
            if (reset_sync !== 1) begin 
            $display("Reset_sync expected to be 1. Actual %d", reset_sync);
            testbench_error = testbench_error + 1;
            end 
    end
    
    // end of simulation checks
    initial begin 
        #300 if (testbench_error == 0) $display("Test passed!");
        else $display("Test failed with %d errors", testbench_error);
    end
endmodule