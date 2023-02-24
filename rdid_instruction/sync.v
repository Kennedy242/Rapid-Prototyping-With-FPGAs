module sync(
    input wire clk,
    input wire set,
    output reg data_q
);

always @(negedge clk or posedge set) begin
    if(set == 0)
    data_q = 0;
    else 
    data_q = 1;
end

endmodule