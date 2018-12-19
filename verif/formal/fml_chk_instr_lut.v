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

`VTX_CHECKER_MODULE_BEGIN(instr_lut)

wire [63:0] lut_flat = {`CRS3, `CRS2};
wire [3:0]  lut[15:0];
wire [31:0] lut_result;

genvar i;
generate for(i = 0; i < 16; i = i + 1) begin
    
    assign lut[i] = lut_flat[(4*i)+3:4*i];

    if(i < 8) begin
        assign lut_result[(4*i)+3:4*i] = lut[`CRS1[(4*i)+3:4*i]];
    end

end endgenerate

//
// lut
//
`VTX_CHECK_INSTR_BEGIN(lut) 

    // Result comes from the PACK_WIDTH_ARITH_OPERATION_RESULT macro.
    `VTX_ASSERT_CRD_VALUE_IS(lut_result)

    // Never causes writeback to GPRS
    `VTX_ASSERT_WEN_IS_CLEAR

`VTX_CHECK_INSTR_END(lut)

`VTX_CHECKER_MODULE_END
