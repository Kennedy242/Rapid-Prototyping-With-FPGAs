`timescale 1ns / 1ps
`default_nettype none

module rdid_tb();
    
    // Inputs
    reg clk;
    reg reset;
    reg get_rdid;
    reg [1:0] SW;
   
    // Outputs
    wire SPIMISO;
    wire SPICLK;
    wire SPIMOSI;
    wire cs_prom_n;
    wire [7:0] LED;
    
    // Instantiate the Unit Under Test (UUT)
    rdid rdid (
        .clk(clk), 
        .reset(reset), 
        .get_rdid(get_rdid), 
        .SW(SW), 
        .SPIMISO(SPIMISO), 
        .SPICLK(SPICLK), 
        .SPIMOSI(SPIMOSI), 
        .cs_prom_n(cs_prom_n), 
        .LED(LED)
    );

    m25p16 m25p16(
		.c(SPICLK),
		.data_in(SPIMOSI),
		.s(cs_prom_n),
		.w(1'b1),
		.hold(1'b0),
		.data_out(SPIMISO)
	);
    
    // System clock
    always begin 
        clk = 1'b0;
        forever #10 clk = ~clk; //50MHz 
    end
    
    // Stimulus for UUT
    initial begin
        // Initialize inputs
        reset = 1;
        get_rdid = 0;
        SW = 2'b00;
        
        // Wait 100 ns for global reset to finish
        #100;
        #20 reset = 0;

        #20 get_rdid = 1;
        #20 get_rdid = 0;
        
        // Start stimulus
    end
    
    // self checking testbench
    integer testbench_error = 0;
    reg test_signal = 0;
    
    initial begin
        #10 $display("*************** test begin *******************");
        #1490 test_signal = ~test_signal;
            if(LED !== 8'h15) begin
                $display( "mem cap LED failed. Expected 0x15 Actual %h", LED );
                testbench_error = testbench_error + 1;
			end
        #20 SW = 2'b01;
        #20 test_signal = ~test_signal;
            if(LED !== 8'h20) begin
                $display( "mem type LED failed. Expected 0x20 Actual %h", LED );
                testbench_error = testbench_error + 1;
			end
        #20 SW = 2'b10;
        #20 test_signal = ~test_signal;
            if(LED !== 8'h20) begin
                $display( "man ID LED failed. Expected 0x20 Actual %h", LED );
                testbench_error = testbench_error + 1;
			end
        #20 SW = 2'b11;
        #20 test_signal = ~test_signal;
            if(LED !== 8'hFF) begin
                $display( "default case LED failed. Expected 0xFF Actual %h", LED );
                testbench_error = testbench_error + 1;
			end
    end
    
    // end of simulation checks
    initial begin 
        #1700 if (testbench_error == 0) $display("Test passed!");
        else $display("Test failed with %d errors", testbench_error);
    end
endmodule