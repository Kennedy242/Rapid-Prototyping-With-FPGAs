`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
// Module Name:    spi_master_fsm 
// Project Name: 
//
//////////////////////////////////////////////////////////////////////////////////
module spi_master_fsm(
    input reset,
    input clk, 
    input get_rdid
    );

    reg [2:0] state, next_state;

    parameter idle = 3'b000;
    parameter assert_cs = 3'b001;
    parameter send_inst = 3'b010;
    parameter get_data = 3'b011;
    parameter deassert_cs = 3'b100;

    always @(posedge clk ) begin
        if (reset == 1'b1) state <= idle;
        else state <= next_state;
    end

    always @(*) begin
        // FIXME: initilize outputs here
        case(state) 
        idle:
            if(get_rdid == 1) next_state = assert_cs;
        assert_cs:
            next_state = send_inst;
        send_inst: 
            // FIXME: this state should take 8 clks
            next_state = get_data;
        get_data:
            // FIXME: this state should take 24 clks
            next_state = deassert_cs;
        deassert_cs:
            next_state = idle;
        default:
            next_state = idle;
        endcase
    end

    reg[119:0]ascii_state, ascii_next_state; //for annotation

    always @(state) begin
        case(state) 
        idle: ascii_state = "idle";
        assert_cs: ascii_state = "assert_cs";
        send_inst:  ascii_state = "send_inst";
        get_data: ascii_state = "get_data";
        deassert_cs: ascii_state = "deassert_cs";
        default: ascii_state = "default";
        endcase
    end

    always @(next_state) begin
        case(next_state) 
        idle: ascii_next_state = "idle";
        assert_cs: ascii_next_state = "assert_cs";
        send_inst:  ascii_next_state = "send_inst";
        get_data: ascii_next_state = "get_data";
        deassert_cs: ascii_next_state = "deassert_cs";
        default: ascii_next_state = "default";
        endcase
    end
endmodule
