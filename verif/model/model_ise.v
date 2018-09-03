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
// module: model_ise
//
//  A behavioural model of the ISE
//
module model_ise(

//
// Clock and reset interface

input  wire             g_clk           , // Global clock
output wire             g_clk_req       , // Clock request
input  wire             g_resetn        , // Synchronous active low reset.

//
// Input instruction interface
input  wire             cop_insn_valid  , // Instruction valid
input  wire [31:0]      cop_insn_enc    , // Encoded instruction data
input  wire [31:0]      cop_rs1         , // RS1 source data


//
// Output modelling signals.
output reg  [ 2:0]      cop_result      , // Instruction execution result

output reg  [15:0]      cop_cprs_written, // CPR Registers read by instr
output reg  [15:0]      cop_cprs_read   , // CPR Registers written by instr

output reg              cop_rd_wen      , // GPR Write Enable
output reg  [ 4:0]      cop_rd_addr     , // GPR Write Address
output reg  [31:0]      cop_rd_data     , // Data to write to GPR

//
// Memory transaction tracking.
output reg              cop_mem_cen_0   , // Memory transaction 0 enable
output reg              cop_mem_wen_0   , // Transaction 0 write enable
output reg  [ 3:0]      cop_mem_ben_0   , // Transaction byte enable
output reg  [31:0]      cop_mem_addr_0  , // Transaction 0 address
output reg  [31:0]      cop_mem_wdata_0 , // Transaction 0 write enable
input       [31:0]      cop_mem_rdata_0 , // Transaction 0 write enable

output reg              cop_mem_cen_1   , // Memory transaction 1 enable
output reg              cop_mem_wen_1   , // Transaction 1 write enable
output reg  [ 3:0]      cop_mem_ben_1   , // Transaction byte enable
output reg  [31:0]      cop_mem_addr_1  , // Transaction 1 address
output reg  [31:0]      cop_mem_wdata_1 , // Transaction 1 write enable
input       [31:0]      cop_mem_rdata_1 , // Transaction 1 write enable

output reg              cop_mem_cen_2   , // Memory transaction 1 enable
output reg              cop_mem_wen_2   , // Transaction 2 write enable
output reg  [ 3:0]      cop_mem_ben_2   , // Transaction byte enable
output reg  [31:0]      cop_mem_addr_2  , // Transaction 2 address
output reg  [31:0]      cop_mem_wdata_2 , // Transaction 2 write enable
input       [31:0]      cop_mem_rdata_2 , // Transaction 2 write enable

output reg              cop_mem_cen_3   , // Memory transaction 1 enable
output reg              cop_mem_wen_3   , // Transaction 3 write enable
output reg  [ 3:0]      cop_mem_ben_3   , // Transaction byte enable
output reg  [31:0]      cop_mem_addr_3  , // Transaction 3 address
output reg  [31:0]      cop_mem_wdata_3 , // Transaction 3 write enable
input       [31:0]      cop_mem_rdata_3   // Transaction 3 write enable

);

//
// Input parameters to the model
// CSR Bit fields: See ISE Spec 4.2
parameter ISE_MCCR_R    = 1; // Feature enable bits.
parameter ISE_MCCR_MP   = 1; // 
parameter ISE_MCCR_SG   = 1; // 
parameter ISE_MCCR_P32  = 1; // 
parameter ISE_MCCR_P16  = 1; // 
parameter ISE_MCCR_P8   = 1; // 
parameter ISE_MCCR_P4   = 1; // 
parameter ISE_MCCR_P2   = 1; // 

parameter ISE_MCCR_S_R  = 1; // Reset value for S bit
parameter ISE_MCCR_U_R  = 1; // Reset Value for U bit

parameter ISE_MCCR_S_W  = 1; // Is S bit writable?
parameter ISE_MCCR_U_W  = 1; // Is U bit writable?

parameter ISE_MCCR_C0_W = 1; // Are the countermeasure enable bits writable?
parameter ISE_MCCR_C1_W = 1; // 
parameter ISE_MCCR_C2_W = 1; // 
parameter ISE_MCCR_C3_W = 1; // 
parameter ISE_MCCR_C4_W = 1; // 
parameter ISE_MCCR_C5_W = 1; // 
parameter ISE_MCCR_C6_W = 1; // 
parameter ISE_MCCR_C7_W = 1; // 

