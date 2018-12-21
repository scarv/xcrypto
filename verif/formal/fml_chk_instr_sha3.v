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


`VTX_CHECKER_MODULE_BEGIN(instr_sha3)

wire [1:0] shamt  = dec_arg_b0;

wire [4:0] x = {2'b0,vtx_instr_rs1[2:0]};
wire [4:0] y = {2'b0,vtx_instr_rs2[2:0]};

wire [31:0] sha3_xy_result = ((x  )%5 + 5*((      y)%5)) << shamt;
wire [31:0] sha3_x1_result = ((x+1)%5 + 5*((      y)%5)) << shamt;
wire [31:0] sha3_x2_result = ((x+2)%5 + 5*((      y)%5)) << shamt;
wire [31:0] sha3_x4_result = ((x+4)%5 + 5*((      y)%5)) << shamt;
wire [31:0] sha3_yx_result = ((y  )%5 + 5*((2*x+3*y)%5)) << shamt;

//
// sha3_xy
//
`VTX_CHECK_INSTR_BEGIN(sha3_xy) 
    
    `VTX_ASSERT_RESULT_IS(SCARV_COP_INSN_SUCCESS)
    `VTX_ASSERT_WEN_IS_SET
    `VTX_ASSERT_WDATA_IS(sha3_xy_result )
    `VTX_ASSERT_WADDR_IS(dec_arg_rd  )

`VTX_CHECK_INSTR_END(sha3_xy)

//
// sha3_x1
//
`VTX_CHECK_INSTR_BEGIN(sha3_x1) 
    
    `VTX_ASSERT_RESULT_IS(SCARV_COP_INSN_SUCCESS)
    `VTX_ASSERT_WEN_IS_SET
    `VTX_ASSERT_WDATA_IS(sha3_x1_result )
    `VTX_ASSERT_WADDR_IS(dec_arg_rd  )

`VTX_CHECK_INSTR_END(sha3_x1)

//
// sha3_x2
//
`VTX_CHECK_INSTR_BEGIN(sha3_x2) 
    
    `VTX_ASSERT_RESULT_IS(SCARV_COP_INSN_SUCCESS)
    `VTX_ASSERT_WEN_IS_SET
    `VTX_ASSERT_WDATA_IS(sha3_x2_result )
    `VTX_ASSERT_WADDR_IS(dec_arg_rd  )

`VTX_CHECK_INSTR_END(sha3_x2)

//
// sha3_x4
//
`VTX_CHECK_INSTR_BEGIN(sha3_x4) 
    
    `VTX_ASSERT_RESULT_IS(SCARV_COP_INSN_SUCCESS)
    `VTX_ASSERT_WEN_IS_SET
    `VTX_ASSERT_WDATA_IS(sha3_x4_result )
    `VTX_ASSERT_WADDR_IS(dec_arg_rd  )

`VTX_CHECK_INSTR_END(sha3_x4)

//
// sha3_yx
//
`VTX_CHECK_INSTR_BEGIN(sha3_yx) 
    
    `VTX_ASSERT_RESULT_IS(SCARV_COP_INSN_SUCCESS)
    `VTX_ASSERT_WEN_IS_SET
    `VTX_ASSERT_WDATA_IS(sha3_yx_result )
    `VTX_ASSERT_WADDR_IS(dec_arg_rd  )

`VTX_CHECK_INSTR_END(sha3_xy)

`VTX_CHECKER_MODULE_END
