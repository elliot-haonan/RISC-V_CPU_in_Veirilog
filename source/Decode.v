//******************************************************************************
// //
// Decode.v
//******************************************************************************

module Decode(   
	// Outputs
	MemtoReg_id, RegWrite_id, MemWrite_id, MemRead_id, ALUCode_id, ALUSrcA_id, ALUSrcB_id, Jump, JALR, Imm_id, offset, 
	// Inputs
    Instruction);
	input [31:0]	Instruction;	// current instruction
	output		   MemtoReg_id;		// use memory output as data to write into register
	output		   RegWrite_id;		// enable writing back to the register
	output		   MemWrite_id;		// write to memory
	output         MemRead_id;
	output [3:0]   ALUCode_id;         // ALU operation select
	output      	ALUSrcA_id;
	output [1:0]   ALUSrcB_id;
	output         Jump;
	output         JALR;
	output[31:0]   Imm_id,offset;
	wire R_type, I_type, SB_type, LW, JALR, SW, LUI, AUIPC, JAL, Shift;
	reg [31:0] Imm_id,offset;
	
//******************************************************************************
//  instruction type decode
//******************************************************************************
	parameter  R_type_op=   7'b0110011;
	parameter  I_type_op=   7'b0010011;
	parameter  SB_type_op=  7'b1100011;
	parameter  LW_op=       7'b0000011;
	parameter  JALR_op=     7'b1100111;
	parameter  SW_op=       7'b0100011;
	parameter  LUI_op=      7'b0110111;
	parameter  AUIPC_op=    7'b0010111;	
	parameter  JAL_op=      7'b1101111;	
//
  //
   parameter  ADD_funct3 =     3'b000 ;
   parameter  SUB_funct3 =     3'b000 ;
   parameter  SLL_funct3 =     3'b001 ;
   parameter  SLT_funct3 =     3'b010 ;
   parameter  SLTU_funct3 =    3'b011 ;
   parameter  XOR_funct3 =     3'b100 ;
   parameter  SRL_funct3 =     3'b101 ;
   parameter  SRA_funct3 =     3'b101 ;
   parameter  OR_funct3 =      3'b110 ;
   parameter  AND_funct3 =     3'b111;
   //
   parameter  ADDI_funct3 =     3'b000 ;
   parameter  SLLI_funct3 =     3'b001 ;
   parameter  SLTI_funct3 =     3'b010 ;
   parameter  SLTIU_funct3 =    3'b011 ;
   parameter  XORI_funct3 =     3'b100 ;
   parameter  SRLI_funct3 =     3'b101 ;
   parameter  SRAI_funct3 =     3'b101 ;
   parameter  ORI_funct3 =      3'b101 ;
   parameter  ANDI_funct3 =     3'b111;
   //
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

