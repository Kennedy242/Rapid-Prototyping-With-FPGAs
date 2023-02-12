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

    // Internal signals
    reg[127:0]ascii_state, ascii_next_state; //for testbench annotation
    reg [2:0] state, next_state;
    reg [3:0] count_inst;
    reg [4:0] count_data;
    reg send_inst_flag;
    reg get_data_flag;
    reg instruction_sent;
    reg data_received;
    reg chip_select;

    parameter idle = 3'b000;
    parameter assert_cs = 3'b001;
    parameter send_instruction = 3'b010;
    parameter get_data = 3'b011;
    parameter deAssert_cs = 3'b100;

    always @(posedge clk ) begin
        if (reset == 1'b1) state <= idle;
        else state <= next_state;
    end

    always @(*) begin
        send_inst_flag = 0;
        get_data_flag = 0;
        case(state) 
        idle: begin 
            instruction_sent = 0;
            data_received = 0;
            chip_select = 0;
            if(get_rdid == 1) next_state = assert_cs;
        end
        assert_cs: begin 
            chip_select = 1;
            next_state = send_instruction;
        end
        send_instruction: begin  
            send_inst_flag = 1;
            count_inst = 4'b1000;
            if (instruction_sent == 1) next_state = get_data;
        end
        get_data: begin 
            get_data_flag = 1;
            count_data = 5'b1_1000;
            if (data_received == 1) next_state = deAssert_cs;
        end
        deAssert_cs: begin 
            chip_select = 0;
            next_state = idle;
        end
        default: begin 
            next_state = idle;
        end
        endcase
    end

    // Send instruction
    always @(negedge clk ) begin
        if(send_inst_flag == 1) begin
            // TODO: Send data here
            count_inst <= count_inst - 1;
            if(count_inst == 0) instruction_sent <= 1;
        end
    end

    // Send data
    always @(negedge clk ) begin
        if(get_data_flag == 1) begin
            // TODO: Send data here
            count_data <= count_data - 1;
            if(count_data == 0) data_received <= 1;
        end
    end

    // For annotation on testbench
    always @(state) begin
        case(state) 
        idle: ascii_state = "idle";
        assert_cs: ascii_state = "assert_cs";
        send_instruction:  ascii_state = "send_instruction";
        get_data: ascii_state = "get_data";
        deAssert_cs: ascii_state = "deAssert_cs";
        default: ascii_state = "default";
        endcase
    end

    // For annotation on testbench
    always @(next_state) begin
        case(next_state) 
        idle: ascii_next_state = "idle";
        assert_cs: ascii_next_state = "assert_cs";
        send_instruction:  ascii_next_state = "send_instruction";
        get_data: ascii_next_state = "get_data";
        deAssert_cs: ascii_next_state = "deAssert_cs";
        default: ascii_next_state = "default";
        endcase
    end
endmodule
