module ledMux (
    input wire reset,
    input wire [1:0] SW,
    input wire [7:0] memory_capacity,
    input wire [7:0] memory_type,
    input wire [7:0] manufacture_id,
    output reg [7:0] LED
);

localparam defaultCase = 8'hff;

always @(*) begin
    if(reset == 1'b1) LED <= 8'h00;
    else begin
        case(SW)
        2'b00: LED <= memory_capacity;
        2'b01: LED <= memory_type;
        2'b10: LED <= manufacture_id;
        2'b11: LED <= defaultCase;
        endcase
    end
    
end

endmodule