# RISC-V_CPU_in_Veirilog
This is an implementation of a Five-Stage Pipelining RISC-V Microprocessor in Verilog HDL.
## Design Schematic
<img width="607" alt="屏幕截图 2022-11-14 004246" src="https://user-images.githubusercontent.com/107291837/201746535-2fe006cc-88c3-49e8-9825-ad0c08b35d28.png">
The design is a five-stage pipeliing RISC-V processor. It has forwading path to forwad from memory access and write back stage to execution stage. It has a hazard detector to detect the load-use hazard and stall the processor for a cycle. It tackles branch at decode stage, which issues the flush signal to flush the IF/ID pipelining register and select the PC source once the branch is taken. Use Xilinx IP for the data memory module.