parameter ISE_MCCR_C0_R = 1; // Reset values for countermeasure enable.
parameter ISE_MCCR_C1_R = 1; // 
parameter ISE_MCCR_C2_R = 1; // 
parameter ISE_MCCR_C3_R = 1; // 
parameter ISE_MCCR_C4_R = 1; // 
parameter ISE_MCCR_C5_R = 1; // 
parameter ISE_MCCR_C6_R = 1; // 
parameter ISE_MCCR_C7_R = 1; // 


// Instruction result codes
localparam ISE_RESULT_SUCCESS           = 3'b000;
localparam ISE_RESULT_ABORT             = 3'b001;
localparam ISE_RESULT_DECODE_EXCEPTION  = 3'b010;
localparam ISE_RESULT_LOAD_ADDR_MISALIGN= 3'b100;
localparam ISE_RESULT_STOR_ADDR_MISALIGN= 3'b101;
localparam ISE_RESULT_LOAD_ACCESS_FAULT = 3'b110;
localparam ISE_RESULT_STOR_ACCESS_FAUKT = 3'b111;

// ------------------------------------------------------------------------

// Input to the generated decoder, gated by whether the input instruction
// is valid or not.
wire [31:0] encoded = cop_insn_enc & {32{cop_insn_valid}};

//
// Include the generated decoder. Exposes two classes of signal:
//  - dec_* for each instruction
//  - dec_arg_* for each possible instruction argument field.
//
//  This file is expected to be found in the $COP_WORK directory.
//
`include "ise_decode.v"

// ------------------------------------------------------------------------

//
// ISE State
//
//  These registers hold the complete state of the ISE.
//

reg  [31:0] model_cprs [15:0];

wire [31:0] model_cpr_c0  = model_cprs[ 0];
wire [31:0] model_cpr_c1  = model_cprs[ 1];
wire [31:0] model_cpr_c2  = model_cprs[ 2];
wire [31:0] model_cpr_c3  = model_cprs[ 3];
wire [31:0] model_cpr_c4  = model_cprs[ 4];
wire [31:0] model_cpr_c5  = model_cprs[ 5];
wire [31:0] model_cpr_c6  = model_cprs[ 6];
wire [31:0] model_cpr_c7  = model_cprs[ 7];
wire [31:0] model_cpr_c8  = model_cprs[ 8];
wire [31:0] model_cpr_c9  = model_cprs[ 9];
wire [31:0] model_cpr_c10 = model_cprs[10];
wire [31:0] model_cpr_c11 = model_cprs[11];
wire [31:0] model_cpr_c12 = model_cprs[12];
wire [31:0] model_cpr_c13 = model_cprs[13];
wire [31:0] model_cpr_c14 = model_cprs[14];
wire [31:0] model_cpr_c15 = model_cprs[15];

reg        model_mccr_c0 = ISE_MCCR_C0_R;
reg        model_mccr_c1 = ISE_MCCR_C1_R;
reg        model_mccr_c2 = ISE_MCCR_C2_R;
reg        model_mccr_c3 = ISE_MCCR_C3_R;
reg        model_mccr_c4 = ISE_MCCR_C4_R;
reg        model_mccr_c5 = ISE_MCCR_C5_R;
reg        model_mccr_c6 = ISE_MCCR_C6_R;
reg        model_mccr_c7 = ISE_MCCR_C7_R;
reg        model_mccr_s  = ISE_MCCR_S_R; 
reg        model_mccr_u  = ISE_MCCR_U_R; 

// ------------------------------------------------------------------------

//
// Utility Functions
//

//
// Applies the reset function to all of the ISE state.
//
task model_do_reset;
begin

    $display("ISE> reset");

    model_mccr_c0 = ISE_MCCR_C0_R;
    model_mccr_c1 = ISE_MCCR_C1_R;
    model_mccr_c2 = ISE_MCCR_C2_R;
    model_mccr_c3 = ISE_MCCR_C3_R;
    model_mccr_c4 = ISE_MCCR_C4_R;
    model_mccr_c5 = ISE_MCCR_C5_R;
    model_mccr_c6 = ISE_MCCR_C6_R;
    model_mccr_c7 = ISE_MCCR_C7_R;
    model_mccr_s  = ISE_MCCR_S_R; 
    model_mccr_u  = ISE_MCCR_U_R; 

    model_do_clear_outputs();

end endtask


//
// Resets all outputs of the model so they do not carry to the next
// instruction and polute the results.
task model_do_clear_outputs;
begin
    
    cop_result       = 0;

    cop_cprs_written = 0; // CPR Registers read by instr
    cop_cprs_read    = 0; // CPR Registers written by instr
    
    cop_rd_wen       = 0; // GPR Write Enable
    cop_rd_addr      = 0; // GPR Write Address
    cop_rd_data      = 0; // Data to write to GPR

    cop_mem_cen_0    = 0; // Memory transaction 0 enable
    cop_mem_wen_0    = 0; // Transaction 0 write enable
    cop_mem_addr_0   = 0; // Transaction 0 address
    cop_mem_wdata_0  = 0; // Transaction 0 write enable
    
    cop_mem_cen_1    = 0; // Memory transaction 1 enable
    cop_mem_wen_1    = 0; // Transaction 1 write enable
    cop_mem_addr_1   = 0; // Transaction 1 address
    cop_mem_wdata_1  = 0; // Transaction 1 write enable
    
    cop_mem_cen_2    = 0; // Memory transaction 1 enable
    cop_mem_wen_2    = 0; // Transaction 2 write enable
    cop_mem_addr_2   = 0; // Transaction 2 address
    cop_mem_wdata_2  = 0; // Transaction 2 write enable
    
    cop_mem_cen_3    = 0; // Memory transaction 1 enable
    cop_mem_wen_3    = 0; // Transaction 3 write enable
    cop_mem_addr_3   = 0; // Transaction 3 address
    cop_mem_wdata_3  = 0; // Transaction 3 write enable

end endtask


//
// Implements ISE functionality when we encounter an invalid opcode.
//
task model_do_invalid_opcode;
begin

    model_do_instr_result(ISE_RESULT_DECODE_EXCEPTION);
    $display("ISE> Invalid Opcode: %h", encoded);

end endtask 


//
// Write a GPR with a particular value.
//
task model_do_write_gpr;
    input  [ 4:0] gpr_addr;
    input  [31:0] gpr_data;
begin
    if(cop_rd_wen) begin
        $display("ISE> WARNING: cop_rd_wen already set for this instruction");
    end
    cop_rd_wen  = 1'b1;
    cop_rd_addr = gpr_addr;
    cop_rd_data = gpr_data;
end endtask


//
// Write a CPR with a particular value.
//
task model_do_write_cpr;
    input  [ 3:0] cpr_addr;
    input  [31:0] cpr_data;
begin
    model_cprs[cpr_addr] = cpr_data;
    cop_cprs_written[cpr_addr] = 1'b1;
end endtask


//
// Read the value in a CPR
//
task model_do_read_cpr;
    input  [ 3:0] cpr_addr;
    output [31:0] cpr_data;
begin
    cpr_data = model_cprs[cpr_addr];
    cop_cprs_read[cpr_addr] = 1'b1;
end endtask


//
// Decode a register address pair for a multi-precision instruction.
//
task model_do_decode_rdm;
    output [ 3:0]   rd2;
    output [ 3:0]   rd1;
begin
    rd1 = {dec_arg_crdm,2'b00};
    rd2 = {dec_arg_crdm,2'b01};
end endtask

//
// Set the result of an instruction execution.
//
task model_do_instr_result;
    input  [ 2:0]   result;
begin
    cop_result = result;
end endtask

// ------------------------------------------------------------------------

//
// Instruction Implementations
//


//
// Implementation function for the mv2gpr instruction.
//
task model_do_mv2gpr;
begin: t_model_mv2gpr
    reg  [31:0] crs1;
    model_do_read_cpr(dec_arg_crs1, crs1);
    model_do_write_gpr(dec_arg_rd, crs1);
    model_do_instr_result(ISE_RESULT_SUCCESS);
    $display("ISE> mv2gpr %d, %d",dec_arg_rd,dec_arg_crs1);
end endtask


//
// Implementation function for the mv2cop instruction.
//
task model_do_mv2cop;
begin: t_model_mv2cop
    model_do_write_cpr(dec_arg_crd, cop_rs1);
    model_do_instr_result(ISE_RESULT_SUCCESS);
    $display("ISE> mv2cop %d, %d",dec_arg_crd, dec_arg_rs1);
end endtask


//
// Implementation function for the add.px instruction.
//
task model_do_add_px;
begin: t_model_add_px
    reg  [31:0] crs1, crs2;
    model_do_read_cpr(dec_arg_crs1, crs1);
    model_do_read_cpr(dec_arg_crs2, crs2);
    $display("ISE> ERROR: Instruction add.px not implemented");
end endtask


//
// Implementation function for the sub.px instruction.
//
task model_do_sub_px;
begin: t_model_sub_px
    reg  [31:0] crs1, crs2;
    model_do_read_cpr(dec_arg_crs1, crs1);
    model_do_read_cpr(dec_arg_crs2, crs2);
    $display("ISE> ERROR: Instruction sub.px not implemented");
end endtask


//
// Implementation function for the mul.px instruction.
//
task model_do_mul_px;
begin: t_model_mul_px
    reg  [31:0] crs1, crs2;
    model_do_read_cpr(dec_arg_crs1, crs1);
    model_do_read_cpr(dec_arg_crs2, crs2);
    $display("ISE> ERROR: Instruction mul.px not implemented");
end endtask


//
// Implementation function for the sll.px instruction.
//
task model_do_sll_px;
begin: t_model_sll_px
    reg  [31:0] crs1, crs2;
    model_do_read_cpr(dec_arg_crs1, crs1);
    model_do_read_cpr(dec_arg_crs2, crs2);
    $display("ISE> ERROR: Instruction sll.px not implemented");
end endtask


//
// Implementation function for the srl.px instruction.
//
task model_do_srl_px;
begin: t_model_srl_px
    reg  [31:0] crs1, crs2;
    model_do_read_cpr(dec_arg_crs1, crs1);
    model_do_read_cpr(dec_arg_crs2, crs2);
    $display("ISE> ERROR: Instruction srl.px not implemented");
end endtask


//
// Implementation function for the rot.px instruction.
//
task model_do_rot_px;
begin: t_model_rot_px
    reg  [31:0] crs1, crs2;
    model_do_read_cpr(dec_arg_crs1, crs1);
    model_do_read_cpr(dec_arg_crs2, crs2);
    $display("ISE> ERROR: Instruction rot.px not implemented");
end endtask


//
// Implementation function for the slli.px instruction.
//
task model_do_slli_px;
begin: t_model_slli_px
    reg  [31:0] crs1;
    model_do_read_cpr(dec_arg_crs1, crs1);
    $display("ISE> ERROR: Instruction slli.px not implemented");
end endtask


//
// Implementation function for the srli.px instruction.
//
task model_do_srli_px;
begin: t_model_srli_px
    reg  [31:0] crs1;
    model_do_read_cpr(dec_arg_crs1, crs1);
    $display("ISE> ERROR: Instruction srli.px not implemented");
end endtask


//
// Implementation function for the roti.px instruction.
//
task model_do_roti_px;
begin: t_model_roti_px
    reg  [31:0] crs1;
    model_do_read_cpr(dec_arg_crs1, crs1);
    $display("ISE> ERROR: Instruction roti.px not implemented");
end endtask


//
// Implementation function for the rseed.cr instruction.
//
task model_do_rseed_cr;
begin: t_model_rseed_cr
    reg  [31:0] crs1;
    model_do_read_cpr(dec_arg_crs1, crs1);
    $display("ISE> ERROR: Instruction rseed.cr not implemented");
end endtask


//
// Implementation function for the rsamp.cr instruction.
//
task model_do_rsamp_cr;
begin: t_model_rsamp_cr
    $display("ISE> ERROR: Instruction rsamp.cr not implemented");
end endtask


//
// Implementation function for the cmov.cr instruction.
//
task model_do_cmov_cr;
begin: t_model_cmov_cr
    reg  [31:0] crs1, crs2;
    model_do_read_cpr(dec_arg_crs1, crs1);
    model_do_read_cpr(dec_arg_crs2, crs2);
    $display("ISE> ERROR: Instruction cmov.cr not implemented");
end endtask


//
// Implementation function for the cmovn.cr instruction.
//
task model_do_cmovn_cr;
begin: t_model_cmovn_cr
    reg  [31:0] crs1, crs2;
    model_do_read_cpr(dec_arg_crs1, crs1);
    model_do_read_cpr(dec_arg_crs2, crs2);
    $display("ISE> ERROR: Instruction cmovn.cr not implemented");
end endtask


//
// Implementation function for the scatter.b instruction.
//
task model_do_scatter_b;
begin: t_model_scatter_b
    reg  [31:0] crs2;
    model_do_read_cpr(dec_arg_crs2, crs2);
    $display("ISE> ERROR: Instruction scatter.b not implemented");
end endtask


//
// Implementation function for the gather.b instruction.
//
task model_do_gather_b;
begin: t_model_gather_b
    reg  [31:0] crs2;
    model_do_read_cpr(dec_arg_crs2, crs2);
    $display("ISE> ERROR: Instruction gather.b not implemented");
end endtask


//
// Implementation function for the scatter.h instruction.
//
task model_do_scatter_h;
begin: t_model_scatter_h
    reg  [31:0] crs2;
    model_do_read_cpr(dec_arg_crs2, crs2);
    $display("ISE> ERROR: Instruction scatter.h not implemented");
end endtask


//
// Implementation function for the gather.h instruction.
//
task model_do_gather_h;
begin: t_model_gather_h
    reg  [31:0] crs2;
    model_do_read_cpr(dec_arg_crs2, crs2);
    $display("ISE> ERROR: Instruction gather.h not implemented");
end endtask


//
// Implementation function for the lmix.cr instruction.
//
task model_do_lmix_cr;
begin: t_model_lmix_cr
    reg  [31:0] crs1, crs2;
    model_do_read_cpr(dec_arg_crs1, crs1);
    model_do_read_cpr(dec_arg_crs2, crs2);
    $display("ISE> ERROR: Instruction lmix.cr not implemented");
end endtask


//
// Implementation function for the hmix.cr instruction.
//
task model_do_hmix_cr;
begin: t_model_hmix_cr
    reg  [31:0] crs1, crs2;
    model_do_read_cpr(dec_arg_crs1, crs1);
    model_do_read_cpr(dec_arg_crs2, crs2);
    $display("ISE> ERROR: Instruction hmix.cr not implemented");
end endtask


//
// Implementation function for the bop.cr instruction.
//
task model_do_bop_cr;
begin: t_model_bop_cr
    reg  [31:0] crs1, crs2;
    model_do_read_cpr(dec_arg_crs1, crs1);
    model_do_read_cpr(dec_arg_crs2, crs2);
    $display("ISE> ERROR: Instruction bop.cr not implemented");
end endtask


//
// Implementation function for the equ.mp instruction.
//
task model_do_equ_mp;
begin: t_model_equ_mp
    reg  [31:0] crs1, crs2, crs3;
    model_do_read_cpr(dec_arg_crs1, crs1);
    model_do_read_cpr(dec_arg_crs2, crs2);
    model_do_read_cpr(dec_arg_crs3, crs3);
    $display("ISE> ERROR: Instruction equ.mp not implemented");
end endtask


//
// Implementation function for the ltu.mp instruction.
//
task model_do_ltu_mp;
begin: t_model_ltu_mp
    reg  [31:0] crs1, crs2, crs3;
    model_do_read_cpr(dec_arg_crs1, crs1);
    model_do_read_cpr(dec_arg_crs2, crs2);
    model_do_read_cpr(dec_arg_crs3, crs3);
    $display("ISE> ERROR: Instruction ltu.mp not implemented");
end endtask


//
// Implementation function for the gtu.mp instruction.
//
task model_do_gtu_mp;
begin: t_model_gtu_mp
    reg  [31:0] crs1, crs2, crs3;
    model_do_read_cpr(dec_arg_crs1, crs1);
    model_do_read_cpr(dec_arg_crs2, crs2);
    model_do_read_cpr(dec_arg_crs3, crs3);
    $display("ISE> ERROR: Instruction gtu.mp not implemented");
end endtask


//
// Implementation function for the add3.mp instruction.
//
task model_do_add3_mp;
begin: t_model_add3_mp
    reg  [31:0] crs1, crs2, crs3;
    model_do_read_cpr(dec_arg_crs1, crs1);
    model_do_read_cpr(dec_arg_crs2, crs2);
    model_do_read_cpr(dec_arg_crs3, crs3);
    $display("ISE> ERROR: Instruction add3.mp not implemented");
end endtask


//
// Implementation function for the add2.mp instruction.
//
task model_do_add2_mp;
begin: t_model_add2_mp
    reg  [31:0] crs1, crs2;
    model_do_read_cpr(dec_arg_crs1, crs1);
    model_do_read_cpr(dec_arg_crs2, crs2);
    $display("ISE> ERROR: Instruction add2.mp not implemented");
end endtask


//
// Implementation function for the sub3.mp instruction.
//
task model_do_sub3_mp;
begin: t_model_sub3_mp
    reg  [31:0] crs1, crs2, crs3;
    model_do_read_cpr(dec_arg_crs1, crs1);
    model_do_read_cpr(dec_arg_crs2, crs2);
    model_do_read_cpr(dec_arg_crs3, crs3);
    $display("ISE> ERROR: Instruction sub3.mp not implemented");
end endtask


//
// Implementation function for the sub2.mp instruction.
//
task model_do_sub2_mp;
begin: t_model_sub2_mp
    reg  [31:0] crs1, crs2;
    model_do_read_cpr(dec_arg_crs1, crs1);
    model_do_read_cpr(dec_arg_crs2, crs2);
    $display("ISE> ERROR: Instruction sub2.mp not implemented");
end endtask


//
// Implementation function for the slli.mp instruction.
//
task model_do_slli_mp;
begin: t_model_slli_mp
    reg  [31:0] crs1, crs2;
    model_do_read_cpr(dec_arg_crs1, crs1);
    model_do_read_cpr(dec_arg_crs2, crs2);
    $display("ISE> ERROR: Instruction slli.mp not implemented");
end endtask


//
// Implementation function for the sll.mp instruction.
//
task model_do_sll_mp;
begin: t_model_sll_mp
    reg  [31:0] crs1, crs2, crs3;
    model_do_read_cpr(dec_arg_crs1, crs1);
    model_do_read_cpr(dec_arg_crs2, crs2);
    model_do_read_cpr(dec_arg_crs3, crs3);
    $display("ISE> ERROR: Instruction sll.mp not implemented");
end endtask


//
// Implementation function for the srli.mp instruction.
//
task model_do_srli_mp;
begin: t_model_srli_mp
    reg  [31:0] crs1, crs2;
    model_do_read_cpr(dec_arg_crs1, crs1);
    model_do_read_cpr(dec_arg_crs2, crs2);
    $display("ISE> ERROR: Instruction srli.mp not implemented");
end endtask


//
// Implementation function for the srl.mp instruction.
//
task model_do_srl_mp;
begin: t_model_srl_mp
    reg  [31:0] crs1, crs2, crs3;
    model_do_read_cpr(dec_arg_crs1, crs1);
    model_do_read_cpr(dec_arg_crs2, crs2);
    model_do_read_cpr(dec_arg_crs3, crs3);
    $display("ISE> ERROR: Instruction srl.mp not implemented");
end endtask


//
// Implementation function for the acc2.mp instruction.
//
task model_do_acc2_mp;
begin: t_model_acc2_mp
    reg  [31:0] crs1, crs2;
    model_do_read_cpr(dec_arg_crs1, crs1);
    model_do_read_cpr(dec_arg_crs2, crs2);
    $display("ISE> ERROR: Instruction acc2.mp not implemented");
end endtask


//
// Implementation function for the acc1.mp instruction.
//
task model_do_acc1_mp;
begin: t_model_acc1_mp
    reg  [31:0] crs1;
    model_do_read_cpr(dec_arg_crs1, crs1);
    $display("ISE> ERROR: Instruction acc1.mp not implemented");
end endtask


//
// Implementation function for the mac.mp instruction.
//
task model_do_mac_mp;
begin: t_model_mac_mp
    reg  [31:0] crs1, crs2, crs3;
    model_do_read_cpr(dec_arg_crs1, crs1);
    model_do_read_cpr(dec_arg_crs2, crs2);
    model_do_read_cpr(dec_arg_crs3, crs3);
    $display("ISE> ERROR: Instruction mac.mp not implemented");
end endtask


//
// Implementation function for the lbu.cr instruction.
//
task model_do_lbu_cr;
begin: t_model_lbu_cr
    $display("ISE> ERROR: Instruction lbu.cr not implemented");
end endtask


//
// Implementation function for the lhu.cr instruction.
//
task model_do_lhu_cr;
begin: t_model_lhu_cr
    $display("ISE> ERROR: Instruction lhu.cr not implemented");
end endtask


//
// Implementation function for the lw.cr instruction.
//
task model_do_lw_cr;
begin: t_model_lw_cr
    $display("ISE> ERROR: Instruction lw.cr not implemented");
end endtask


//
// Implementation function for the lui.cr instruction.
//
task model_do_lui_cr;
begin: t_model_lui_cr
    $display("ISE> ERROR: Instruction lui.cr not implemented");
end endtask


//
// Implementation function for the lli.cr instruction.
//
task model_do_lli_cr;
begin: t_model_lli_cr
    $display("ISE> ERROR: Instruction lli.cr not implemented");
end endtask


//
// Implementation function for the twid.b instruction.
//
task model_do_twid_b;
begin: t_model_twid_b
    reg  [31:0] crs1;
    model_do_read_cpr(dec_arg_crs1, crs1);
    $display("ISE> ERROR: Instruction twid.b not implemented");
end endtask


//
// Implementation function for the twid.n0 instruction.
//
task model_do_twid_n0;
begin: t_model_twid_n0
    reg  [31:0] crs1;
    model_do_read_cpr(dec_arg_crs1, crs1);
    $display("ISE> ERROR: Instruction twid.n0 not implemented");
end endtask


//
// Implementation function for the twid.n1 instruction.
//
task model_do_twid_n1;
begin: t_model_twid_n1
    reg  [31:0] crs1;
    model_do_read_cpr(dec_arg_crs1, crs1);
    $display("ISE> ERROR: Instruction twid.n1 not implemented");
end endtask


//
// Implementation function for the twid.c0 instruction.
//
task model_do_twid_c0;
begin: t_model_twid_c0
    reg  [31:0] crs1;
    model_do_read_cpr(dec_arg_crs1, crs1);
    $display("ISE> ERROR: Instruction twid.c0 not implemented");
end endtask


//
// Implementation function for the twid.c1 instruction.
//
task model_do_twid_c1;
begin: t_model_twid_c1
    reg  [31:0] crs1;
    model_do_read_cpr(dec_arg_crs1, crs1);
    $display("ISE> ERROR: Instruction twid.c1 not implemented");
end endtask


//
// Implementation function for the twid.c2 instruction.
//
task model_do_twid_c2;
begin: t_model_twid_c2
    reg  [31:0] crs1;
    model_do_read_cpr(dec_arg_crs1, crs1);
    $display("ISE> ERROR: Instruction twid.c2 not implemented");
end endtask


//
// Implementation function for the twid.c3 instruction.
//
task model_do_twid_c3;
begin: t_model_twid_c3
    reg  [31:0] crs1;
    model_do_read_cpr(dec_arg_crs1, crs1);
    $display("ISE> ERROR: Instruction twid.c3 not implemented");
end endtask


//
// Implementation function for the ins.cr instruction.
//
task model_do_ins_cr;
begin: t_model_ins_cr
    reg  [31:0] crs1;
    model_do_read_cpr(dec_arg_crs1, crs1);
    $display("ISE> ERROR: Instruction ins.cr not implemented");
end endtask


//
// Implementation function for the ext.cr instruction.
//
task model_do_ext_cr;
begin: t_model_ext_cr
    reg  [31:0] crs1;
    model_do_read_cpr(dec_arg_crs1, crs1);
    $display("ISE> ERROR: Instruction ext.cr not implemented");
end endtask


//
// Implementation function for the sb.cr instruction.
//
task model_do_sb_cr;
begin: t_model_sb_cr
    reg  [31:0] crs2;
    model_do_read_cpr(dec_arg_crs2, crs2);
    $display("ISE> ERROR: Instruction sb.cr not implemented");
end endtask


//
// Implementation function for the sh.cr instruction.
//
task model_do_sh_cr;
begin: t_model_sh_cr
    reg  [31:0] crs2;
    model_do_read_cpr(dec_arg_crs2, crs2);
    $display("ISE> ERROR: Instruction sh.cr not implemented");
end endtask


//
// Implementation function for the sw.cr instruction.
//
task model_do_sw_cr;
begin: t_model_sw_cr
    reg  [31:0] crs2;
    model_do_read_cpr(dec_arg_crs2, crs2);
    $display("ISE> ERROR: Instruction sw.cr not implemented");
end endtask




// ------------------------------------------------------------------------

//
// Model Control
//
//  This process implements the main model control loop. It runs once every
//  clock tick, and models a single instruction or action every cycle.
//
always @(posedge g_clk) begin : p_model_control

    if(!g_resetn) begin
        
        model_do_reset();

    end else if(cop_insn_valid) begin

        // Reset model outputs ready for new instruction.
        model_do_clear_outputs();
        
        if (dec_invalid_opcode) model_do_invalid_opcode();
        else if (dec_mv2gpr     ) model_do_mv2gpr     ();
        else if (dec_mv2cop     ) model_do_mv2cop     ();
        else if (dec_add_px     ) model_do_add_px     ();
        else if (dec_sub_px     ) model_do_sub_px     ();
        else if (dec_mul_px     ) model_do_mul_px     ();
        else if (dec_sll_px     ) model_do_sll_px     ();
        else if (dec_srl_px     ) model_do_srl_px     ();
        else if (dec_rot_px     ) model_do_rot_px     ();
        else if (dec_slli_px    ) model_do_slli_px    ();
        else if (dec_srli_px    ) model_do_srli_px    ();
        else if (dec_roti_px    ) model_do_roti_px    ();
        else if (dec_rseed_cr   ) model_do_rseed_cr   ();
        else if (dec_rsamp_cr   ) model_do_rsamp_cr   ();
        else if (dec_cmov_cr    ) model_do_cmov_cr    ();
        else if (dec_cmovn_cr   ) model_do_cmovn_cr   ();
        else if (dec_scatter_b  ) model_do_scatter_b  ();
        else if (dec_gather_b   ) model_do_gather_b   ();
        else if (dec_scatter_h  ) model_do_scatter_h  ();
        else if (dec_gather_h   ) model_do_gather_h   ();
        else if (dec_lmix_cr    ) model_do_lmix_cr    ();
        else if (dec_hmix_cr    ) model_do_hmix_cr    ();
        else if (dec_bop_cr     ) model_do_bop_cr     ();
        else if (dec_equ_mp     ) model_do_equ_mp     ();
        else if (dec_ltu_mp     ) model_do_ltu_mp     ();
        else if (dec_gtu_mp     ) model_do_gtu_mp     ();
        else if (dec_add3_mp    ) model_do_add3_mp    ();
        else if (dec_add2_mp    ) model_do_add2_mp    ();
        else if (dec_sub3_mp    ) model_do_sub3_mp    ();
        else if (dec_sub2_mp    ) model_do_sub2_mp    ();
        else if (dec_slli_mp    ) model_do_slli_mp    ();
        else if (dec_sll_mp     ) model_do_sll_mp     ();
        else if (dec_srli_mp    ) model_do_srli_mp    ();
        else if (dec_srl_mp     ) model_do_srl_mp     ();
        else if (dec_acc2_mp    ) model_do_acc2_mp    ();
        else if (dec_acc1_mp    ) model_do_acc1_mp    ();
        else if (dec_mac_mp     ) model_do_mac_mp     ();
        else if (dec_lbu_cr     ) model_do_lbu_cr     ();
        else if (dec_lhu_cr     ) model_do_lhu_cr     ();
        else if (dec_lw_cr      ) model_do_lw_cr      ();
        else if (dec_lui_cr     ) model_do_lui_cr     ();
        else if (dec_lli_cr     ) model_do_lli_cr     ();
        else if (dec_twid_b     ) model_do_twid_b     ();
        else if (dec_twid_n0    ) model_do_twid_n0    ();
        else if (dec_twid_n1    ) model_do_twid_n1    ();
        else if (dec_twid_c0    ) model_do_twid_c0    ();
        else if (dec_twid_c1    ) model_do_twid_c1    ();
        else if (dec_twid_c2    ) model_do_twid_c2    ();
        else if (dec_twid_c3    ) model_do_twid_c3    ();
        else if (dec_ins_cr     ) model_do_ins_cr     ();
        else if (dec_ext_cr     ) model_do_ext_cr     ();
        else if (dec_sb_cr      ) model_do_sb_cr      ();
        else if (dec_sh_cr      ) model_do_sh_cr      ();
        else if (dec_sw_cr      ) model_do_sw_cr      ();
        else begin
            $display("ERROR: We should never reach here!");
        end

    end

end

endmodule

