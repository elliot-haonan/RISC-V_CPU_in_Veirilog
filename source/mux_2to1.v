module mux_2to1(in0,in1,addr,out);
input [3:0] in0,in1;
input addr;
output [3:0] out;
reg [3:0] out;
always @(in0 or in1 or addr )
	begin 
		if (addr) out = in1;
		else out = in0;
	end
endmodule