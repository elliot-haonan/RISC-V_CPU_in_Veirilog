module MUX16to1(
//inputs
addr, d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15,
//outputs
data
);
	input [3:0] addr;
	input [31:0] d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15;
	output [31:0] data;
	reg [31:0] data;
	
	always@(*)
	begin
		if (addr == 4'h0) data = d0;
		else if (addr == 4'h1) data = d1;
		else if (addr == 4'h2) data = d2;
		else if (addr == 4'h3) data = d3;
		else if (addr == 4'h4) data = d4;
		else if (addr == 4'h5) data = d5;
		else if (addr == 4'h6) data = d6;
		else if (addr == 4'h7) data = d7;
		else if (addr == 4'h8) data = d8;
		else if (addr == 4'h9) data = d9;
		else if (addr == 4'ha) data = d10;
		else if (addr == 4'hb) data = d11;
		else if (addr == 4'hc) data = d12;
		else if (addr == 4'hd) data = d13;
		else if (addr == 4'he) data = d14;
		else data = d15;
	end
	
	
endmodule
	