module Dtrigger(
//outputs
q,
//inputs
clk, reset, d, enable
);
	input clk, reset, enable;
	input [31:0] d;
	output reg [31:0] q;
	
	always@(posedge clk)
	begin
		if (reset) q <= 0;
		else if(enable) q <= d;
	end 
	
endmodule