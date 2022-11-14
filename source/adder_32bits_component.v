module adder_32bits_component(a,b,ci,co,s);
input [3:0] a,b;
input ci;
output [3:0] s;
output co;
wire d,e;
wire [3:0] f,g;

adder_4bits a1(.a(a),
               .b(b),
			   .ci(1'b1),
			   .co(d),
			   .s(f));
			   
adder_4bits a2(.a(a),
               .b(b),
			   .ci(1'b0),
			   .co(e),
			   .s(g));		

mux_2to1 a3(.in0(g),
			.in1(f),
			.addr(ci),
			.out(s));			   

assign co = (d&ci)|e;

endmodule 