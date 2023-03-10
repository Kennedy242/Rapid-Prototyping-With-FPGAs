`timescale 1ns / 1ps
`default_nettype none
module sync_tb ();
    
    // Inputs
    reg data_in;
    reg clk;
    
    // Outputs
    wire data_out;
    
    // Instantiate the Unit Under Test (UUT)
    sync sync(
        .clk(clk),
        .async_in(data_in),
        .sync_out(data_out)
    );
    
    // System clock
    always begin 
        clk = 1'b0;
        forever #10 clk = ~clk;
    end
    
    // Stimulus for UUT
    initial begin
        // Initialize inputs
        data_in = 1;
        
        // Start stimulus
        #23 data_in = 0;
    end
    
    // self checking testbench
    // integer testbench_error = 0;
    
    // initial begin
    //     #10 $display("*************** test begin *******************");
    // end
    
    // // end of simulation checks
    // initial begin 
    //     #3000 if (testbench_error == 0) $display("Test passed!");
    //     else $display("Test failed with %d errors", testbench_error);
    // end
endmodule