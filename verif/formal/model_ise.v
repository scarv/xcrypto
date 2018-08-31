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
// Output modelling signals
output reg  [ 2:0]      cop_result        // Instruction execution result

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

reg [31:0] model_cprs [15:0];
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

end endtask

//
// Implements ISE functionality when we encounter an invalid opcode.
task model_do_invalid_opcode;
begin

    $display("ISE> Invalid Opcode: %h", encoded);

end endtask 


// ------------------------------------------------------------------------

//
// Instruction Implementations
//

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
        
        if(dec_invalid_opcode) model_do_invalid_opcode();
        else begin
            $display("ERROR: We should never reach here!");
        end

    end

end

endmodule

