module debounce ( 
	input wire clk,
    input wire reset, 
    input wire data_in, 
    output reg data_debounced 
	);

	reg [15:0] change_reg;

	always @(posedge clk or posedge reset) begin 
		if (reset)
			change_reg <= 16'b0;
		else if (data_debounced && data_in)
			change_reg <= 16'b0;
		else if (!data_debounced && !data_in)
			change_reg <= 16'b0;
		else if (data_debounced && !data_in)
			change_reg <= change_reg + 1'b1;
		else if (!data_debounced && data_in)
			change_reg <= change_reg + 1'b1;
	end

	always @(posedge clk or posedge reset) begin
		if (reset) 
			data_debounced <= 1'b0;
		else if (change_reg == 16'hFFFF)
			data_debounced <= data_in;
	end 
endmodule