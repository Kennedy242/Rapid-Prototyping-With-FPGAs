`timescale 1ns / 1ps
`default_nettype none

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
		forever #10 clk = ~clk;
	end

	// Stimulus for spi_master UUT
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
	integer testbench_error = 0;

	// Set to -1 so that on the first clock
	// edge, the counter will show 0
	// to align with timing diagram
	reg [5:0] SPICLK_edges = -1;
	always begin
		@(posedge SPICLK) begin
			SPICLK_edges <= SPICLK_edges + 1;
		end
	end

	initial begin
		#10 $display("*************** test begin *******************");
		 $display("--------------- checking first instruction -------------------");

		#140 if(SPIMOSI !== 1) begin
			 $display( "RDID[7] failed");
			 testbench_error = testbench_error + 1;
			end
		#40 if(SPIMOSI !== 0) begin
			 $display( "RDID[6] failed");
			 testbench_error = testbench_error + 1;
			end
		#40 if(SPIMOSI !== 0) begin
			 $display( "RDID[5] failed");
			 testbench_error = testbench_error + 1;
			end
		#40 if(SPIMOSI !== 1) begin
			 $display( "RDID[4] failed");
			 testbench_error = testbench_error + 1;
			end
		#40 if(SPIMOSI !== 1) begin
			 $display( "RDID[3] failed");
			 testbench_error = testbench_error + 1;
			end
		#40 if(SPIMOSI !== 1) begin
			 $display( "RDID[2] failed");
			 testbench_error = testbench_error + 1;
			end
		#40 if(SPIMOSI !== 1) begin
			 $display( "RDID[1] failed");
			 testbench_error = testbench_error + 1;
			end
		#40 if(SPIMOSI !== 1) begin
			 $display( "RDID[0] failed");
			 testbench_error = testbench_error + 1;
			end

		#40 if(SPIMISO !== 0) begin
			 $display( "manufacture ID [7] failed");
			 testbench_error = testbench_error + 1;
			end
		#40 if(SPIMISO !== 0) begin
			 $display( "manufacture ID [6] failed");
			 testbench_error = testbench_error + 1;
			end
		#40 if(SPIMISO !== 1) begin
			 $display( "manufacture ID [5] failed");
			 testbench_error = testbench_error + 1;
			end
		#40 if(SPIMISO !== 0) begin
			 $display( "manufacture ID [4] failed");
			 testbench_error = testbench_error + 1;
			end
		#40 if(SPIMISO !== 0) begin
			 $display( "manufacture ID [3] failed");
			 testbench_error = testbench_error + 1;
			end
		#40 if(SPIMISO !== 0) begin
			 $display( "manufacture ID [2] failed");
			 testbench_error = testbench_error + 1;
			end
		#40 if(SPIMISO !== 0) begin
			 $display( "manufacture ID [1] failed");
			 testbench_error = testbench_error + 1;
			end
		#40 if(SPIMISO !== 0) begin
			 $display( "manufacture ID [0] failed");
			 testbench_error = testbench_error + 1;
			end

		#40 if(SPIMISO !== 0) begin
			 $display( "memory type [7] failed");
			 testbench_error = testbench_error + 1;
			end
		#40 if(SPIMISO !== 0) begin
			 $display( "memory type [6] failed");
			 testbench_error = testbench_error + 1;
			end
		#40 if(SPIMISO !== 1) begin
			 $display( "memory type [5] failed");
			 testbench_error = testbench_error + 1;
			end
		#40 if(SPIMISO !== 0) begin
			 $display( "memory type [4] failed");
			 testbench_error = testbench_error + 1;
			end
		#40 if(SPIMISO !== 0) begin
			 $display( "memory type [3] failed");
			 testbench_error = testbench_error + 1;
			end
		#40 if(SPIMISO !== 0) begin
			 $display( "memory type [2] failed");
			 testbench_error = testbench_error + 1;
			end
		#40 if(SPIMISO !== 0) begin
			 $display( "memory type [1] failed");
			 testbench_error = testbench_error + 1;
			end
		#40 if(SPIMISO !== 0) begin
			 $display( "memory type [0] failed");
			 testbench_error = testbench_error + 1;
			end

		#40 if(SPIMISO !== 0) begin
			 $display( "memory cap [7] failed");
			 testbench_error = testbench_error + 1;
			end
		#40 if(SPIMISO !== 0) begin
			 $display( "memory cap [6] failed");
			 testbench_error = testbench_error + 1;
			end
		#40 if(SPIMISO !== 0) begin
			 $display( "memory cap [5] failed");
			 testbench_error = testbench_error + 1;
			end
		#40 if(SPIMISO !== 1) begin
			 $display( "memory cap [4] failed");
			 testbench_error = testbench_error + 1;
			end
		#40 if(SPIMISO !== 0) begin
			 $display( "memory cap [3] failed");
			 testbench_error = testbench_error + 1;
			end
		#40 if(SPIMISO !== 1) begin
			 $display( "memory cap [2] failed");
			 testbench_error = testbench_error + 1;
			end
		#40 if(SPIMISO !== 0) begin
			 $display( "memory cap [1] failed");
			 testbench_error = testbench_error + 1;
			end
		#40 if(SPIMISO !== 1) begin
			 $display( "memory cap [0] failed");
			 testbench_error = testbench_error + 1;
			end
	end

	// end of instruction checks
	initial begin
		#1400 if(SPICLK_edges !== 31) begin
			$display("spi clks expected 31 edges, actual: %d", SPICLK_edges);
			testbench_error = testbench_error + 1;
			end
			if(spi_master.read_data !== 24'h202015) begin
				$display("read_data expected to be 0x202015. Actual %h", spi_master.read_data);
				testbench_error = testbench_error + 1;
			end
			if(spi_master.manufacture_id !== 8'h20) begin
				$display("manufacture_id expected to be 0x20. Actual %h", spi_master.manufacture_id);
				testbench_error = testbench_error + 1;
			end
			if(spi_master.memory_type !== 8'h20) begin
				$display("memory_type expected to be 0x20. Actual %h", spi_master.memory_type);
				testbench_error = testbench_error + 1;
			end
			if(spi_master.memory_capacity !== 8'h15) begin
				$display("memory_capacity expected to be 0x15. Actual %h", spi_master.memory_capacity);
				testbench_error = testbench_error + 1;
			end
	end


	// send instruction again
	initial begin
		#1600 get_rdid = 1;
		SPICLK_edges = -1;
		#20 get_rdid = 0;
	end

	initial begin
		#1650 
			$display("--------------- checking second instruction -------------------");
			if(SPIMOSI !== 1) begin
				$display( "RDID[7] failed");
				testbench_error = testbench_error + 1;
			end
		#40 if(SPIMOSI !== 0) begin
			 $display( "RDID[6] failed");
			 testbench_error = testbench_error + 1;
			end
		#40 if(SPIMOSI !== 0) begin
			 $display( "RDID[5] failed");
			 testbench_error = testbench_error + 1;
			end
		#40 if(SPIMOSI !== 1) begin
			 $display( "RDID[4] failed");
			 testbench_error = testbench_error + 1;
			end
		#40 if(SPIMOSI !== 1) begin
			 $display( "RDID[3] failed");
			 testbench_error = testbench_error + 1;
			end
		#40 if(SPIMOSI !== 1) begin
			 $display( "RDID[2] failed");
			 testbench_error = testbench_error + 1;
			end
		#40 if(SPIMOSI !== 1) begin
			 $display( "RDID[1] failed");
			 testbench_error = testbench_error + 1;
			end
		#40 if(SPIMOSI !== 1) begin
			 $display( "RDID[0] failed");
			 testbench_error = testbench_error + 1;
			end

		#40 if(SPIMISO !== 0) begin
			 $display( "manufacture ID [7] failed");
			 testbench_error = testbench_error + 1;
			end
		#40 if(SPIMISO !== 0) begin
			 $display( "manufacture ID [6] failed");
			 testbench_error = testbench_error + 1;
			end
		#40 if(SPIMISO !== 1) begin
			 $display( "manufacture ID [5] failed");
			 testbench_error = testbench_error + 1;
			end
		#40 if(SPIMISO !== 0) begin
			 $display( "manufacture ID [4] failed");
			 testbench_error = testbench_error + 1;
			end
		#40 if(SPIMISO !== 0) begin
			 $display( "manufacture ID [3] failed");
			 testbench_error = testbench_error + 1;
			end
		#40 if(SPIMISO !== 0) begin
			 $display( "manufacture ID [2] failed");
			 testbench_error = testbench_error + 1;
			end
		#40 if(SPIMISO !== 0) begin
			 $display( "manufacture ID [1] failed");
			 testbench_error = testbench_error + 1;
			end
		#40 if(SPIMISO !== 0) begin
			 $display( "manufacture ID [0] failed");
			 testbench_error = testbench_error + 1;
			end

		#40 if(SPIMISO !== 0) begin
			 $display( "memory type [7] failed");
			 testbench_error = testbench_error + 1;
			end
		#40 if(SPIMISO !== 0) begin
			 $display( "memory type [6] failed");
			 testbench_error = testbench_error + 1;
			end
		#40 if(SPIMISO !== 1) begin
			 $display( "memory type [5] failed");
			 testbench_error = testbench_error + 1;
			end
		#40 if(SPIMISO !== 0) begin
			 $display( "memory type [4] failed");
			 testbench_error = testbench_error + 1;
			end
		#40 if(SPIMISO !== 0) begin
			 $display( "memory type [3] failed");
			 testbench_error = testbench_error + 1;
			end
		#40 if(SPIMISO !== 0) begin
			 $display( "memory type [2] failed");
			 testbench_error = testbench_error + 1;
			end
		#40 if(SPIMISO !== 0) begin
			 $display( "memory type [1] failed");
			 testbench_error = testbench_error + 1;
			end
		#40 if(SPIMISO !== 0) begin
			 $display( "memory type [0] failed");
			 testbench_error = testbench_error + 1;
			end

		#40 if(SPIMISO !== 0) begin
			 $display( "memory cap [7] failed");
			 testbench_error = testbench_error + 1;
			end
		#40 if(SPIMISO !== 0) begin
			 $display( "memory cap [6] failed");
			 testbench_error = testbench_error + 1;
			end
		#40 if(SPIMISO !== 0) begin
			 $display( "memory cap [5] failed");
			 testbench_error = testbench_error + 1;
			end
		#40 if(SPIMISO !== 1) begin
			 $display( "memory cap [4] failed");
			 testbench_error = testbench_error + 1;
			end
		#40 if(SPIMISO !== 0) begin
			 $display( "memory cap [3] failed");
			 testbench_error = testbench_error + 1;
			end
		#40 if(SPIMISO !== 1) begin
			 $display( "memory cap [2] failed");
			 testbench_error = testbench_error + 1;
			end
		#40 if(SPIMISO !== 0) begin
			 $display( "memory cap [1] failed");
			 testbench_error = testbench_error + 1;
			end
		#40 if(SPIMISO !== 1) begin
			 $display( "memory cap [0] failed");
			 testbench_error = testbench_error + 1;
			end
	end


	// end of simulation checks
	initial begin 
		#3000 if (testbench_error == 0) $display("Test passed!");
		else $display("Test failed with %d errors", testbench_error);
	end
endmodule
