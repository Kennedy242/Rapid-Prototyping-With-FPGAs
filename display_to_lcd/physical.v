`timescale 1ns / 1ps
`default_nettype none

module physical(
    input clk,
    input reset,
    input do_init,
    input do_send_data,
    input data_to_send,
    input lcdrs_in,
    output init_done,
    output lcde,
    output lcdrd,
    output lcdrw,
    output lcddat,
    output send_data_done
    );


endmodule
