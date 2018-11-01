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
wire [63:0] in_crs2 = {32'b0,`CRS2};
wire [63:0] in_crs3 = {32'b0,`CRS3};

reg  [63:0] value;

integer i;

always @(*) begin
    // Compute carryless CRS1 * CRS2
    value = in_crs1;
    for(i = 0; i < 32; i = i + 1) begin
        value = value ^ (in_crs2 << i);
    end

    // Compute carryless (value) * CRS3
    for(i = 0; i < 32; i = i + 1) begin
        value = value ^ (in_crs3 << i);
    end

end

//
// mclmul_1
//
`VTX_CHECK_INSTR_BEGIN(mclmul_1) 

    // MCLMUL_1 never causes exceptions
    `VTX_ASSERT_RESULT_IS(SCARV_COP_INSN_SUCCESS)
    
    // 64 bit register value check.
    `VTX_ASSERT(vtx_crdm_val_post == value);

    // Never causes writeback to GPRS
    `VTX_ASSERT_WEN_IS_CLEAR

`VTX_CHECK_INSTR_END(mclmul_1)

`VTX_CHECKER_MODULE_END

