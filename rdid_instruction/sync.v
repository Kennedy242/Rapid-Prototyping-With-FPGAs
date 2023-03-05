`timescale 1ns / 1ps
`default_nettype none

module sync (
    input wire clk,
    input wire async_in,
    output reg sync_out
);

reg q1;

always @(negedge clk ) begin
    sync_out <= q1;
end
always @(negedge clk ) begin
    q1 <= async_in;
end
    
endmodule