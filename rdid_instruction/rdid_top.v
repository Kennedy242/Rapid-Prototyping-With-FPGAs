`timescale 1ns / 1ps
`default_nettype none

module rdid_top(
    input wire CCLK,
    input wire reset_btn,
    input wire get_rdid_btn,
    input wire [1:0] SW,
    input wire SPIMISO,
    output wire SPICLK,
    output wire SPIMOSI,
    output wire chip_select,
    output wire LD0,
    output wire LD1,
    output wire LD2,
    output wire LD3,
    output wire LD4,
    output wire LD5,
    output wire LD6,
    output wire LD7
);

    // Internal signals
    wire get_rdid_debounced;
    wire get_rdid;
    wire get_rdid_oneShot;
    wire reset_sync;
    wire [7:0] manufacture_id;
    wire [7:0] memory_type;
    wire [7:0] memory_capacity;
    wire [7:0] LED;

    // wire CLKDV_OUT;
    // wire CLKIN_IBUFG_OUT;
    // wire CLK0_OUT;

    // Instantiate the clock divider
    // clock_divider clock_divider (
    //     .CLKIN_IN(CCLK), 
    //     .CLKDV_OUT(CLKDV_OUT), 
    //     .CLKIN_IBUFG_OUT(CLKIN_IBUFG_OUT), 
    //     .CLK0_OUT(CLK0_OUT)
    // );

    debounce debounce_get_rdid ( 
        .clk(CCLK),
        .reset(reset_sync),
        .data_in(get_rdid_btn),
        .data_debounced(get_rdid_debounced)
    );
    one_shot one_shot_get_rdid (
        .clk(CCLK),
        .data_in(get_rdid_debounced),
        .data_out(get_rdid_oneShot)
    ); 
    sync get_rdid_sync(
        .clk(CCLK),
        .async_in(get_rdid_oneShot),
        .sync_out(get_rdid)
    );

    reset_sync reset_synchronizer(
        .clk(CCLK),
        .set(reset_btn),
        .data_q(reset_sync)
    );

	spi_master spi_master (
		.reset(reset_sync), 
		.clk(CCLK),
		.get_rdid(get_rdid),
		.SPICLK(SPICLK),
		.SPIMOSI(SPIMOSI),
		.SPIMISO(SPIMISO),
		.chip_select(chip_select),
        .manufacture_id(manufacture_id),
        .memory_type(memory_type),
        .memory_capacity(memory_capacity)
	);

    ledMux ledMux(
        .SW(SW),
        .memory_capacity(memory_capacity),
        .memory_type(memory_type),
        .manufacture_id(manufacture_id),
        .LED(LED)
    );
    assign LD0 = LED[0];
    assign LD1 = LED[1];
    assign LD2 = LED[2];
    assign LD3 = LED[3];
    assign LD4 = LED[4];
    assign LD5 = LED[5];
    assign LD6 = LED[6];
    assign LD7 = LED[7];

endmodule
