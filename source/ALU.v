//******************************************************************************
// MIPS verilog model
//
// ALU.v
//******************************************************************************

module ALU (
	// Outputs
	   ALUResult,
	// Inputs
	   ALUCode, A, B);
	input [3:0]	ALUCode;				// Operation select
	input [31:0]	A, B;
	output [31:0]	ALUResult;
	wire Binvert;
	wire [31:0] Binvert_extend;
	wire [31:0] sum, d2, d3, d4, d5, d6, d7, d9, d10;
	reg [31:0] d8;
	
   // Decoded ALU operation select (ALUsel) signals
   parameter	 alu_add=  4'b0000;
   parameter	 alu_sub=  4'b0001;
   parameter	 alu_lui=  4'b0010;
   parameter	 alu_and=  4'b0011;
   parameter	 alu_xor=  4'b0100;
   parameter	 alu_or =  4'b0101;
   parameter 	 alu_sll=  4'b0110;
   parameter	 alu_srl=  4'b0111;
   parameter	 alu_sra=  4'b1000;
   parameter	 alu_slt=  4'b1001;
   parameter	 alu_sltu= 4'b1010; 	
   
   assign Binvert = ~(ALUCode == 0);
   assign Binvert_extend = {32{Binvert}};
   
   adder_32bits a1(
		.a(A[31:0]),
		.b(Binvert_extend ^ B),
		.ci(Binvert),
		.co(),
		.s(sum[31:0])
   );
   
   assign d2 = B;
   assign d3 = A & B;
   assign d4 = A ^ B;
   assign d5 = A | B;
   assign d6 = A << B;
   assign d7 = A >> B;
   
   //Arithmetic Shift Right
   reg signed [31:0] A_reg;
   always@(*) begin A_reg = A; end
   
   always@(*) begin d8 = A_reg >>> B; end
   
   //Compare
   assign d9 = A[31] && (~B[31]) || (A[31] ~^ B[31]) &&sum [31];
   assign d10 = (~A[31]) && B[31] || (A[31] ~^ B[31]) && sum[31];
   
   MUX16to1 a2(
		.addr(ALUCode),
		.d0(sum),
		.d1(sum),
		.d2(d2),
		.d3(d3),
		.d4(d4),
		.d5(d5),
		.d6(d6),
		.d7(d7),
		.d8(d8),
		.d9(d9),
		.d10(d10),
		.d11(),
		.d12(),
		.d13(),
		.d14(),
		.d15(),
		.data(ALUResult)
   );
   
   

endmodule