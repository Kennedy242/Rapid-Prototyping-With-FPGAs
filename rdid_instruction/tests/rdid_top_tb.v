`timescale 1ns / 1ps
`default_nettype none

module rdid_top_tb();
    
    // Inputs
    reg clk;
    reg reset_btn;
    reg get_rdid_btn;
    reg SW0;
    reg SW1;
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
    wire cs_pre_amp_n;
    wire cs_dac_n;
    wire cs_a2d;
    wire cs_parallel_flash_n;
    wire cs_platform_flash;

    // Test signals
    reg reset_button_push; 
    reg rdid_button_push;
    integer i;

    // Instantiate the Unit Under Test (UUT)
    rdid_top rdid_top(
        .CCLK(clk),
        .reset_btn(reset_btn),
        .get_rdid_btn(get_rdid_btn),
        .SW0(SW0),
        .SW1(SW1),
        .SPIMISO(SPIMISO),
        .SPICLK(SPICLK),
        .SPIMOSI(SPIMOSI),
        .cs_prom_n(chip_select),
        .LD0(LD0),
        .LD1(LD1),
        .LD2(LD2),
        .LD3(LD3),
        .LD4(LD4),
        .LD5(LD5),
        .LD6(LD6),
        .LD7(LD7),
        .cs_pre_amp_n(cs_pre_amp_n),
        .cs_dac_n(cs_dac_n),
        .cs_a2d(cs_a2d),
        .cs_parallel_flash_n(cs_parallel_flash_n),
        .cs_platform_flash(cs_platform_flash)
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
        {SW1,SW0} = 2'b00;
        reset_button_push = 0;
        rdid_button_push = 0;
        
        // Wait 100 ns for global reset to finish
        #100;
        
        // Start stimulus
        // simulate bouncing
        #200 reset_button_push = 1;
        reset_btn = 1;
        for (i=0; i<10; i = i + 1) begin
            #80 reset_btn = ~reset_btn;
        end

        #81931 reset_btn = 0;
         for (i=0; i<8; i = i + 1) begin
            #80 reset_btn = ~reset_btn;
        end
        reset_button_push = 0;
        // end of simulated bounce

        // simulate bouncing
        #200000 rdid_button_push = 1;
        get_rdid_btn = 1;
        for (i=0; i<10; i = i + 1) begin
            #80 get_rdid_btn = ~get_rdid_btn;
        end

        #1310900 get_rdid_btn = 0;
        for (i=0; i<8; i = i + 1) begin
            #80 get_rdid_btn = ~get_rdid_btn;
        end
        rdid_button_push = 0;
        // end of simulated bounce


        // Another RDID assertion
        // simulate bouncing
        #2000000  rdid_button_push = 1;
        get_rdid_btn = 1;
        for (i=0; i<10; i = i + 1) begin
            #80 get_rdid_btn = ~get_rdid_btn;
        end

        #1310900 get_rdid_btn = 0;
        for (i=0; i<8; i = i + 1) begin
            #80 get_rdid_btn = ~get_rdid_btn;
        end
        rdid_button_push = 0;
        // end of simulated bounce

        // simulate bouncing
        #500000 reset_button_push = 1;
        reset_btn = 1;
        for (i=0; i<10; i = i + 1) begin
            #80 reset_btn = ~reset_btn;
        end

        #1310900 reset_btn = 0;
         for (i=0; i<8; i = i + 1) begin
            #80 reset_btn = ~reset_btn;
        end
        reset_button_push = 0;
        // end of simulated bounce
    end
    
    // self checking testbench
    integer testbench_error = 0;
    reg test_signal = 0;
    
    initial begin
        #10 $display("*************** test begin *******************");
        #1615900 $display( "INFO: first  rdid test" );
            test_signal = ~test_signal;
            if(rdid_top.ledMux.LED !== 8'h15) begin
                $display( "mem cap LED failed. Expected 0x15 Actual %h", rdid_top.ledMux.LED );
                testbench_error = testbench_error + 1;
			end
        #160 {SW1,SW0} = 2'b01;
        #160 test_signal = ~test_signal;
            if(rdid_top.ledMux.LED !== 8'h20) begin
                $display( "mem type LED failed. Expected 0x20 Actual %h", rdid_top.ledMux.LED );
                testbench_error = testbench_error + 1;
			end
        #160 {SW1,SW0} = 2'b10;
        #160 test_signal = ~test_signal;
            if(rdid_top.ledMux.LED !== 8'h20) begin
                $display( "man ID LED failed. Expected 0x20 Actual %h", rdid_top.ledMux.LED );
                testbench_error = testbench_error + 1;
			end
        #160 {SW1,SW0} = 2'b11;
        #160 test_signal = ~test_signal;
            if(rdid_top.ledMux.LED !== 8'hFF) begin
                $display( "default case LED failed. Expected 0xFF Actual %h", rdid_top.ledMux.LED );
                testbench_error = testbench_error + 1;
			end
    end
    initial begin
        #4930100
            $display( "INFO: second rdid test" );
            {SW1,SW0} = 2'b00;
        #10 test_signal = ~test_signal; 
            if(rdid_top.ledMux.LED !== 8'h15) begin
                $display( "mem cap LED failed. Expected 0x15 Actual %h", rdid_top.ledMux.LED );
                testbench_error = testbench_error + 1;
			end
        #10 {SW1,SW0} = 2'b01;
        #10 test_signal = ~test_signal;
            if(rdid_top.ledMux.LED !== 8'h20) begin
                $display( "mem type LED failed. Expected 0x20 Actual %h", rdid_top.ledMux.LED );
                testbench_error = testbench_error + 1;
			end
        #10 {SW1,SW0} = 2'b10;
        #10 test_signal = ~test_signal;
            if(rdid_top.ledMux.LED !== 8'h20) begin
                $display( "man ID LED failed. Expected 0x20 Actual %h", rdid_top.ledMux.LED );
                testbench_error = testbench_error + 1;
			end
        #10 {SW1,SW0} = 2'b11;
        #10 test_signal = ~test_signal;
            if(rdid_top.ledMux.LED !== 8'hFF) begin
                $display( "default case LED failed. Expected 0xFF Actual %h", rdid_top.ledMux.LED );
                testbench_error = testbench_error + 1;
			end
    end


    initial begin
    #8000000 $display( "INFO: Clear LEDs test" );
            test_signal = ~test_signal;
            if(rdid_top.ledMux.LED !== 8'h00) begin
                $display( "reset case LED failed. Expected 0x00 Actual %h", rdid_top.ledMux.LED );
                testbench_error = testbench_error + 1;
			end
    #1393000 test_signal = ~test_signal;
        if(rdid_top.ledMux.LED !== 8'hff) begin
            $display( "default case LED failed. Expected 0xff Actual %h", rdid_top.ledMux.LED );
            testbench_error = testbench_error + 1;
        end
    end
    
    // end of simulation checks
    initial begin 
        #10000000 if (testbench_error == 0) $display("Test passed!");
        else $display("Test failed with %d errors", testbench_error);
    end
endmodule