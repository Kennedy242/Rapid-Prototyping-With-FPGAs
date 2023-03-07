`timescale 1ns / 1ps
`default_nettype none

module clock_divider_tb();
    
    // Inputs
    reg CLKIN_IN;

    // Outputs
    wire CLKDV_OUT;
    wire CLKIN_IBUFG_OUT;
    wire CLK0_OUT;
    
    // Instantiate the Unit Under Test (UUT)
clock_divider clock_divider (
    .CLKIN_IN(CLKIN_IN), 
    .CLKDV_OUT(CLKDV_OUT), 
    .CLKIN_IBUFG_OUT(CLKIN_IBUFG_OUT), 
    .CLK0_OUT(CLK0_OUT)
    );
    
    // System clock
    always begin 
        CLKIN_IN = 1'b0;
        forever #10 CLKIN_IN = ~CLKIN_IN;
    end
    
endmodule