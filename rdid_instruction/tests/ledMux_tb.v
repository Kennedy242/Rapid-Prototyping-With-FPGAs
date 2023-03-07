`timescale 1ns / 1ps
`default_nettype none

module ledMux_tb();
    
    // Inputs
    reg [7:0] memory_capacity;
    reg [7:0] memory_type;
    reg [7:0] manufacture_id;
    reg SW0;
    reg SW1;
    reg reset;
        
    // Outputs
    wire [7:0] LED;
    
    // Instantiate the Unit Under Test (UUT)
    ledMux ledMux(
        .reset(reset),
        .SW0(SW0),
        .SW1(SW1),
        .memory_capacity(memory_capacity),
        .memory_type(memory_type),
        .manufacture_id(manufacture_id),
        .LED(LED)
    );
    
    // Stimulus for UUT
    initial begin
        // Initialize inputs
        memory_capacity = 8'h15;
        memory_type = 8'h20;
        manufacture_id = 8'h20;
        reset = 1;
        
        // Wait 100 ns for global reset to finish
        #100 reset = 0;
        
        // Start stimulus
        #10 {SW1, SW0} = 2'b00;
        #10 {SW1, SW0} = 2'b01;
        #10 {SW1, SW0} = 2'b10;
        #10 {SW1, SW0} = 2'b11;
        #20 reset = 1;
        #20 reset = 0;
    end
    
    // self checking testbench
    integer testbench_error = 0;
    reg test_signal = 0;
    
    initial begin
        #10 $display("*************** test begin *******************");
        #106 test_signal = ~test_signal;
            if (LED !== 8'h15) begin
                $display("LED expected to be 0x15 for mem cap. Actual %d", LED);
                testbench_error = testbench_error + 1;
            end 
        #10 test_signal = ~test_signal;
            if (LED !== 8'h20) begin
                $display("LED expected to be 0x20 for mem type. Actual %d", LED);
                testbench_error = testbench_error + 1;
            end 
        #10 test_signal = ~test_signal;
            if (LED !== 8'h20) begin
                $display("LED expected to be 0x20 for man id. Actual %d", LED);
                testbench_error = testbench_error + 1;
            end 
        #10 test_signal = ~test_signal;
            if (LED !== 8'hff) begin
                $display("LED expected to be 0xff for default. Actual %d", LED);
                testbench_error = testbench_error + 1;
            end
        #25 test_signal = ~test_signal;
        if (LED !== 8'h00) begin
            $display("LED expected to be 0x00 for reset. Actual %d", LED);
            testbench_error = testbench_error + 1;
        end
        #20 test_signal = ~test_signal;
        if (LED !== 8'hff) begin
            $display("LED expected to be 0x00 for default. Actual %d", LED);
            testbench_error = testbench_error + 1;
        end
    end
    
    // end of simulation checks
    initial begin 
        #500 if (testbench_error == 0) $display("Test passed!");
        else $display("Test failed with %d errors", testbench_error);
    end
endmodule