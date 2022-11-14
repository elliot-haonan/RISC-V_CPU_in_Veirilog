//******************************
//Register File
//******************************
module Regfile(
//outputs
rs1Data_id, rs2Data_id, 
//inputs
rs1Addr_id, rs2Addr_id, rdAddr_wb, RegWriteData_wb, RegWrite_wb, clk
);
	input [4:0] rs1Addr_id, rs2Addr_id, rdAddr_wb;
	input [31:0] RegWriteData_wb;
	input RegWrite_wb, clk;
	output [31:0] rs1Data_id, rs2Data_id;
	wire [31:0] ReadData1, ReadData2;
	wire rs1Sel, rs2Sel;

	reg [31:0]regs [31:0];                                                      //define 32 32bits registers
	assign ReadData1 = (rs1Addr_id == 5'b0)?32'b0:regs[rs1Addr_id];             //readdata 1
	assign ReadData2 = (rs2Addr_id == 5'b0)?32'b0:regs[rs2Addr_id];             //readdata 2
	always@(posedge clk) begin if(RegWrite_wb) regs[rdAddr_wb] <= RegWriteData_wb;  end   //datawrite

	assign rs1Sel = RegWrite_wb && (rdAddr_wb != 5'b0) && (rdAddr_wb == rs1Addr_id);
	assign rs2Sel = RegWrite_wb && (rdAddr_wb != 5'b0) && (rdAddr_wb == rs2Addr_id);
     
	assign rs1Data_id = (rs1Sel == 1'b1)?RegWriteData_wb:ReadData1;
	assign rs2Data_id = (rs2Sel == 1'b1)?RegWriteData_wb:ReadData2;
endmodule 