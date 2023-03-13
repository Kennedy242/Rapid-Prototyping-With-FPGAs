`timescale 1ns / 1ps
`default_nettype none

module command(
    input wire CCLK,
    input wire reset_btn,
    input wire get_rdid_btn,
    input wire SPIMISO,
    input wire [1:0] SW,
    output wire SPICLK,
    output wire SPIMOSI,
    output wire [7:0] LED,
    output wire LCDE,
    output wire LCDRS,
    output wire LCDRW,
    output wire LCDDAT,
    output wire cs_pre_amp_n,
    output wire cs_dac_n,
    output wire cs_a2d,
    output wire cs_parallel_flash_n,
    output wire cs_platform_flash,
    output wire cs_prom_n
);

    wire LD0, LD1, LD2, LD3, LD4, LD5, LD6, LD7;
    assign {LD0, LD1, LD2, LD3, LD4, LD5, LD6, LD7} = LED;
    wire SW0, SW1;
    assign {SW1, SW0} = SW;

    // internal signals
    wire get_rdid_debounced;
    wire get_rdid_oneShot;
    wire get_rdid;
    wire reset_debounced;
    wire reset;
    wire clk;
    reg [2:0] state, next_state;
    reg do_write_data;
    wire [255:0] data_to_write;
    reg do_set_dd_ram_addr;
    reg dd_ram_addr;
    reg get_rdid_done; // where does this signal come from?
    wire LCDE_q;
    wire LCDRS_q;
    wire LCDRW_q;
    wire LCDDAT_q;
    wire set_dd_ram_addr_done;
    wire send_data_done;
    reg count;
    wire [7:0] manufacture_id;
    wire [7:0] memory_type;
    wire [7:0] memory_capacity;

    // Constants
    localparam idle = 3'b000;
    localparam wait_get_rdid_done = 3'b001;
    localparam send_byte = 3'b010;
    localparam wait_done = 3'b011;
    localparam set_addr = 3'b100;

    // FPGA NETs SPI Bus
    assign cs_pre_amp_n = 1;
    assign cs_dac_n = 1;
    assign cs_a2d = 0;
    assign cs_parallel_flash_n = 1;
    assign cs_platform_flash = 0;

    // DCM designed from Xilinx tools
    clock_divider clock_divider (
        .CLKIN_IN(CCLK),
        .CLKDV_OUT(clk)
    );

    debounce debounce_get_rdid ( 
        .clk(clk),
        .data_in(get_rdid_btn),
        .data_debounced(get_rdid_debounced)
    );
    one_shot one_shot_get_rdid (
        .clk(clk),
        .data_in(get_rdid_debounced),
        .data_out(get_rdid_oneShot)
    ); 
    sync get_rdid_sync(
        .clk(clk),
        .async_in(get_rdid_oneShot),
        .sync_out(get_rdid)
    );

    debounce debounce_reset ( 
        .clk(clk),
        .data_in(reset_btn),
        .data_debounced(reset_debounced)
    );
    sync reset_sync(
        .clk(clk),
        .async_in(reset_debounced),
        .sync_out(reset)
    );

    spi_master spi_master (
		.reset(reset),
		.clk(clk),
		.get_rdid(get_rdid),
		.SPICLK(SPICLK),
		.SPIMOSI(SPIMOSI),
		.SPIMISO(SPIMISO),
		.chip_select(cs_prom_n),
        .manufacture_id(manufacture_id),
        .memory_type(memory_type),
        .memory_capacity(memory_capacity)
	);

    ledMux ledMux(
        .reset(reset),
        .SW(SW),
        .memory_capacity(memory_capacity),
        .memory_type(memory_type),
        .manufacture_id(manufacture_id),
        .LED(LED)
    );

    // // TODO: test this
    hex_to_ascii hex_to_ascii (
        .memory_capacity(memory_capacity),
        .manufacture_id(manufacture_id),
        .memory_type(memory_type),
        .ascii_string(data_to_write)
    );

transaction transaction (
    .clk(clk),
    .reset(reset),
    .do_write_data(do_write_data),
    .data_to_write(data_to_write),
    .do_set_dd_ram_addr(do_set_dd_ram_addr),
    .dd_ram_addr(dd_ram_addr),
    .LCDE_q(LCDE_q),
    .LCDRS_q(LCDRS_q),
    .LCDRW_q(LCDRW_q),
    .LCDDAT_q(LCDDAT_q),
    .set_dd_ram_addr_done(set_dd_ram_addr_done),
    .send_data_done(send_data_done)
    );

    // state machine for command layer
    always @(*) begin
        // initializations here
        case(state)
        idle: begin
            if ( get_rdid == 1 )
                next_state = wait_get_rdid_done;
            else next_state = idle;
        end
        wait_get_rdid_done: begin
            if ( get_rdid_done == 1 )
                next_state = send_byte;
            else next_state = wait_get_rdid_done;
        end
        send_byte: begin
            if ( count != 0 ) begin
                do_write_data = 1;
                next_state = wait_done;
            end
            else next_state = send_byte;
        end
        wait_done: begin
            if (send_data_done == 1)
                next_state = send_byte;
            else next_state = wait_done;
        end
        // set_addr:
        default: begin
            next_state = idle;
        end
        endcase
    end

    // synopsys translate_off
    // TODO:
    // For annotation on testbench
    // Each state must be 16 characters or the
    // testbench will have leading '_' in the state names
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
    // synopsys translate_on

endmodule
