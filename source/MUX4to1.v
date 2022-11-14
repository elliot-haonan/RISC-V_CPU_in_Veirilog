module MUX4to1(
//outputs
out,
//inputs
in0, in1, in2, in3, addr
);
	input [31:0] in0, in1, in2, in3;
	input [1:0] addr;
	output [31:0] out;
	reg [31:0] out;
	
	always@(*)
	begin
		if (addr == 2'b00) out = in0;
		else if (addr == 2'b01) out = in1;
		else if (addr == 2'b10) out = in2;
		else out = in3;
	end
	
endmodule 