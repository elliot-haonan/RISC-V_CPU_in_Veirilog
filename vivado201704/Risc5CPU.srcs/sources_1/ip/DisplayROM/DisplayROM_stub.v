// Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2017.4 (win64) Build 2086221 Fri Dec 15 20:55:39 MST 2017
// Date        : Tue Sep  8 09:00:01 2020
// Host        : DESKTOP-B6JT6H6 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               f:/SourceProgram/lab30_Risc5CPU/vivado201704/Risc5CPU.srcs/sources_1/ip/DisplayROM/DisplayROM_stub.v
// Design      : DisplayROM
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a200tfbg484-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "dist_mem_gen_v8_0_12,Vivado 2017.4" *)
module DisplayROM(a, clk, qspo)
/* synthesis syn_black_box black_box_pad_pin="a[7:0],clk,qspo[7:0]" */;
  input [7:0]a;
  input clk;
  output [7:0]qspo;
endmodule
