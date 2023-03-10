`timescale 1ns / 1ps
`default_nettype none

module transaction(
    input clk,
    input reset,
    input do_write_data,
    input data_to_write,
    input do_set_dd_ram_addr,
    input dd_ram_addr,
    output LCDE_q,
    output LCDRS_q,
    output LCDRW_q,
    output LCDDAT_q,
    output set_dd_ram_addr_done,
    output send_data_done
    );

    // physical physical (
    // .clk(clk), 
    // .reset(reset), 
    // .do_init(do_init), 
    // .do_send_data(do_send_data), 
    // .data_to_send(data_to_send), 
    // .lcdrs_in(lcdrs_in), 
    // .init_done(init_done), 
    // .lcde(lcde), 
    // .lcdrd(lcdrd), 
    // .lcdrw(lcdrw), 
    // .lcddat(lcddat), 
    // .send_data_done(send_data_done)
    // );


endmodule
