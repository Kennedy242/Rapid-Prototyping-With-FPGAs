`timescale 1ns / 1ps
`default_nettype none
////////////////////////////////////////////////////////////////////////////////
//
// Design Name:   spi_master_fsm
// Project Name:  spi_master
//
// Verilog Test Fixture created by ISE for module: spi_master_fsm
//
////////////////////////////////////////////////////////////////////////////////

module spi_master_tb;

	// Inputs
	reg reset;
	reg clk;
	reg get_rdid;

	// SPI bus
	wire SPICLK;
	wire SPIMOSI;
	wire SPIMISO;
	wire chip_select;

	// Instantiate the Units Under Test (UUT)
	spi_master spi_master (
		.reset(reset), 
		.clk(clk),
		.get_rdid(get_rdid),
		.SPICLK(SPICLK),
		.SPIMOSI(SPIMOSI),
		.SPIMISO(SPIMISO),
		.chip_select(chip_select)
	);

	m25p16 m25p16(
		.c(SPICLK),
		.data_in(SPIMOSI),
		.s(chip_select),
		.w(1'b1),
		.hold(1'b0),
		.data_out(SPIMISO)
	);

	// system clock
	always begin 
		clk = 1'b0;
		forever #5 clk = ~clk;
	end

	initial begin
		// Initialize Inputs
		reset = 1;
		get_rdid = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		reset = 0;
		get_rdid = 1;

		#10 get_rdid = 0;
	end

	// self checking testbench
	integer testbench_error = 0;
	initial begin
		#10 $display("*************** test begin *******************");

		#115 if(SPIMOSI != 1) begin $display( "RDID[7] failed"); testbench_error = testbench_error + 1; end
		#20 if(SPIMOSI != 0) begin $display( "RDID[6] failed"); testbench_error = testbench_error + 1; end
		#20 if(SPIMOSI != 0) begin $display( "RDID[5] failed"); testbench_error = testbench_error + 1; end
		#20 if(SPIMOSI != 1) begin $display( "RDID[4] failed"); testbench_error = testbench_error + 1; end
		#20 if(SPIMOSI != 1) begin $display( "RDID[3] failed"); testbench_error = testbench_error + 1; end
		#20 if(SPIMOSI != 1) begin $display( "RDID[2] failed"); testbench_error = testbench_error + 1; end
		#20 if(SPIMOSI != 1) begin $display( "RDID[1] failed"); testbench_error = testbench_error + 1; end
		#20 if(SPIMOSI != 1) begin $display( "RDID[0] failed"); testbench_error = testbench_error + 1; end


		#20 if(SPIMISO != 0) begin $display( "manufacture ID [7] failed"); testbench_error = testbench_error + 1; end
		#20 if(SPIMISO != 0) begin $display( "manufacture ID [6] failed"); testbench_error = testbench_error + 1; end
		#20 if(SPIMISO != 1) begin $display( "manufacture ID [5] failed"); testbench_error = testbench_error + 1; end
		#20 if(SPIMISO != 0) begin $display( "manufacture ID [4] failed"); testbench_error = testbench_error + 1; end
		#20 if(SPIMISO != 0) begin $display( "manufacture ID [3] failed"); testbench_error = testbench_error + 1; end
		#20 if(SPIMISO != 0) begin $display( "manufacture ID [2] failed"); testbench_error = testbench_error + 1; end
		#20 if(SPIMISO != 0) begin $display( "manufacture ID [1] failed"); testbench_error = testbench_error + 1; end
		#20 if(SPIMISO != 0) begin $display( "manufacture ID [0] failed"); testbench_error = testbench_error + 1; end

		#20 if(SPIMISO != 0) begin $display( "memory type [7] failed"); testbench_error = testbench_error + 1; end
		#20 if(SPIMISO != 0) begin $display( "memory type [6] failed"); testbench_error = testbench_error + 1; end
		#20 if(SPIMISO != 1) begin $display( "memory type [5] failed"); testbench_error = testbench_error + 1; end
		#20 if(SPIMISO != 0) begin $display( "memory type [4] failed"); testbench_error = testbench_error + 1; end
		#20 if(SPIMISO != 0) begin $display( "memory type [3] failed"); testbench_error = testbench_error + 1; end
		#20 if(SPIMISO != 0) begin $display( "memory type [2] failed"); testbench_error = testbench_error + 1; end
		#20 if(SPIMISO != 0) begin $display( "memory type [1] failed"); testbench_error = testbench_error + 1; end
		#20 if(SPIMISO != 0) begin $display( "memory type [0] failed"); testbench_error = testbench_error + 1; end

		#20 if(SPIMISO != 0) begin $display( "memory cap [7] failed"); testbench_error = testbench_error + 1; end
		#20 if(SPIMISO != 0) begin $display( "memory cap [6] failed"); testbench_error = testbench_error + 1; end
		#20 if(SPIMISO != 0) begin $display( "memory cap [5] failed"); testbench_error = testbench_error + 1; end
		#20 if(SPIMISO != 1) begin $display( "memory cap [4] failed"); testbench_error = testbench_error + 1; end
		#20 if(SPIMISO != 0) begin $display( "memory cap [3] failed"); testbench_error = testbench_error + 1; end
		#20 if(SPIMISO != 1) begin $display( "memory cap [2] failed"); testbench_error = testbench_error + 1; end
		#20 if(SPIMISO != 0) begin $display( "memory cap [1] failed"); testbench_error = testbench_error + 1; end
		#20 if(SPIMISO != 1) begin $display( "memory cap [0] failed"); testbench_error = testbench_error + 1; end
	end

	reg [5:0] SPICLK_edges = -1;
	always begin
		@(posedge SPICLK) begin
			SPICLK_edges <= SPICLK_edges + 1;
		end
	end
	initial begin
		#800 if(SPICLK_edges != 31) $display ( "spi clks expected 31 edges, actual: %d", SPICLK_edges);
		if (testbench_error == 0) $display("Test passed!");
	end
endmodule

