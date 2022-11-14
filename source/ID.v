`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
//////////////////////////////////////////////////////////////////////////////////
module ID(clk,Instruction_id, PC_id, RegWrite_wb, rdAddr_wb, RegWriteData_wb, MemRead_ex, 
          rdAddr_ex, MemtoReg_id, RegWrite_id, MemWrite_id, MemRead_id, ALUCode_id, 
			 ALUSrcA_id, ALUSrcB_id,  Stall, Branch, Jump, IFWrite,  JumpAddr, Imm_id,
			 rs1Data_id, rs2Data_id, rs1Addr_id, rs2Addr_id, rdAddr_id);
    input clk;
    input [31:0] Instruction_id;
    input [31:0] PC_id;
    input RegWrite_wb;
    input [4:0] rdAddr_wb;
    input [31:0] RegWriteData_wb;
    input MemRead_ex;
    input [4:0] rdAddr_ex;
    output MemtoReg_id;
    output RegWrite_id;
    output MemWrite_id;
    output MemRead_id;
    output [3:0] ALUCode_id;
    output ALUSrcA_id;
    output [1:0] ALUSrcB_id;
    output Stall;
    output Branch;
    output Jump;
    output IFWrite;
    output [31:0] JumpAddr;
    output [31:0] Imm_id;
    output [31:0] rs1Data_id;
    output [31:0] rs2Data_id;
	output[4:0] rs1Addr_id, rs2Addr_id, rdAddr_id;
	
	//*******************************
	//Register File
	//*******************************
	wire [4:0] rs1Addr_id, rs2Addr_id, rdAddr_wb;
	
	assign rs1Addr_id = Instruction_id[19:15];
	assign rs2Addr_id = Instruction_id[24:20];
	
	Regfile a1(
		.rs1Addr_id(rs1Addr_id),
		.rs2Addr_id(rs2Addr_id),
		.rdAddr_wb(rdAddr_wb),
		.RegWriteData_wb(RegWriteData_wb),
		.RegWrite_wb(RegWrite_wb),
		.clk(clk),
		.rs1Data_id(rs1Data_id),
		.rs2Data_id(rs2Data_id)
	);
	
	//*******************************
	//Decode and Imm Gen
    //*******************************	
	
	wire [31:0] offset;
	wire JALR;
	
	Decode a2(
		.MemtoReg_id(MemtoReg_id), 
		.RegWrite_id(RegWrite_id), 
		.MemWrite_id(MemWrite_id), 
		.MemRead_id(MemRead_id), 
		.ALUCode_id(ALUCode_id), 
		.ALUSrcA_id(ALUSrcA_id), 
		.ALUSrcB_id(ALUSrcB_id), 
		.Jump(Jump), 
		.JALR(JALR), 
		.Imm_id(Imm_id), 
		.offset(offset), 
		.Instruction(Instruction_id)
	);
	
	//********************************
	//JumpAddr
	//********************************
	wire [31:0] plusin;
	
	MUX2to1 a4(
		.in1(rs1Data_id),
		.in0(PC_id),
		.addr(JALR),
		.out(plusin)
	);
	
	adder_32bits a5(
		.a(plusin),
		.b(offset),
		.ci(1'b0),
		.co(),
		.s(JumpAddr)
	);
	
	//********************************
	//Branch Test
	//********************************
	
	wire [31:0] sum;
	wire isLT, isLTU;
	wire [2:0] funct3;
	wire SB_type;
	reg Branch;
	
	parameter beq_funct3 = 3'o0;
	parameter bne_funct3 = 3'o1;
	parameter blt_funct3 = 3'o4;
	parameter bge_funct3 = 3'o5;
	parameter bltu_funct3 = 3'o6;
	parameter bgeu_funct3 = 3'o7;
	
	assign funct3 = Instruction_id[14:12];
	assign SB_type = (Instruction_id[6:0] == 7'b1100011);
	
	adder_32bits a3(
		.a(rs1Data_id),
		.b(~rs2Data_id),
		.ci(1'd1),
		.s(sum),
		.co()
	);
	
	assign isLT = rs1Data_id[31] && (~rs2Data_id[31]) || (rs1Data_id[31]~^rs2Data_id[31]) && sum[31];
	assign isLTU = (~rs1Data_id[31]) && rs2Data_id[31] || (rs1Data_id[31] ~^ rs2Data_id[31]) && sum[31];
	
	always@(*)
	begin
		if (SB_type && (funct3 == beq_funct3)) begin Branch = ~(|sum[31:0]); end
		else if (SB_type && (funct3 == bne_funct3)) begin Branch = |sum[31:0]; end
		else if (SB_type && (funct3 == blt_funct3)) begin Branch = isLT; end
		else if (SB_type && (funct3 == bge_funct3)) begin Branch = ~isLT; end
		else if (SB_type && (funct3 == bltu_funct3)) begin Branch = isLTU; end
		else if (SB_type && (funct3 == bgeu_funct3)) begin Branch = ~isLTU; end
		else begin Branch = 0; end
	end
	
	//*******************************
	//Hazard Detector
	//*******************************
	
	assign Stall = ((rdAddr_ex == rs1Addr_id) || (rdAddr_ex == rs2Addr_id)) && MemRead_ex;
	assign IFWrite = ~Stall;
	
	//*****************************
	//rdAddr_id
	//*****************************
	
	assign rdAddr_id = Instruction_id[11:7];
	
endmodule
