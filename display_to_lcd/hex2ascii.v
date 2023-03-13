module hex_to_ascii(
    input wire [7:0] memory_capacity,
    input wire [7:0] manufacture_id,
    input wire [7:0] memory_type,
    output reg [255:0] ascii_string
);

    always @(*) begin
        ascii_string [255:208] = "CAP=0x";
        ascii_string [207:192] = { hex2ascii(memory_capacity[7:4]), hex2ascii(memory_capacity[3:0])};
        ascii_string [191:184] = " ";
        ascii_string [183:144] = "ID=0x";
        ascii_string [143:128] = { hex2ascii(manufacture_id[7:4]), hex2ascii(manufacture_id[3:0])};
        ascii_string [127:72] = "TYPE=0x";
        ascii_string [71:56] = { hex2ascii(memory_type[7:4]), hex2ascii(memory_type[3:0])};
        ascii_string [55:0] = 56'b0;
    end

    function [7:0] hex2ascii (input [3:0] hex_value);
        case(hex_value)
            4'h0: begin hex2ascii = 8'h30; end
            4'h1: begin hex2ascii = 8'h31; end
            4'h2: begin hex2ascii = 8'h32; end
            4'h3: begin hex2ascii = 8'h33; end
            4'h4: begin hex2ascii = 8'h34; end
            4'h5: begin hex2ascii = 8'h35; end
            4'h6: begin hex2ascii = 8'h36; end
            4'h7: begin hex2ascii = 8'h37; end
            4'h8: begin hex2ascii = 8'h38; end
            4'h9: begin hex2ascii = 8'h39; end
            4'ha: begin hex2ascii = 8'h41; end
            4'hb: begin hex2ascii = 8'h42; end
            4'hc: begin hex2ascii = 8'h43; end
            4'hd: begin hex2ascii = 8'h44; end
            4'he: begin hex2ascii = 8'h45; end
            4'hf: begin hex2ascii = 8'h46; end
            default: begin hex2ascii = 8'h23; end
        endcase
    endfunction
endmodule
