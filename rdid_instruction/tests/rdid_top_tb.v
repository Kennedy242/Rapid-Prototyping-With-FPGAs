`timescale 1ns / 1ps
`default_nettype none

module rdid_top_tb();
    
    // Inputs
    reg clk;
    reg reset_btn;
    reg get_rdid_btn;
    reg [1:0] SW;
    wire SPIMISO;
    
    // Outputs
    wire SPIMOSI;
    wire chip_select;
    wire SPICLK;
    wire LD0;
    wire LD1;
    wire LD2;
    wire LD3;
    wire LD4;
    wire LD5;
    wire LD6;
    wire LD7;

    // Test signals
    reg reset_button_push; 
    reg rdid_button_push;
    integer i;

    // Instantiate the Unit Under Test (UUT)
    rdid_top rdid_top(
        .CCLK(clk),
        .reset_btn(reset_btn),
        .get_rdid_btn(get_rdid_btn),
        .SW(SW),
        .SPIMISO(SPIMISO),
        .SPICLK(SPICLK),
        .SPIMOSI(SPIMOSI),
        .chip_select(chip_select),
        .LD0(LD0),
        .LD1(LD1),
        .LD2(LD2),
        .LD3(LD3),
        .LD4(LD4),
        .LD5(LD5),
        .LD6(LD6),
        .LD7(LD7)
    );

    m25p16 m25p16(
		.c(SPICLK),
		.data_in(SPIMOSI),
		.s(chip_select),
		.w(1'b1),
		.hold(1'b0),
		.data_out(SPIMISO)
	);
    
    // System clock
    always begin 
        clk = 1'b0;
        forever #10 clk = ~clk;
    end
    
    // Stimulus for UUT
    initial begin
        // Initialize inputs
        reset_btn = 0;
        get_rdid_btn = 0;
        SW = 2'b00;
        reset_button_push = 0;
        rdid_button_push = 0;
        
        // Wait 100 ns for global reset to finish
        #100;
        
        // Start stimulus
        // simulate bouncing
        #200 reset_button_push = 1;
        reset_btn = 1;
        for (i=0; i<10; i = i + 1) begin
            #0.5 reset_btn = ~reset_btn;
        end

        #1310900 reset_btn = 0;
         for (i=0; i<8; i = i + 1) begin
            #0.5 reset_btn = ~reset_btn;
        end
        reset_button_push = 0;
        // end of simulated bounce

        // simulate bouncing
        #200000 rdid_button_push = 1;
        get_rdid_btn = 1;
        for (i=0; i<10; i = i + 1) begin
            #0.5 get_rdid_btn = ~get_rdid_btn;
        end

        #1310900 get_rdid_btn = 0;
        for (i=0; i<8; i = i + 1) begin
            #0.5 get_rdid_btn = ~get_rdid_btn;
        end
        // end of simulated bounce


        // Another RDID assertion
        // simulate bouncing
        #2000000  rdid_button_push = 1;
        get_rdid_btn = 1;
        for (i=0; i<10; i = i + 1) begin
            #0.5 get_rdid_btn = ~get_rdid_btn;
        end

        #1310900 get_rdid_btn = 0;
        for (i=0; i<8; i = i + 1) begin
            #0.5 get_rdid_btn = ~get_rdid_btn;
        end
        rdid_button_push = 0;
        // end of simulated bounce
    end
    
    // self checking testbench
    integer testbench_error = 0;
    reg test_signal = 0;
    
    initial begin
        #10 $display("*************** test begin *******************");
        #2823240 $display( "INFO: first  rdid check" );
            test_signal = ~test_signal;
            if(rdid_top.ledMux.LED !== 8'h15) begin
                $display( "mem cap LED failed. Expected 0x15 Actual %h", rdid_top.ledMux.LED );
                testbench_error = testbench_error + 1;
			end
        #10 SW = 2'b01;
        #10 test_signal = ~test_signal;
            if(rdid_top.ledMux.LED !== 8'h20) begin
                $display( "mem type LED failed. Expected 0x20 Actual %h", rdid_top.ledMux.LED );
                testbench_error = testbench_error + 1;
			end
        #10 SW = 2'b10;
        #10 test_signal = ~test_signal;
            if(rdid_top.ledMux.LED !== 8'h20) begin
                $display( "man ID LED failed. Expected 0x20 Actual %h", rdid_top.ledMux.LED );
                testbench_error = testbench_error + 1;
			end
        #10 SW = 2'b11;
        #10 test_signal = ~test_signal;
            if(rdid_top.ledMux.LED !== 8'hFF) begin
                $display( "default case LED failed. Expected 0xFF Actual %h", rdid_top.ledMux.LED );
                testbench_error = testbench_error + 1;
			end
        #3312335
            $display( "INFO: second rdid check" );
            SW = 2'b00;
        #10 test_signal = ~test_signal; 
            if(rdid_top.ledMux.LED !== 8'h15) begin
                $display( "mem cap LED failed. Expected 0x15 Actual %h", rdid_top.ledMux.LED );
                testbench_error = testbench_error + 1;
			end
        #10 SW = 2'b01;
        #10 test_signal = ~test_signal;
            if(rdid_top.ledMux.LED !== 8'h20) begin
                $display( "mem type LED failed. Expected 0x20 Actual %h", rdid_top.ledMux.LED );
                testbench_error = testbench_error + 1;
			end
        #10 SW = 2'b10;
        #10 test_signal = ~test_signal;
            if(rdid_top.ledMux.LED !== 8'h20) begin
                $display( "man ID LED failed. Expected 0x20 Actual %h", rdid_top.ledMux.LED );
                testbench_error = testbench_error + 1;
			end
        #10 SW = 2'b11;
        #10 test_signal = ~test_signal;
            if(rdid_top.ledMux.LED !== 8'hFF) begin
                $display( "default case LED failed. Expected 0xFF Actual %h", rdid_top.ledMux.LED );
                testbench_error = testbench_error + 1;
			end
    end
    
    // end of simulation checks
    initial begin 
        #6500000 if (testbench_error == 0) $display("Test passed!");
        else $display("Test failed with %d errors", testbench_error);
    end
endmodule