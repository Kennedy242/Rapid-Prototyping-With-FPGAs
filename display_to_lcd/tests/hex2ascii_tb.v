`timescale 1ns / 1ps
`default_nettype none

module hex2ascii_tb();
    
    // Inputs
    reg [7:0] memory_capacity;
    reg [7:0] manufacture_id;
    reg [7:0] memory_type;
    
    // Outputs
    wire [255:0] ascii_string;
    
    // Instantiate the Unit Under Test (UUT)
    hex_to_ascii hex_to_ascii (
        .memory_capacity(memory_capacity), 
        .manufacture_id(manufacture_id), 
        .memory_type(memory_type), 
        .ascii_string(ascii_string)
    );
    
    // Stimulus for UUT
    initial begin
        // Initialize inputs
        memory_capacity = 8'h15;
        manufacture_id = 8'h20;
        memory_type = 8'h20;
    end
endmodule
