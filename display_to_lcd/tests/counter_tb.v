`timescale 1ns / 1ps
`default_nettype none

module counter_tb_tb();
    
    // Inputs
    reg CCLK;
    reg reset;
    
    // Outputs
    wire clk;
    wire time_1ms;
    wire time_100us;
    wire time_40us;
    
    // Instantiate the Unit Under Test (UUT)
    counter counter (
    .clk(clk), 
    .reset(reset), 
    .time_1ms(time_1ms), 
    .time_100us(time_100us), 
    .time_40us(time_40us)
    );

     clock_divider clock_divider (
        .CLKIN_IN(CCLK),
        .CLKDV_OUT(clk)
    );
    
    // System clock
    always begin 
        CCLK = 1'b0;
        forever #10 CCLK = ~CCLK; //50MHz
    end
    
    // Stimulus for UUT
    initial begin
        // Initialize inputs
        reset = 1;
        
        #390;
        reset = 0;
        
        // Start stimulus
    end
    
    // self checking testbench
    integer testbench_error = 0;
    
    initial begin
        #10 $display("*************** test begin *******************");
        #40221 if( time_40us != 1) begin
            testbench_error = testbench_error + 1;
            $display("40 us timer is incorrect");
        end
    end
    initial begin
        #100071 if( time_100us != 1) begin
            testbench_error = testbench_error + 1;
            $display("100 us timer is incorrect");
        end
    end
    initial begin
        #1000231 if( time_1ms != 1) begin
            testbench_error = testbench_error + 1;
            $display("1 ms timer is incorrect");
        end
    end
    
    // end of simulation checks
    initial begin 
        #1000250 if (testbench_error == 0) $display("Test passed!");
        else $display("Test failed with %d errors", testbench_error);
    end
endmodule