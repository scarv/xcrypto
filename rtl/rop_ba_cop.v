
//
// University of Brisol SCARV Project
//


//
//  module: rop_ba_cop
//
//      Random Operand Padded, Byte Addressable Co-Processor
//
module rop_ba_cop (

input   wire        clk             , // Global clock
output  wire        clk_req         , // Block clock request

input   wire        resetn          , // Active low sychronous reset.

input   wire        cop_req         , // COP request valid
output  wire        cop_acc         , // COP request accept
output  wire        cop_rsp         , // COP response valid
input   wire [31:0] cop_instr_in    , // Input instruction word
input   wire [31:0] cop_rs1         , // Input source register 1
input   wire [31:0] cop_rs2         , // Input source register 2

output  wire [ 2:0] cop_rd_byte     , // Output destination byte / register.
output  wire [ 4:0] cop_rd          , // Output destination register.
output  wire [31:0] cop_wdata       , // Output result writeback data.
output  wire        cop_wen         , // Output result write enable.

output  wire        cop_mem_cen     , // COP memory if chip enable.
input   wire        cop_mem_stall   , // COP memory if stall
input   wire        cop_mem_error   , // COP memory if error
output  wire        cop_mem_wen     , // COP memory if write enable.
output  wire [ 3:0] cop_mem_ben     , // COP memory write byte enable.
output  wire [31:0] cop_mem_wdata   , // COP memory if write data
input   wire [31:0] cop_mem_rdata   , // COP memory if read data
output  wire [31:0] cop_mem_addr      // COP memory if address

);
