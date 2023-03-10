module debounce ( 
	input wire clk,
    input wire data_in, 
    output reg data_debounced = 0
	);

	reg [12:0] change_reg = 0;

	always @(posedge clk) begin 
		// if (reset)
		// 	change_reg <= 16'b0;
		if (data_debounced && data_in)
			change_reg <= 12'b0;
		else if (!data_debounced && !data_in)
			change_reg <= 12'b0;
		else if (data_debounced && !data_in)
			change_reg <= change_reg + 1'b1;
		else if (!data_debounced && data_in)
			change_reg <= change_reg + 1'b1;
	end

	always @(posedge clk) begin
		if (change_reg == 12'hFFF)
			data_debounced <= data_in;
	end 
endmodule