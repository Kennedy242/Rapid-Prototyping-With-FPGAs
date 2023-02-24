module sync(
    input wire clk,
    input wire data_in,
    output reg data_out
);

always @(negedge clk) begin
    data_out = data_in;
end

endmodule