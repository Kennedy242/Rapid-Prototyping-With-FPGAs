`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// 
// Module Name: washerTop 
// Project Name:  Wash_machine_controller
//
//////////////////////////////////////////////////////////////////////////////////
module washerTop(
    input wire reset,
    input wire clk,
    input wire Start,
    input wire Door,
    input wire [1:0] load,
    output wire Agitator,
    output wire Motor,
    output wire Pump,
    output wire Speed,
    output wire Water
    );

	 // Internal signals
     wire Td;
     wire Tf;
     wire Tr;
     wire Ts;
     wire Tw;
     wire R;


// Instantiate the Units Under Test
   washerTimer washerTimer (
        .load(load), 
		.clk(clk), 
		.R(R), 
		.Td(Td), 
		.Tf(Tf), 
		.Tr(Tr), 
		.Ts(Ts), 
		.Tw(Tw)
   );

   washerFSM washerFSM (
		.clk(clk), 
		.reset(reset), 
		.Door(Door), 
		.Start(Start), 
		.Td(Td), 
		.Tf(Tf), 
		.Tr(Tr), 
		.Ts(Ts), 
		.Tw(Tw), 
		.Agitator(Agitator), 
		.Motor(Motor), 
		.Pump(Pump), 
		.R(R), 
		.Speed(Speed), 
		.Water(Water)
	);

endmodule
