`timescale 1ns / 1ps
`default_nettype none

module command_tb();
    
    // Inputs
    reg clk;
    reg reset_btn;
    reg get_rdid_btn;
    reg [1:0] SW;
    
    // Outputs
    wire SPICLK;
    wire SPIMOSI;
    wire [7:0] LED;
    wire LCDE;
    wire LCDRS;
    wire LCDRW;
    wire LCDDAT;
    wire cs_pre_amp_n;
    wire cs_dac_n;
    wire cs_a2d;
    wire cs_parallel_flash_n;
    wire cs_platform_flash;
    wire cs_prom_n;

    // Internal signal
    wire SPIMISO;
    
    // Instantiate the Unit Under Test (UUT)
    command command (
    .CCLK(clk), 
    .reset_btn(reset_btn), 
    .get_rdid_btn(get_rdid_btn), 
    .SPIMISO(SPIMISO), 
    .SW(SW), 
    .SPICLK(SPICLK), 
    .SPIMOSI(SPIMOSI), 
    .LED(LED), 
    .LCDE(LCDE), 
    .LCDRS(LCDRS), 
    .LCDRW(LCDRW), 
    .LCDDAT(LCDDAT), 
    .cs_pre_amp_n(cs_pre_amp_n), 
    .cs_dac_n(cs_dac_n), 
    .cs_a2d(cs_a2d), 
    .cs_parallel_flash_n(cs_parallel_flash_n), 
    .cs_platform_flash(cs_platform_flash), 
    .cs_prom_n(cs_prom_n)
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
        forever #10 clk = ~clk; // 50Mhz
    end
    
    reg reset_button_push = 0;
    reg rdid_button_push = 0;
    integer i;

    // Stimulus for UUT
    initial begin
        // Initialize inputs
        reset_btn = 0;
        get_rdid_btn = 0;
        SW = 2'b00;
        
        // Wait 100 ns for global reset to finish
        #100;

        // Start stimulus
        // simulate bouncing
        #200 reset_button_push = 1;
        reset_btn = 1;
        for (i=0; i<10; i = i + 1) begin
            #80 reset_btn = ~reset_btn;
        end

        #1400000 reset_btn = 0;
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
    end
    
    // self checking testbench
    integer testbench_error = 0;
    reg test_signal = 0;
    
    initial begin
        #10 $display("*************** test begin *******************");
        #2934550 test_signal = ~test_signal;
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
            if(command.data_to_write != 256'h4341503d307831352049443d30783230545950453d3078323000000000000000) begin
                $display("data_to_write is incorrect. Actual value: ", command.data_to_write);
                testbench_error = testbench_error + 1;
            end
    end
    
    // end of simulation checks
    initial begin 
        #5000000 if (testbench_error == 0) $display("Test passed!");
        else $display("Test failed with %d errors", testbench_error);
    end
endmodule
