module reset_sync(
    input wire clk,
    input wire set,
    output reg data_q
);

always @(negedge clk or posedge set) begin
    if(set == 1)
    data_q <= 1;
    else 
    data_q <= 0;
end

endmodule