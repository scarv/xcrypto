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
// module: scarv_cop_mem
//
//  Load/store memory access module.
//
module scarv_cop_mem (
input  wire         mem_ivalid       , // Valid instruction input
output wire         mem_idone        , // Instruction complete

output wire         mem_addr_error   , // Memory address exception
output wire         mem_bus_error    , // Memory bus exception

input  wire [31:0]  gpr_rs1          , // Source register 1
input  wire [31:0]  cpr_rs1          , // Source register 2
input  wire [31:0]  cpr_rs2          , // Source register 3

input  wire [31:0]  id_imm           , // Source immedate
input  wire [31:0]  id_class         , // Instruction class
input  wire [31:0]  id_subclass      , // Instruction subclass

output wire [ 3:0]  mem_cpr_rd_ben   , // Writeback byte enable
output wire [ 3:0]  mem_cpr_rd_wdata , // Writeback data

//
// Memory Interface
output wire             cop_mem_cen  , // Chip enable
output wire             cop_mem_wen  , // write enable
output wire [31:0]      cop_mem_addr , // Read/write address (word aligned)
output wire [31:0]      cop_mem_wdata, // Memory write data
input  wire [31:0]      cop_mem_rdata, // Memory read data
output wire [ 3:0]      cop_mem_ben  , // Write Byte enable
input  wire             cop_mem_stall, // Stall
input  wire             cop_mem_error  // Error
);



endmodule
