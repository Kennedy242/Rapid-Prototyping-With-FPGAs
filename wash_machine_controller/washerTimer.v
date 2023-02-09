`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// 
// Module Name:    washerTimer 
// Project Name:  Wash_machine_controller
// Description: A timer module for the washing machine controller
// 
//////////////////////////////////////////////////////////////////////////////////
module washerTimer(
    input wire [1:0]load,
    input wire clk,
    input wire R,
    input wire hold,
    output reg Td,
    output reg Tf,
    output reg Tr,
    output reg Ts,
    output reg Tw
    );

    reg [3:0]counter;

    always @(posedge clk) begin
        counter <= counter + 4'b0001;
        if( R == 1'b1) counter <= 4'b0000;
     end
	 
    always @(*) begin
        Td = 1'b0;
        Tf = 1'b0;
        Tr = 1'b0;
        Ts = 1'b0;
        Tw = 1'b0;
        if (counter == 4'b001)  Td = 1'b1;
        if (counter == 4'b010)  Tf = 1'b1;
        if (counter == 4'b100)  Tr = 1'b1;
        if (counter == 4'b111)  Ts = 1'b1;
        case (load)
            2'b00: if( counter == 4'b0010) Tw = 1'b1; 
            2'b01: if (counter == 4'b0100) Tw = 1'b1; 
            2'b10: if ( counter == 4'b1000) Tw = 1'b1; 
        endcase
    end
endmodule
