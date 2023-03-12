`timescale 1ns / 1ps
`default_nettype none

module counter(
    input wire clk,
    input wire reset,
    output reg time_1ms,
    output reg time_100us,
    output reg time_40us
    );

    reg [15:0]counter;

    always @(posedge clk) begin
        counter <= counter + 1'b0001;
        if( reset == 1'b1) counter <= 0;
     end
	 
    always @(*) begin
        time_40us = 1'b0;
        time_100us = 1'b0;
        time_1ms = 1'b0;
        if (counter == 125)  time_40us = 1'b1;
        if (counter == 312)  time_100us = 1'b1;
        if (counter == 3125)  time_1ms = 1'b1;
    end
endmodule
