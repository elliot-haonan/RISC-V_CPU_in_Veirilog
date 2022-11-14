module MUX2to1(
//outputs
out,
//inputs
in0, in1, addr
);
	input [31:0] in0, in1;
	input addr;
	output [31:0] out;
	reg [31:0] out;
	
	always@(*)
	begin
		if (addr == 1'b0) out = in0;
		else out = in1;
	end
	
endmodule 