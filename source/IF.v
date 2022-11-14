`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:  zju
// Engineer: qmj
//////////////////////////////////////////////////////////////////////////////////
module IF(clk, reset, Branch,Jump, IFWrite, JumpAddr,Instruction_if,PC,IF_flush);
    input clk;
    input reset;
    input Branch;
    input Jump;
    input IFWrite;
    input [31:0] JumpAddr;
    output [31:0] Instruction_if;
    output [31:0] PC;
    output IF_flush;
	wire [31:0] NextPC_if, PCIn, PC;
	wire PCSource; 
	
	InstructionROM a1(
	.addr(PC[5:0]>>2'b10),
	.dout(Instruction_if)
	);
	
	adder_32bits a2(
	.a(32'h4),
	.b(PC),
	.ci(1'b0),
	.co(),
	.s(NextPC_if)
	);
	
	MUX2to1 a3(
	.in0(NextPC_if),
	.in1(JumpAddr),
	.addr(PCSource),
	.out(PCIn)
	);
	
	Dtrigger a4(
	.clk(clk),
	.reset(reset),
	.d(PCIn),
	.q(PC),
	.enable(IFWrite)
	);
	
	assign IF_flush = Jump || Branch;
	assign PCSource = Jump || Branch;
	
	
	
endmodule
