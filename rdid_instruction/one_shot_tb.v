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
   
endmodule