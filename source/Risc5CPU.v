`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: zju
// Engineer: qmj
//////////////////////////////////////////////////////////////////////////////////
module Risc5CPU(clk, reset, JumpFlag, Instruction_id, ALU_A, 
                     ALU_B, ALUResult_ex, PC, MemDout_mem, Stall);
    input clk;
    input reset;
    output[1:0] JumpFlag;
    output [31:0] Instruction_id;
    output [31:0] ALU_A;
    output [31:0] ALU_B;
    output [31:0] ALUResult_ex;
    output [31:0] PC;
    output [31:0] MemDout_mem;
    output Stall;
	
	
	//******************************
	//IF module
	//******************************
	wire Branch, Jump, IFWrite, IF_flush;
	wire [31:0] JumpAddr, Instruction_if, PC;
	assign JumpFlag = {Jump, Branch};
	
	IF a1(
		.clk(clk),
		.reset(reset),
		.Branch(Branch),
		.Jump(Jump),
		.IFWrite(IFWrite),
		.JumpAddr(JumpAddr),
		.Instruction_if(Instruction_if),
		.PC(PC),
		.IF_flush(IF_flush)
	);
	
	//*****************************
	//IF/ID reg
	//*****************************
	wire [31:0] PC_id, Instruction_id;
	
	Dtrigger a2(
		.d(PC),
		.q(PC_id),
		.reset(IF_flush || reset),
		.enable(IFWrite),
		.clk(clk)
	);
	
	Dtrigger a3(
		.d(Instruction_if),
		.q(Instruction_id),
		.reset(IF_flush || reset),
		.enable(IFWrite),
		.clk(clk)
	);
	
	
	//*****************************
	//ID module
	//*****************************
	wire [1:0] ALUSrcB_id;
	wire RegWrite_wb, MemRead_ex, MemtoReg_id, RegWrite_id, MemWrite_id, MemRead_id, ALUSrcA_id, Stall; 
	wire [4:0] rdAddr_wb, rdAddr_ex, rs1Addr_id, rs2Addr_id, rdAddr_id;
	wire [31:0] RegWriteData_wb, Imm_id, rs1Data_id, rs2Data_id;
	wire [3:0] ALUCode_id;
	ID a4(
		.clk(clk),
		.Instruction_id(Instruction_id), 
		.PC_id(PC_id), 
		.RegWrite_wb(RegWrite_wb), 
		.rdAddr_wb(rdAddr_wb), 
		.RegWriteData_wb(RegWriteData_wb), 
		.MemRead_ex(MemRead_ex),		
        .rdAddr_ex(rdAddr_ex), 
		.MemtoReg_id(MemtoReg_id), 
		.RegWrite_id(RegWrite_id),
		.MemWrite_id(MemWrite_id), 
		.MemRead_id(MemRead_id), 
		.ALUCode_id(ALUCode_id), 
		.ALUSrcA_id(ALUSrcA_id), 
		.ALUSrcB_id(ALUSrcB_id),  
		.Stall(Stall), 
		.Branch(Branch), 
		.Jump(Jump), 
		.IFWrite(IFWrite),  
		.JumpAddr(JumpAddr), 
		.Imm_id(Imm_id),
		.rs1Data_id(rs1Data_id), 
		.rs2Data_id(rs2Data_id),
		.rs1Addr_id(rs1Addr_id),
		.rs2Addr_id(rs2Addr_id),
		.rdAddr_id(rdAddr_id)
	);
	
	//***************************
	//ID/EX reg
	//***************************
	
	wire MemtoReg_ex, RegWrite_ex, MemWrite_ex, ALUSrcA_ex;
	wire [3:0] ALUCode_ex;
	wire [31:0] PC_ex, Imm_ex, rs1Data_ex, rs2Data_ex;
	wire [4:0] rs1Addr_ex, rs2Addr_ex;
	wire [1:0] ALUSrcB_ex;
	
	Dtrigger_n #(.n(154)) a5(
		.d({MemtoReg_id, RegWrite_id, MemWrite_id, MemRead_id, ALUCode_id, ALUSrcA_id, ALUSrcB_id, PC_id, Imm_id, rdAddr_id, rs1Addr_id, rs2Addr_id, rs1Data_id, rs2Data_id}),
		.q({MemtoReg_ex, RegWrite_ex, MemWrite_ex, MemRead_ex, ALUCode_ex, ALUSrcA_ex, ALUSrcB_ex, PC_ex, Imm_ex, rdAddr_ex, rs1Addr_ex, rs2Addr_ex, rs1Data_ex, rs2Data_ex}),
		.reset(Stall || reset),
		.enable(1'b1),
		.clk(clk)
	);
	
	//**************************
	//EX
	//**************************
	wire [31:0] ALUResult_mem, ALUResult_ex, MemWriteData_ex;
	wire [4:0] rdAddr_mem;
	wire RegWrite_mem;

	EX a10(
		.ALUCode_ex(ALUCode_ex), 
		.ALUSrcA_ex(ALUSrcA_ex), 
		.ALUSrcB_ex(ALUSrcB_ex),
		.Imm_ex(Imm_ex), 
		.rs1Addr_ex(rs1Addr_ex), 
		.rs2Addr_ex(rs2Addr_ex), 
		.rs1Data_ex(rs1Data_ex), 
        .rs2Data_ex(rs2Data_ex), 
		.PC_ex(PC_ex), 
		.RegWriteData_wb(RegWriteData_wb), 
		.ALUResult_mem(ALUResult_mem),
		.rdAddr_mem(rdAddr_mem), 
		.rdAddr_wb(rdAddr_wb), 
		.RegWrite_mem(RegWrite_mem), 
		.RegWrite_wb(RegWrite_wb), 
		.ALUResult_ex(ALUResult_ex), 
		.MemWriteData_ex(MemWriteData_ex), 
		.ALU_A(ALU_A), 
		.ALU_B(ALU_B)
	);
	
	//***********************
	//EX/Mem
	//***********************
	wire MemtoReg_mem, MemWrite_mem;
	wire [31:0] MemWriteData_mem;
	Dtrigger_n #(.n(72)) a11(
		.d({MemtoReg_ex, RegWrite_ex, MemWrite_ex, ALUResult_ex, MemWriteData_ex, rdAddr_ex}),
		.q({MemtoReg_mem, RegWrite_mem, MemWrite_mem, ALUResult_mem, MemWriteData_mem, rdAddr_mem}),
		.reset(reset),
		.enable(1'b1),
		.clk(clk)
	);
	
	//*********************
	//Mem
	//*********************
	wire [31:0] MemDout_mem;
	DataMemory a14(
		.a(ALUResult_mem[7:2]),
		.d(MemWriteData_mem),
		.clk(clk),
		.we(MemWrite_mem),
		.spo(MemDout_mem)
	);
	
	//********************
	//MEM/WB
	//********************
	wire MemtoReg_wb;
	wire [31:0] ALUResult_wb, MemDout_wb;
	
	Dtrigger_n #(.n(71)) a15(
		.d({MemtoReg_mem, RegWrite_mem, MemDout_mem, ALUResult_mem, rdAddr_mem}),
		.q({MemtoReg_wb, RegWrite_wb, MemDout_wb, ALUResult_wb, rdAddr_wb}),
		.reset(reset),
		.clk(clk),
		.enable(1'b1)
	);
	
	MUX2to1 a18(
	.out(RegWriteData_wb),
	.in0(ALUResult_wb), 
	.in1(MemDout_wb), 
	.addr(MemtoReg_wb)
	);
	
	
endmodule
