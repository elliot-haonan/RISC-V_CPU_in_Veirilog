module adder_4bits(a, b, ci, s, co);
input [3:0] a, b;
input ci;
output [3:0] s;
output co;
integer i,j;
reg [3:0] g;
reg [3:0] p;
reg [3:0] c;

always @(*)
	begin
		for (i = 0;i <= 3;i = i + 1)
			begin 
				g[i] = a[i] & b[i];
				p[i] = a[i] | b[i];
			end
	end
 
always @(*)
	begin
		c[0] = ci; 
		for (j = 1;j <= 3;j = j + 1)
			begin
				c[j] = g[j-1] | (p[j-1] & c[j-1]);
			end
	end

assign co = g[3] | (p[3] & c[3]);
assign s[0] = a[0] ^ b[0] ^ c[0];
assign s[1] = a[1] ^ b[1] ^ c[1];
assign s[2] = a[2] ^ b[2] ^ c[2];
assign s[3] = a[3] ^ b[3] ^ c[3];
endmodule
