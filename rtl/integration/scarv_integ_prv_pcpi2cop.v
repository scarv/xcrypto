//
// SCARV Project
// 
// University of Bristol
// 
// RISC-V Cryptographic Instruction Set Extension
// 
// Reference Implementation
// 
// 

//
// module: scarv_integ_prv_pcpi2cop
//
//  A converter module which acts as glue logic between the PicoRV32
//  PCPI interface and the COP instruction interface.
//
module scarv_integ_prv_pcpi2cop (

// Pico Co-Processor Interface (PCPI)
input         pcpi_valid    ,
input  [31:0] pcpi_insn     ,
input  [31:0] pcpi_rs1      ,
input  [31:0] pcpi_rs2      ,
output        pcpi_wr       ,
output [31:0] pcpi_rd       ,
output        pcpi_wait     ,
output        pcpi_ready    ,

// XCrypto Co-Processor Interface
output        cpu_insn_req  , // Instruction request
input         cop_insn_ack  , // Instruction request acknowledge
output [31:0] cpu_insn_enc  , // Encoded instruction data
output [31:0] cpu_rs1       , // RS1 source data
output [31:0] cpu_rs2       , // RS2 source data

input         cop_wen       , // COP write enable
input  [ 4:0] cop_waddr     , // COP destination register address
input  [31:0] cop_wdata     , // COP write data
input  [ 2:0] cop_result    , // COP execution result
input         cop_insn_rsp  , // COP instruction finished
output        cpu_insn_ack    // Instruction finish acknowledge

);

//
// Specification for the PCPI interface is taken from:
//  https://github.com/cliffordwolf/picorv32#pico-co-processor-interface-pcpi
//

//
// PicoRV -> COP
//
assign cpu_insn_req  = pcpi_valid;
assign cpu_insn_enc  = pcpi_insn;
assign cpu_rs1       = pcpi_rs1;
assign cpu_rs2       = pcpi_rs2;

//
// Constant / un-used signals
//
assign cpu_insn_ack  = 1'b1; // PicoRV accepts all responses immediately.

//
// COP -> PicoRV
//
//  PCPI does not allow COP to specify a writeback register. The writeback
//  register address is automatically decoded by the PicoRV32. By design
//  all writeback register addresses in the XCrypto ISE align with the
//  standard RISC-V destination register fields.
//
assign pcpi_wr       =  cop_wen;
assign pcpi_rd       =  cop_wdata;
assign pcpi_wait     = !cop_insn_rsp && pcpi_valid;
assign pcpi_ready    =  cop_insn_rsp && cop_result != 3'b010;

endmodule
