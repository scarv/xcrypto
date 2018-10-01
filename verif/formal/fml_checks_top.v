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

`include "fml_common.vh"
`include "scarv_cop_common.vh"

`ifdef FORMAL
`include "fml_common.vh"
`endif

//
// module: fml_checks_top
//
//  The top level for all of the formal checks.
//
module fml_checks_top (

input wire        vtx_clk                  ,

`VTX_REGISTER_PORTS_IN(vtx_cprs_pre )
`VTX_REGISTER_PORTS_IN(vtx_cprs_post)

input wire [ 0:0] vtx_reset                ,
input wire [ 0:0] vtx_valid                ,
input wire [31:0] vtx_instr_enc            ,
input wire [31:0] vtx_instr_rs1            ,
input wire [ 2:0] vtx_instr_result         ,
input wire [31:0] vtx_instr_wdata          ,
input wire [ 4:0] vtx_instr_waddr          ,
input wire [ 0:0] vtx_instr_wen            ,

);

wire [31:0] encoded = vtx_instr_enc;

//
// Include the trusted generated decoder
`include "ise_decode.v"

wire [31:0] vtx_cprs_pre [15:0];
wire [31:0] vtx_cprs_post[15:0];

`VTX_REGISTER_PORTS_ASSIGN(vtx_cprs_pre , vtx_cprs_pre )
`VTX_REGISTER_PORTS_ASSIGN(vtx_cprs_post, vtx_cprs_post)

//
// Check we only ever get the right result encodings from instructions.
//
`VTX_CHECK_BEGIN(correct_result_encodings)
    assert(
        vtx_instr_result == SCARV_COP_INSN_SUCCESS ||
        vtx_instr_result == SCARV_COP_INSN_ABORT   ||
        vtx_instr_result == SCARV_COP_INSN_BAD_INS ||
        vtx_instr_result == SCARV_COP_INSN_BAD_LAD ||
        vtx_instr_result == SCARV_COP_INSN_BAD_SAD ||
        vtx_instr_result == SCARV_COP_INSN_LD_ERR  ||
        vtx_instr_result == SCARV_COP_INSN_ST_ERR 
    );
`VTX_CHECK_END(correct_result_encodings)


//
// Check that we always correctly get a BAD_INS result on an invalid opcode.
//
`VTX_CHECK_BEGIN(correct_invalid_opcode_response)
    if(dec_invalid_opcode) begin
        assert(vtx_instr_result == SCARV_COP_INSN_BAD_INS);
    end else begin
        assert(vtx_instr_result != SCARV_COP_INSN_BAD_INS);
    end
`VTX_CHECK_END(correct_invalid_opcode_response)


// ----------------------------------------------------------------------
//
// Instruction Checks
//

`VTX_CHECK_INSTR_BEGIN(mv2cop) 
    assert(vtx_cprs_post[dec_arg_crd] == vtx_instr_rs1);
    assert(vtx_instr_result == SCARV_COP_INSN_SUCCESS);
    assert(vtx_instr_wen    == 1'b0);
`VTX_CHECK_INSTR_END

endmodule