//******************************************************************************
// instruction field
//******************************************************************************
	wire [6:0]		op;
	wire  	 	    funct6_7;
	wire [2:0]		funct3;
	assign op			= Instruction[6:0];
	assign funct6_7		= Instruction[30];
 	assign funct3		= Instruction[14:12];
	
	assign R_type = (op == R_type_op);
	assign I_type = (op == I_type_op);
	assign SB_type = (op == SB_type_op);
	assign LW = (op == LW_op);
	assign JALR = (op == JALR_op);
	assign SW = (op == SW_op);
	assign LUI = (op == LUI_op);
	assign AUIPC = (op == AUIPC_op);
	assign JAL = (op == JAL_op);

	assign MemtoReg_id = LW;
	assign MemRead_id = LW;
	assign MemWrite_id = SW;
	assign RegWrite_id = R_type || I_type || LW || JALR || LUI || AUIPC || JAL;
	assign Jump = JALR || JAL;
	assign ALUSrcA_id = JALR || JAL || AUIPC;
	assign ALUSrcB_id[1] = JAL || JALR;
	assign ALUSrcB_id[0] = ~(R_type || JAL || JALR);
	
	assign a = funct3[2];
	assign b = funct3[1];
	assign c = funct3[0];
	assign ALUCode_id[3] = (R_type && ~I_type && ~LUI && ~a && b && ~c && ~funct6_7) || (R_type && ~I_type && ~LUI && ~a && b && c && ~funct6_7) 
						|| (R_type && ~I_type && ~LUI && a && ~b && c && funct6_7) || (~R_type && I_type && ~LUI && ~a && b && ~c ) ||
						(~R_type && I_type && ~LUI && ~a && b && c ) || (~R_type && I_type && ~LUI && a && ~b && c && funct6_7);
	assign ALUCode_id[2] = (R_type && ~I_type && ~LUI && ~a && ~b && c && ~funct6_7) || (R_type && ~I_type && ~LUI && a && ~b && ~c && ~funct6_7) || 
							(R_type && ~I_type && ~LUI && a && ~b && c && ~funct6_7) || (R_type && ~I_type && ~LUI && a && b && ~c && ~funct6_7) ||
							(~R_type && I_type && ~LUI && ~a && ~b && c) || (~R_type && I_type && ~LUI && a && ~b && ~c) || (~R_type && I_type && ~LUI && a && ~b && c && ~funct6_7) ||
							(~R_type && I_type && ~LUI && a && b && ~c);
	assign ALUCode_id[1] = (R_type && ~I_type && ~LUI && ~a && ~b && c && ~funct6_7) || (R_type && ~I_type && ~LUI && ~a && b && c && ~funct6_7) ||
							(R_type && ~I_type && ~LUI && a && ~b && c && ~funct6_7) || (R_type && ~I_type && ~LUI && a && b && c && ~funct6_7) ||
							(~R_type && I_type && ~LUI && ~a && ~b && c) || (~R_type && I_type && ~LUI && ~a && b && c) || (~R_type && I_type && ~LUI && a && ~b && c && ~funct6_7) ||
							(~R_type && I_type && ~LUI && a && b && c) || (~R_type && ~I_type && LUI);
	assign ALUCode_id[0] = (R_type && ~I_type && ~LUI && ~a && ~b && ~c && funct6_7) || (R_type && ~I_type && ~LUI && ~a && b && ~c && ~funct6_7) || (R_type && ~I_type && ~LUI && a && ~b && c && ~funct6_7) ||
							(R_type && ~I_type && ~LUI && a && b && ~c && ~funct6_7) || (R_type && ~I_type && ~LUI && a && b && c && ~funct6_7) || (~R_type && I_type && ~LUI && ~a && b && ~c) || 
							(~R_type && I_type && ~LUI && a && ~b && c && ~funct6_7) || (~R_type && I_type && ~LUI && a && b && ~c) || (~R_type && I_type && ~LUI && a && b && c);
	
	assign Shift = (funct3 == 1) || (funct3 == 5);
	
	always @(*)
		begin
		if (I_type && Shift) begin Imm_id[31:0] = {26'd0,Instruction[25:20]}; offset[31:0] = 32'd0; end
		else if (I_type && ~Shift) begin Imm_id = {{20{Instruction[31]}},Instruction[31:20]}; offset = 32'd0; end
		else if (LW) begin Imm_id = {{20{Instruction[31]}},Instruction[31:20]}; offset = 32'd0; end
		else if (JALR) begin Imm_id = 32'd0; offset = {{20{Instruction[31]}},Instruction[31:20]}; end
		else if (SW) begin Imm_id = {{20{Instruction[31]}},Instruction[31:25],Instruction[11:7]}; offset = 32'd0; end
		else if (JAL) begin Imm_id = 32'd0; offset = {{11{Instruction[31]}},Instruction[31],Instruction[19:12],Instruction[20],Instruction[30:21],1'b0}; end
		else if (LUI || AUIPC) begin Imm_id = {Instruction[31:12],12'd0}; offset = 32'd0; end
		else if (SB_type) begin Imm_id = 32'd0; offset = {{19{Instruction[31]}},Instruction[31],Instruction[7],Instruction[30:25],Instruction[11:8],1'b0}; end
		else begin Imm_id = 32'd0; offset = 32'd0; end
		end
	
	
	 
endmodule