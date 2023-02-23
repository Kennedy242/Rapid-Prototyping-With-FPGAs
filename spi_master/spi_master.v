`timescale 1ns / 1ps
`default_nettype none

module spi_master(
    input wire reset,
    input wire clk,
    input wire get_rdid,
    input wire SPIMISO,
    output reg SPICLK,
    output wire SPIMOSI,
    output reg chip_select
    );

    // Internal signals
    reg[127:0]ascii_state, ascii_next_state; //for testbench annotation
    reg [2:0] state, next_state;
    reg [2:0] count_inst;
    reg [4:0] count_data;
    reg send_inst_flag;
    reg get_data_flag;
    reg instruction_sent;
    reg data_received;
    reg [23:0] read_data;
    wire [7:0] manufacture_id;
    wire [7:0] memory_type;
    wire [7:0] memory_capacity;


    // Constants
    parameter RDID_instruction = 8'h9F;
    parameter count_inst_start = 7;
    parameter count_data_start = 23;
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
        chip_select = 1'b1;

        case(state) 
        idle: begin 
            if(get_rdid == 1) next_state = assert_cs;
            else next_state = idle;
        end

        assert_cs: begin 
            chip_select = 1'b0;
            next_state = send_instruction;
        end

        send_instruction: begin  
            chip_select = 1'b0;
            send_inst_flag = 1;
            if (instruction_sent == 1) next_state = get_data;
            else next_state = send_instruction; 
        end

        get_data: begin 
            chip_select = 1'b0;
            get_data_flag = 1;
            if (data_received == 1) next_state = deAssert_cs;
            else next_state = get_data;
        end

        deAssert_cs: begin 
            chip_select = 1'b1;
            next_state = idle;
        end

        default: begin 
            next_state = idle;
        end
        endcase
    end

    // Send instruction
    always @(posedge clk or posedge reset ) begin
        if(reset == 1) count_inst <= count_inst_start;
        else if (get_rdid) count_inst <= count_inst_start;
        else if(send_inst_flag && SPICLK) begin
            count_inst <= count_inst - 3'b001;
            if(count_inst == 0) instruction_sent <= 1;
        end
    end

    assign SPIMOSI = RDID_instruction[count_inst]; // Send instruction

    // receive data
    always @(posedge clk or posedge reset) begin
        if(reset == 1) count_data <= count_data_start;
        else if (get_rdid) count_data <= count_data_start;
        else if(get_data_flag && SPICLK) begin
            count_data <= count_data - 1;
            if(count_data == 0) data_received <= 1;
        end
    end

    always @(posedge SPICLK ) begin
        read_data[count_data] = SPIMISO; // get data from slave
    end

    assign manufacture_id = read_data[23:16];
    assign memory_type = read_data[15:8];
    assign memory_capacity = read_data[7:0];

    // generate SPI clock
    always @(posedge clk or posedge reset) begin
        if(reset) SPICLK <= 1'b0;
        else if ( send_inst_flag  || get_data_flag ) SPICLK <= ~SPICLK;
        else if (get_rdid) SPICLK <= 1'b0;
    end

    // For annotation on testbench
    // Each state must be 16 characters or the 
    // testbench will have leading '_' in the state names
    always @(state) begin
        case(state) 
        idle: ascii_state = "idle            ";
        assert_cs: ascii_state = "idle            ";
        send_instruction:  ascii_state = "send_instruction";
        get_data: ascii_state = "get_data        ";
        deAssert_cs: ascii_state = "deAssert_cs     ";
        default: ascii_state = "default         ";
        endcase
    end
    always @(next_state) begin
        case(next_state) 
        idle: ascii_next_state = "idle            ";
        assert_cs: ascii_next_state = "idle            ";
        send_instruction:  ascii_next_state = "send_instruction";
        get_data: ascii_next_state = "get_data        ";
        deAssert_cs: ascii_next_state = "deAssert_cs     ";
        default: ascii_next_state = "default         ";
        endcase
    end
endmodule
