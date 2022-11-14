module Dtrigger_n(
//outputs
q,
//inputs
clk, reset, d, enable
);
    parameter n = 32;
	input clk, reset, enable;
	input [n-1:0] d;
	output reg [n-1:0] q;
	
	always@(posedge clk)
	begin
		if (reset) q <= 0;
		else if(enable) q <= d;
	end 
	
endmodule