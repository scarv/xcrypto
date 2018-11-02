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

`VTX_CHECKER_MODULE_BEGIN(instr_mclmul_1)

wire [63:0] in_crs1 = {32'b0,`CRS1};

reg  [63:0] xor_value;
reg  [63:0] final_value;

integer i;

always @(*) begin
    // Compute carryless CRS1 * CRS2
    xor_value = 0;
    for(i = 0; i < 32; i = i + 1) begin
        if(`CRS2[i]) begin
            xor_value = xor_value ^ (in_crs1 << i);
        end
    end

    final_value = xor_value + `CRS3;

end

//
// mclmul_1
//
`VTX_CHECK_INSTR_BEGIN(mclmul_1) 

    // MCLMUL_1 never causes exceptions
    `VTX_ASSERT_RESULT_IS(SCARV_COP_INSN_SUCCESS)
    
    // 64 bit register value check.
    `VTX_ASSERT(vtx_crdm_val_post == final_value);

    // Never causes writeback to GPRS
    `VTX_ASSERT_WEN_IS_CLEAR

`VTX_CHECK_INSTR_END(mclmul_1)

`VTX_CHECKER_MODULE_END

