`timescale 1ns / 1ps
`default_nettype none

module transaction(
    input wire clk,
    input wire reset,
    input wire do_write_data,
    input wire [255:0] data_to_write,
    input wire do_set_dd_ram_addr,
    input wire dd_ram_addr,
    output wire LCDE_q,
    output wire LCDRS_q,
    output wire LCDRW_q,
    output wire LCDDAT_q,
    output wire set_dd_ram_addr_done,
    output wire send_data_done
    );
    
    // Internal signals
    reg state, next_state;
    wire init_done;

    // Constants
    localparam init = 3'b000;
    localparam function_set = 3'b001;
    localparam entry_mode_set = 3'b010;
    localparam display_on_off = 3'b011;
    localparam clear_display = 3'b100;
    localparam idle = 3'b101;
    localparam do_write_ram = 3'b110;
    localparam do_set_addr = 3'b111;


    // physical physical (
    // .clk(clk), 
    // .reset(reset), 
    // .do_init(do_init), 
    // .do_send_data(do_send_data), 
    // .data_to_send(data_to_send), 
    // .lcdrs_in(lcdrs_in), 
    // .init_done(init_done), 
    // .lcde(lcde), 
    // .lcdrd(lcdrd), 
    // .lcdrw(lcdrw), 
    // .lcddat(lcddat), 
    // .send_data_done(send_data_done)
    // );

    always @(posedge clk ) begin
        if (reset == 1'b1) state <= idle;
        else state <= next_state;
    end

    always @(*) begin
        // initializations here
        case(state)
        init: begin
            if (init_done == 1) 
                next_state = function_set; 
            else next_state = init;
        end
        function_set: begin
            if ( send_data_done == 1 )
                next_state = entry_mode_set;
            else next_state = function_set;
        end
        entry_mode_set: begin
            if ( send_data_done == 1)
                next_state = display_on_off;
            else next_state = entry_mode_set;
        end
        display_on_off: begin
            if ( send_data_done == 1)
                next_state = clear_display;
            else next_state = display_on_off;
        end
        clear_display: begin
            if ( send_data_done == 1)
                next_state = idle;
            else next_state = clear_display;
        end
        idle: begin
            if ( do_write_data == 1)
                next_state = do_write_ram;
            else next_state = idle;
        end
        do_write_ram: begin
            if ( send_data_done == 1)
                next_state = idle;
            else next_state = do_write_data;
        end
        // do_set_addr: begin
        //     if ( )
        //         next_state = ;
        //     else next_state = ;
        // end
        default: next_state = idle;
    endcase
    end

    // // synopsys translate_off

    // // For annotation on testbench
    // // Each state must be 16 characters or the 
    // // testbench will have leading '_' in the state names
    // reg[127:0]ascii_state, ascii_next_state;
    // always @(state) begin
    //     case(state) 
    //     idle: ascii_state = "idle            ";
    //     assert_cs: ascii_state = "idle            ";
    //     send_instruction:  ascii_state = "send_instruction";
    //     get_data: ascii_state = "get_data        ";
    //     deAssert_cs: ascii_state = "deAssert_cs     ";
    //     default: ascii_state = "default         ";
    //     endcase
    // end
    // always @(next_state) begin
    //     case(next_state) 
    //     idle: ascii_next_state = "idle            ";
    //     assert_cs: ascii_next_state = "idle            ";
    //     send_instruction:  ascii_next_state = "send_instruction";
    //     get_data: ascii_next_state = "get_data        ";
    //     deAssert_cs: ascii_next_state = "deAssert_cs     ";
    //     default: ascii_next_state = "default         ";
    //     endcase
    // end
    // // synopsys translate_on


endmodule
