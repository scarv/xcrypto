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

`include "fml_pack_widths.vh"

`VTX_CHECKER_MODULE_BEGIN(instr_mgte)

reg value;


//
// mgte
//
`VTX_CHECK_INSTR_BEGIN(mgte) 

    `VTX_ASSERT_RESULT_IS(SCARV_COP_INSN_SUCCESS)

    value = ((`CRS2 == `CRS3) && vtx_instr_rs1) ||
             (`CRS2 >  `CRS3)                   ;

    // Always causes writeback to GPRS
    `VTX_ASSERT_WEN_IS_SET
    
    // Writeback to the correct GPR
    `VTX_ASSERT_WADDR_IS(dec_arg_rd);

    // WDATA is the single bit compare result zero padded to 32-bits.
    `VTX_ASSERT_WDATA_IS({31'b0,value});

`VTX_CHECK_INSTR_END(mgte)

`VTX_CHECKER_MODULE_END


