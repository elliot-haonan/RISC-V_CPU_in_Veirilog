`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: zju
// Engineer: qmj
//////////////////////////////////////////////////////////////////////////////////
module EX(ALUCode_ex, ALUSrcA_ex, ALUSrcB_ex, Imm_ex, rs1Addr_ex, rs2Addr_ex, rs1Data_ex, 
          rs2Data_ex, PC_ex, RegWriteData_wb, ALUResult_mem, rdAddr_mem, rdAddr_wb, 
		  RegWrite_mem, RegWrite_wb, ALUResult_ex, MemWriteData_ex, ALU_A, ALU_B);
    input [3:0] ALUCode_ex;
    input ALUSrcA_ex;
    input [1:0]ALUSrcB_ex;
    input [31:0] Imm_ex;
    input [4:0]  rs1Addr_ex;
    input [4:0]  rs2Addr_ex;
    input [31:0] rs1Data_ex;
    input [31:0] rs2Data_ex;
	input [31:0] PC_ex;
    input [31:0] RegWriteData_wb;
    input [31:0] ALUResult_mem;
	input [4:0]rdAddr_mem;
    input [4:0] rdAddr_wb;
    input RegWrite_mem;
    input RegWrite_wb;
    output [31:0] ALUResult_ex;
    output [31:0] MemWriteData_ex;
    output [31:0] ALU_A;
    output [31:0] ALU_B;
	
	wire [31:0] a, b, m, n; 
	wire [1:0] ForwardA, ForwardB;
	
	ALU a1(
	.ALUCode(ALUCode_ex),
	.A(a),
	.B(b),
	.ALUResult(ALUResult_ex)
	);
	
	MUX2to1 a2(
	.in0(m),
	.in1(PC_ex),
	.out(a),
	.addr(ALUSrcA_ex)
	);
	
	MUX4to1 a3(
	.in0(n),
	.in1(Imm_ex),
	.in2(32'h4),
	.in3(),
	.addr(ALUSrcB_ex),
	.out(b)
	);
	
	MUX4to1 a4(
	.in0(rs1Data_ex),
	.in1(RegWriteData_wb),
	.in2(ALUResult_mem),
	.in3(),
	.addr(ForwardA),
	.out(m)
	);
	
	MUX4to1 a5(
	.in0(rs2Data_ex),
	.in1(RegWriteData_wb),
	.in2(ALUResult_mem),
	.in3(),
	.addr(ForwardB),
	.out(n)
	);
	
	assign MemWriteData_ex = n;
	assign ALU_A = a;
	assign ALU_B = b;
	
	Forwarding a6(
	.ForwardA(ForwardA),
	.ForwardB(ForwardB),
	.RegWrite_wb(RegWrite_wb),
	.rdAddr_wb(rdAddr_wb),
	.rdAddr_mem(rdAddr_mem),
	.rs1Addr_ex(rs1Addr_ex),
	.rs2Addr_ex(rs2Addr_ex),
	.RegWrite_mem(RegWrite_mem)
	);
	
endmodule
