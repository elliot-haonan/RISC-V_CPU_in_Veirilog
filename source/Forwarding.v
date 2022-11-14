module Forwarding(
//outputs
ForwardA, ForwardB,
//inputs
RegWrite_wb, rdAddr_wb, rdAddr_mem, rs1Addr_ex, RegWrite_mem, rs2Addr_ex
);
	input [4:0] rdAddr_mem, rdAddr_wb, rs1Addr_ex, rs2Addr_ex;	
	input RegWrite_mem, RegWrite_wb;
	output [1:0] ForwardA, ForwardB;
	
	assign ForwardA[0] = RegWrite_wb && (rdAddr_wb!=0) && (rdAddr_mem!=rs1Addr_ex) && (rdAddr_wb == rs1Addr_ex);
	assign ForwardA[1] = RegWrite_mem && (rdAddr_mem!=0) && (rdAddr_mem == rs1Addr_ex);
	assign ForwardB[0] = RegWrite_wb && (rdAddr_wb!=0) && (rdAddr_mem!=rs2Addr_ex) && (rdAddr_wb == rs2Addr_ex);
	assign ForwardB[1] = RegWrite_mem && (rdAddr_mem!=0) && (rdAddr_mem == rs2Addr_ex);
	
endmodule
	
	

