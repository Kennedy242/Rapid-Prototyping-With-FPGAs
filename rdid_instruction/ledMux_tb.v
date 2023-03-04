`timescale 1ns / 1ps
`default_nettype none

module ledMux_tb();
    
    // Inputs
    reg [7:0] memory_capacity;
    reg [7:0] memory_type;
    reg [7:0] manufacture_id;
    reg [7:0] SW;
        
    // Outputs
    wire [7:0] LED;
    
    // Instantiate the Unit Under Test (UUT)
    ledMux ledMux(
        .SW(SW),
        .memory_capacity(memory_capacity),
        .memory_type(memory_type),
        .manufacture_id(manufacture_id),
        .LED(LED)
    );
    
    // Stimulus for UUT
    initial begin
        // Initialize inputs
        memory_capacity = 0;
        memory_type = 1;
        manufacture_id = 2;
        
        // Wait 100 ns for global reset to finish
        #100;
        
        // Start stimulus
        SW = 2'b00;
        #10 SW = 2'b01;
        #10 SW = 2'b10;
        #10 SW = 2'b11;
    end
    
    // self checking testbench
    integer testbench_error = 0;
    // TODO: add test signal    
    
    initial begin
        #10 $display("*************** test begin *******************");
        #91 if (LED !== 8'h0) begin
                $display("LED expected to be 0. Actual %d", LED);
                testbench_error = testbench_error + 1;
            end 
        #10 if (LED !== 8'h1) begin
                $display("LED expected to be 1. Actual %d", LED);
                testbench_error = testbench_error + 1;
            end 
        #10 if (LED !== 8'h2) begin
                $display("LED expected to be 1. Actual %d", LED);
                testbench_error = testbench_error + 1;
            end 
        #10 if (LED !== 8'hff) begin
                $display("LED expected to be ff. Actual %d", LED);
                testbench_error = testbench_error + 1;
            end 
    end
    
    // end of simulation checks
    initial begin 
        #500 if (testbench_error == 0) $display("Test passed!");
        else $display("Test failed with %d errors", testbench_error);
    end
endmodule