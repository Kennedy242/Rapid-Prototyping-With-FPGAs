`timescale 1ns / 1ps
`default_nettype none

module rdid_top(
    input wire clk,
    input wire reset,
    input wire data_in
);

    // Internal signals
    wire data_debounced;
    wire data_out;
    reg set;
    wire data_q;

    debounce debounce ( 
        .clk(clk),
        .reset(reset),
        .data_in(data_in),
        .data_debounced(data_debounced)
        );

    one_shot one_shot(
        .clk(clk),
        .data_in(data_in),
        .data_out(data_out)
        );  

    sync sync(
        .clk(clk),
        .set(set),
        .data_q(data_q)
    );


endmodule
