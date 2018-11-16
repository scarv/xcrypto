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


`VTX_CHECKER_MODULE_BEGIN(instr_aessub_decrot)

// AES Inverse sbox function.
`include "fml_aes_aux.vh"

wire [7:0] t0_in = `CRS1[ 7: 0];
wire [7:0] t1_in = `CRS2[15: 8];
wire [7:0] t2_in = `CRS1[23:16];
wire [7:0] t3_in = `CRS2[31:24];

wire [7:0] t0 = sbox_inv(t0_in);
wire [7:0] t1 = sbox_inv(t1_in);
wire [7:0] t2 = sbox_inv(t2_in);
wire [7:0] t3 = sbox_inv(t3_in);

wire [31:0] aes_subdec_rot_expected = {t2,t1,t0,t3};

//
// aes_sub_decrot
//
`VTX_CHECK_INSTR_BEGIN(aessub_decrot) 
    
    `VTX_ASSERT_CRD_VALUE_IS(aes_subdec_rot_expected);
    
    // Always succeeds
    `VTX_ASSERT_RESULT_IS(SCARV_COP_INSN_SUCCESS)

    // Never writes to GPRS
    `VTX_ASSERT_WEN_IS_CLEAR
    
`VTX_CHECK_INSTR_END(aes_sub_decrot)

`VTX_CHECKER_MODULE_END(instr_aessub_decrot)
