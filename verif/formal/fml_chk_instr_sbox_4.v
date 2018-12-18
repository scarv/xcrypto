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

`VTX_CHECKER_MODULE_BEGIN(instr_sbox_4)

wire [63:0] sbox_flat = {`CRS3, `CRS2};
wire [3:0]  sbox[15:0];
wire [31:0] sbox_4_result;

genvar i;
generate for(i = 0; i < 15; i = i + 1) begin
    
    assign sbox[i] = sbox_flat[(4*i)+3:4*i];

    if(i < 8) begin
        assign sbox_4_result[(4*i)+3:4*i] = sbox[i];
    end

end endgenerate

//
// sbox_4
//
`VTX_CHECK_INSTR_BEGIN(sbox_4) 

    // Result comes from the PACK_WIDTH_ARITH_OPERATION_RESULT macro.
    `VTX_ASSERT_CRD_VALUE_IS(sbox_4_result)

    // Never causes writeback to GPRS
    `VTX_ASSERT_WEN_IS_CLEAR

`VTX_CHECK_INSTR_END(sbox_4)

`VTX_CHECKER_MODULE_END
