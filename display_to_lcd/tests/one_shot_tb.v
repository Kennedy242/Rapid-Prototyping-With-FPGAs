`timescale 1ns / 1ps
`default_nettype none

module one_shot_tb();
    
    // Inputs
    reg clk;
    reg reset;
    reg get_rdid_debounce;

    // Outputs
    wire data_out;

    // Instantiate the Unit Under Test (UUT)
    one_shot one_shot(
        .clk(clk),
        .data_in(get_rdid_debounce),
        .data_out(data_out)
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
        get_rdid_debounce = 0;
        
        // Wait 100 ns for global reset to finish
        #100;
        reset = 0;
        
        // Start stimulus
        #13 get_rdid_debounce = 1;

        #90 get_rdid_debounce = 0;
    end

    // self checking testbench
    integer testbench_error = 0;
    reg test_signal = 0;

    initial begin
        #10 $display("*************** test begin *******************");
        #102.5 test_signal = ~test_signal;
            if(data_out !== 0) begin
                $display("data out expected to be 0. Actual %d", data_out);
                testbench_error = testbench_error + 1;
            end
        #1 test_signal = ~test_signal;
            if(data_out !== 1) begin
                $display("data out expected to be 1. Actual %d", data_out);
                testbench_error = testbench_error + 1;
            end
        #16 test_signal = ~test_signal;
            if(data_out !== 1) begin
                $display("data out expected to be 1. Actual %d", data_out);
                testbench_error = testbench_error + 1;
            end
        #1 test_signal = ~test_signal;
            if(data_out !== 0) begin
                $display("data out expected to be 0. Actual %d", data_out);
                testbench_error = testbench_error + 1;
            end
    end

    // end of simulation checks
    initial begin
        #300 if (testbench_error == 0) $display("Test passed!");
        else $display("Test failed with %d errors", testbench_error);
    end
   
endmodule
