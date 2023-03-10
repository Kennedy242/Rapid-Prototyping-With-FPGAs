`timescale 1ns / 1ps
`default_nettype none

module rdid_top(
    input wire CCLK, //Crystal Clock Oscillator
    input wire reset_btn,
    input wire get_rdid_btn,
    input wire SW0,
    input wire SW1,
    input wire SPIMISO,
    output wire SPICLK,
    output wire SPIMOSI,
    output wire cs_prom_n,
    output wire LD0,
    output wire LD1,
    output wire LD2,
    output wire LD3,
    output wire LD4,
    output wire LD5,
    output wire LD6,
    output wire LD7,
    output wire cs_pre_amp_n,
    output wire cs_dac_n,
    output wire cs_a2d,
    output wire cs_parallel_flash_n,
    output wire cs_platform_flash
);

    // Internal signals
    wire get_rdid_debounced;
    wire get_rdid_oneShot;
    wire get_rdid;
    wire reset_debounced;
    wire reset;
    wire clk;
    wire [7:0] manufacture_id;
    wire [7:0] memory_type;
    wire [7:0] memory_capacity;
    wire [7:0] LED;

    // FPGA NETs SPI Bus
    assign cs_pre_amp_n = 1;
    assign cs_dac_n = 1;
    assign cs_a2d = 0;
    assign cs_parallel_flash_n = 1;
    assign cs_platform_flash = 0;

    // debugging signal
    wire [35:0] CONTROL;

    // DCM designed from Xilinx tools
    clock_divider clock_divider (
        .CLKIN_IN(CCLK),
        .CLKDV_OUT(clk)
    );

    debounce debounce_get_rdid ( 
        .clk(clk),
        .data_in(get_rdid_btn),
        .data_debounced(get_rdid_debounced)
    );
    one_shot one_shot_get_rdid (
        .clk(clk),
        .data_in(get_rdid_debounced),
        .data_out(get_rdid_oneShot)
    ); 
    sync get_rdid_sync(
        .clk(clk),
        .async_in(get_rdid_oneShot),
        .sync_out(get_rdid)
    );

    debounce debounce_reset ( 
        .clk(clk),
        .data_in(reset_btn),
        .data_debounced(reset_debounced)
    );
    sync reset_sync(
        .clk(clk),
        .async_in(reset_debounced),
        .sync_out(reset)
    );

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
        .SW0(SW0),
        .SW1(SW1),
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

    icon icon (
    .CONTROL0(CONTROL)
    );
    ila ila (
        .CONTROL(CONTROL),
        .CLK(clk),
        .TRIG0({
            get_rdid,
            SPICLK,
            SPIMISO,
            SPIMOSI,
            cs_prom_n,
            memory_capacity[2],
            memory_capacity[1],
            memory_capacity[0]
        })
    );


endmodule
