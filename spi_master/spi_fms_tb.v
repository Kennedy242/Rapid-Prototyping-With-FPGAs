`timescale 1ns / 1ps

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

	// Instantiate the Unit Under Test (UUT)
	spi_master uut (
		.reset(reset), 
		.clk(clk),
		.get_rdid(get_rdid),
		.SPICLK(SPICLK),
		.SPIMOSI(SPIMOSI),
		.SPIMISO(SPIMISO)
	);

	always begin 
		clk = 1'b0;
		forever #10 clk = ~clk;
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

		#20 get_rdid = 0;
	end

	// self checking testbench
	initial begin
		#10 $display("*************** test begin *******************");
		#140 if(SPIMOSI != 1) $display( "RDID[7] failed");
		#20 if(SPIMOSI != 0) $display( "RDID[6] failed");
		#20 if(SPIMOSI != 0) $display( "RDID[5] failed");
		#20 if(SPIMOSI != 1) $display( "RDID[4] failed");
		#20 if(SPIMOSI != 1) $display( "RDID[3] failed");
		#20 if(SPIMOSI != 1) $display( "RDID[2] failed");
		#20 if(SPIMOSI != 1) $display( "RDID[1] failed");
		#20 if(SPIMOSI != 1) $display( "RDID[0] failed");
		$display("*************** test end *******************");
	end
endmodule

