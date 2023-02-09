`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// 
// Module Name:    washerFSM 
// Project Name:  Wash_machine_controller
//
//////////////////////////////////////////////////////////////////////////////////
module washerFSM(
    input wire clk,
    input wire reset,
    input wire Door,
    input wire Start,
    input wire Td,
    input wire Tf,
    input wire Tr,
    input wire Ts,
    input wire Tw,
    output reg Agitator,
    output reg Motor,
    output reg Pump,
    output reg R,
    output reg Speed,
    output reg Water
    );

    reg [3:0] state, next_state;

    parameter idle = 4'b0000;
    parameter fill_1 = 4'b0001;
    parameter wash = 4'b0010;
    parameter drain_1 = 4'b0011;
    parameter fill_2 = 4'b0100;
    parameter rinse = 4'b0101;
    parameter drain_2 = 4'b0110;
    parameter spin = 4'b0111;
    parameter hold = 4'b1000;

// update next state
    always @(posedge clk, posedge reset) begin
        if (reset == 1'b1) begin state <= idle; end
        else state <= next_state;
    end

    // Form the next state
    always @(*) begin
        next_state = state; // when no case statement is satisfied
        Agitator = 1'b0;
        Motor = 1'b0;
        Pump = 1'b0;
        R = 1'b1;
        Speed = 1'b0;
        Water = 1'b0;
        case(state)
            idle: begin
                if (Start == 0) begin
                    next_state = idle;
                end
                else if (Start == 1) begin
                    next_state = fill_1;
                    R = 1'b1;
                end
            end 
            fill_1:begin
                R = 1'b0;
                Water = 1'b1;
                if(Tf == 0) begin
                    next_state = fill_1;
                    end
                else if(Tf == 1) begin
                    next_state = wash;
                    R = 1'b1;
                    end
            end 
            wash:begin
                R = 1'b0;
                Agitator = 1'b1;
                Motor = 1'b1;
                if(Tw == 0) begin
                    next_state = wash;
                    end
                else if(Tw == 1) begin
                    next_state = drain_1;
                    R = 1'b1;
                    end
            end 
            drain_1:begin
                R = 1'b0;
                Pump = 1'b1;
                if(Td == 0) begin
                    next_state = drain_1;
                    end
                else if(Td == 1) begin
                    next_state = fill_2;
                    R = 1'b1;
                    end
            end 
            fill_2:begin
                R = 1'b0;
                Water = 1'b1;
                if(Tf == 0) begin
                    next_state = fill_2;
                    end
                else if(Tf == 1) begin
                    next_state = rinse;
                    end
            end 
            rinse:begin
                R = 1'b0;
                Agitator = 1'b1;
                Motor = 1'b1;
                if(Tr == 0) begin
                    next_state = rinse;
                end
                else if(Tr == 1) begin
                    next_state = drain_2;
                end
            end 
            drain_2:begin
                R = 1'b0;
                Pump = 1'b1;
                if(Td == 0) begin
                    next_state = drain_2;
                end
                else if(Td == 1) begin
                    next_state = spin;
                end
            end 
            spin: begin
                R = 1'b0;
                Motor = 1'b1;
                Speed = 1'b1;
                if(Door == 1)begin
                    next_state = hold;
                end
                else if(Ts == 0) begin
                    next_state = spin;
                end
                else if(Ts == 1)begin 
                    next_state = idle;
                end
            end
            hold: begin
                R = 1'b1;
                if (Door == 1)begin
                    next_state = hold;
                end
                else if (Door == 0)begin
                    next_state = spin;
                end
            end
        endcase
    end
endmodule
