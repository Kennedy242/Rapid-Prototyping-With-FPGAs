`timescale 1ns / 1ps
`default_nettype none

module sync_tb();
    
    // Inputs
    reg clk;
    reg reset;
    
    // Outputs
    wire reset_sync;
    
    // Instantiate the Unit Under Test (UUT)
    sync sync(
        .clk(clk),
        .data_in(reset),
        .data_out(reset_sync)
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
    
endmodule