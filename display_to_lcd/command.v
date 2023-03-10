`timescale 1ns / 1ps
`default_nettype none

module command(
    input wire CCLK,
    input wire reset_btn,
    input wire get_rdid_btn,
    input wire SPIMISO,
    input wire [1:0] SW,
    output wire SPICLK,
    output wire SPIMOSI,
    output wire [7:0] LED,
    output wire LCDE,
    output wire LCDRS,
    output wire LCDRW,
    output wire LCDDAT,
    output wire cs_pre_amp_n,
    output wire cs_dac_n,
    output wire cs_a2d,
    output wire cs_parallel_flash_n,
    output wire cs_platform_flash,
    output wire cs_prom_n
    );

    // internal signals
    wire get_rdid_debounced;
    wire get_rdid_oneShot;
    wire get_rdid;
    wire reset_debounced;
    wire reset;
    wire clk;

    // FPGA NETs SPI Bus
    assign cs_pre_amp_n = 1;
    assign cs_dac_n = 1;
    assign cs_a2d = 0;
    assign cs_parallel_flash_n = 1;
    assign cs_platform_flash = 0;

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

    rdid rdid (
    .clk(clk), 
    .reset(reset), 
    .get_rdid(get_rdid), 
    .SW(SW), 
    .SPIMISO(SPIMISO), 
    .SPICLK(SPICLK), 
    .SPIMOSI(SPIMOSI), 
    .cs_prom_n(cs_prom_n), 
    .LED(LED)
    );

// transaction transaction (
//     .clk(clk), 
//     .reset(reset), 
//     .do_write_data(do_write_data), 
//     .data_to_write(data_to_write), 
//     .do_set_dd_ram_addr(do_set_dd_ram_addr), 
//     .dd_ram_addr(dd_ram_addr), 
//     .LCDE_q(LCDE_q), 
//     .LCDRS_q(LCDRS_q), 
//     .LCDRW_q(LCDRW_q), 
//     .LCDDAT_q(LCDDAT_q), 
//     .set_dd_ram_addr_done(set_dd_ram_addr_done), 
//     .send_data_done(send_data_done)
//     );

endmodule
