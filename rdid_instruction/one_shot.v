module one_shot(
		input wire clk,
		input wire data_in,
		output wire data_out 
		);

reg data_in_q;

// debounce
always@(posedge clk)begin
	begin
		data_in_q <= data_in;
	end
end

// one-shot
assign data_out = ~data_in_q & data_in;

endmodule
