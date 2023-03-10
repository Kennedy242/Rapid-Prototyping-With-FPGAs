`timescale 1ns / 1ps
`default_nettype none

module rdid(
    input wire clk,
    input wire reset,
    input wire get_rdid,
    input wire [1:0] SW,
    input wire SPIMISO,
    output wire SPICLK,
    output wire SPIMOSI,
    output wire cs_prom_n,
    output wire [7:0] LED
);

    // Internal signals
    wire [7:0] manufacture_id;
    wire [7:0] memory_type;
    wire [7:0] memory_capacity;

	spi_master spi_master (
		.reset(reset), 
		.clk(clk),
		.get_rdid(get_rdid),
		.SPICLK(SPICLK),
		.SPIMOSI(SPIMOSI),
		.SPIMISO(SPIMISO),
		.chip_select(cs_prom_n),
        .manufacture_id(manufacture_id),
        .memory_type(memory_type),
        .memory_capacity(memory_capacity)
	);

    ledMux ledMux(
        .reset(reset),
        .SW(SW),
        .memory_capacity(memory_capacity),
        .memory_type(memory_type),
        .manufacture_id(manufacture_id),
        .LED(LED)
    );

endmodule
