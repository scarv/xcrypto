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
// file: fml_pack_widths.vh
//
//  Contains various macros for verifying packed arithmetic operations.
//


//
// Pull the pack width encoding from an instruction.
//
`define VTX_INSTR_PACK_WIDTH \
    {vtx_instr_enc[24],vtx_instr_enc[19],vtx_instr_enc[11]}

//
// Checks that the pack width encoding of an instruction is correct, in
// which case expect the SUCCESS result. Otherwise expect BAD_INS.
//
`define VTX_ASSERT_PACK_WIDTH_CORRECT if ( \
        `VTX_INSTR_PACK_WIDTH == 3'b000 || \
        `VTX_INSTR_PACK_WIDTH == 3'b001 || \
        `VTX_INSTR_PACK_WIDTH == 3'b010 || \
        `VTX_INSTR_PACK_WIDTH == 3'b011 || \
        `VTX_INSTR_PACK_WIDTH == 3'b100   \
    ) begin \
        `VTX_ASSERT_RESULT_IS(SCARV_COP_INSN_SUCCESS) \
    end else begin \
        `VTX_ASSERT_RESULT_IS(SCARV_COP_INSN_BAD_INS) \
    end \


//
// Rotate pack width operation macro
//
//      Applies "OP" to the right sizes of data type and then writes
//      the results back,
//
`define PACK_WIDTH_ROTATE_RIGHT_OPERATION(AMNT) \
reg [31:0] result15, result14, result13, result12, result11, \
           result10, result9 , result8 , result7 , result6 , \
           result5 , result4 , result3 , result2 , result1 , \
           result0 ; \
reg [31:0] result; \
always @(*) begin \
    result15 = 0; result14 = 0; result13 = 0; result12 = 0; result11 = 0; \
    result10 = 0; result9  = 0; result8  = 0; result7  = 0; result6  = 0; \
    result5  = 0; result4  = 0; result3  = 0; result2  = 0; result1  = 0; \
    result0  = 0; result   = 0; \
    if(pw == SCARV_COP_PW_1) begin \
        result = {2{`CRS1}} >> AMNT; \
    end else if(pw == SCARV_COP_PW_2) begin \
        result1 = {4{`CRS1[31:16]}} >> AMNT; \
        result0 = {4{`CRS1[15: 0]}} >> AMNT; \
        result = {result1[15: 0],result0[15: 0]}; \
    end else if(pw ==  SCARV_COP_PW_4) begin \
        result3 = {8{`CRS1[31:24]}} >> AMNT; \
        result2 = {8{`CRS1[23:16]}} >> AMNT; \
        result1 = {8{`CRS1[15: 8]}} >> AMNT; \
        result0 = {8{`CRS1[ 7: 0]}} >> AMNT; \
        result  = {result3[7:0],result2[7:0],result1[7:0],result0[7:0]};\
    end else if(pw ==  SCARV_COP_PW_8) begin \
        result7 = {16{`CRS1[31:28]}} >> AMNT; \
        result6 = {16{`CRS1[27:24]}} >> AMNT; \
        result5 = {16{`CRS1[23:20]}} >> AMNT; \
        result4 = {16{`CRS1[19:16]}} >> AMNT; \
        result3 = {16{`CRS1[15:12]}} >> AMNT; \
        result2 = {16{`CRS1[11: 8]}} >> AMNT; \
        result1 = {16{`CRS1[ 7: 4]}} >> AMNT; \
        result0 = {16{`CRS1[ 3: 0]}} >> AMNT; \
        result  = {result7[3:0],result6[3:0],result5[3:0],result4[3:0],  \
                   result3[3:0],result2[3:0],result1[3:0],result0[3:0]}; \
    end else if(pw ==  SCARV_COP_PW_16) begin \
        result15 = {32{`CRS1[31:30]}} >> AMNT; \
        result14 = {32{`CRS1[29:28]}} >> AMNT; \
        result13 = {32{`CRS1[27:26]}} >> AMNT; \
        result12 = {32{`CRS1[25:24]}} >> AMNT; \
        result11 = {32{`CRS1[23:22]}} >> AMNT; \
        result10 = {32{`CRS1[21:20]}} >> AMNT; \
        result9  = {32{`CRS1[19:18]}} >> AMNT; \
        result8  = {32{`CRS1[17:16]}} >> AMNT; \
        result7  = {32{`CRS1[15:14]}} >> AMNT; \
        result6  = {32{`CRS1[13:12]}} >> AMNT; \
        result5  = {32{`CRS1[11:10]}} >> AMNT; \
        result4  = {32{`CRS1[ 9: 8]}} >> AMNT; \
        result3  = {32{`CRS1[ 7: 6]}} >> AMNT; \
        result2  = {32{`CRS1[ 5: 4]}} >> AMNT; \
        result1  = {32{`CRS1[ 3: 2]}} >> AMNT; \
        result0  = {32{`CRS1[ 1: 0]}} >> AMNT; \
        result  = {result15[1:0],result14[1:0],result13[1:0],result12[1:0], \
                   result11[1:0],result10[1:0],result9 [1:0],result8 [1:0], \
                   result7 [1:0],result6 [1:0],result5 [1:0],result4 [1:0], \
                   result3 [1:0],result2 [1:0],result1 [1:0],result0 [1:0]};\
    end \
end \


//
// Shift pack width operation macro
//
//      Applies "OP" to the right sizes of data type and then writes
//      the results back,
//
`define PACK_WIDTH_SHIFT_OPERATION_RESULT(OP,AMNT) \
reg [31:0] result  ; \
always @(*) begin \
    result = 0; \
    if(pw == SCARV_COP_PW_1) begin \
        result = `CRS1 OP AMNT; \
    end else if(pw == SCARV_COP_PW_2) begin \
        result = {`CRS1[31:16] OP AMNT, \
                  `CRS1[15: 0] OP AMNT}; \
    end else if(pw ==  SCARV_COP_PW_4) begin \
        result = {`CRS1[31:24] OP AMNT, \
                  `CRS1[23:16] OP AMNT, \
                  `CRS1[15: 8] OP AMNT, \
                  `CRS1[ 7: 0] OP AMNT}; \
    end else if(pw ==  SCARV_COP_PW_8) begin \
        result = {`CRS1[31:28] OP AMNT, \
                  `CRS1[27:24] OP AMNT, \
                  `CRS1[23:20] OP AMNT, \
                  `CRS1[19:16] OP AMNT, \
                  `CRS1[15:12] OP AMNT, \
                  `CRS1[11: 8] OP AMNT, \
                  `CRS1[ 7: 4] OP AMNT, \
                  `CRS1[ 3: 0] OP AMNT}; \
    end else if(pw ==  SCARV_COP_PW_16) begin \
        result = {`CRS1[31:30] OP AMNT, \
                  `CRS1[29:28] OP AMNT, \
                  `CRS1[27:26] OP AMNT, \
                  `CRS1[25:24] OP AMNT, \
                  `CRS1[23:22] OP AMNT, \
                  `CRS1[21:20] OP AMNT, \
                  `CRS1[19:18] OP AMNT, \
                  `CRS1[17:16] OP AMNT, \
                  `CRS1[15:14] OP AMNT, \
                  `CRS1[13:12] OP AMNT, \
                  `CRS1[11:10] OP AMNT, \
                  `CRS1[ 9: 8] OP AMNT, \
                  `CRS1[ 7: 6] OP AMNT, \
                  `CRS1[ 5: 4] OP AMNT, \
                  `CRS1[ 3: 2] OP AMNT, \
                  `CRS1[ 1: 0] OP AMNT}; \
    end \
end \


//
// Arithmetic pack width operation macro
//
//      Applies "OP" to the right sizes of data type and then writes
//      the results back,
//
//      If "HI" is set, the high half of the X bit partial result is
//      selected for the final packed result. Otherwise the low half
//      is used. This is used to represent the high and low packed
//      multiply operations.
//
//      Makes the register "result" available for checking the result of
//      A packed arithmetic operation.
//
`define PACK_WIDTH_ARITH_OPERATION_RESULT(OP,HI) \
reg [63:0] result15, result14, result13, result12, result11, \
           result10, result9 , result8 , result7 , result6 , \
           result5 , result4 , result3 , result2 , result1 , \
           result0 ; \
reg [31:0] result  ; \
always @(*) begin \
    result15 = 0; result14 = 0; result13 = 0; result12 = 0; result11 = 0; \
    result10 = 0; result9  = 0; result8  = 0; result7  = 0; result6  = 0; \
    result5  = 0; result4  = 0; result3  = 0; result2  = 0; result1  = 0; \
    result0  = 0; result   = 0; \
    if(pw == SCARV_COP_PW_1) begin \
        result0 = `CRS1 OP `CRS2; \
        result  = HI ?       \
            result0[63:32] : \
            result0[31: 0] ; \
    end else if(pw == SCARV_COP_PW_2) begin \
        result1 = `CRS1[31:16] OP `CRS2[31:16]; \
        result0 = `CRS1[15: 0] OP `CRS2[15: 0]; \
        result = HI ? \
            {result1[31:16],result0[31:16]} : \
            {result1[15: 0],result0[15: 0]} ; \
    end else if(pw ==  SCARV_COP_PW_4) begin \
        result3 = `CRS1[31:24] OP `CRS2[31:24]; \
        result2 = `CRS1[23:16] OP `CRS2[23:16]; \
        result1 = `CRS1[15: 8] OP `CRS2[15: 8]; \
        result0 = `CRS1[ 7: 0] OP `CRS2[ 7: 0]; \
        result  = HI ?                                             \
            {result3[15:8],result2[15:8],result1[15:8],result0[15:8]}: \
            {result3[7 :0],result2[ 7:0],result1[ 7:0],result0[ 7:0]}; \
    end else if(pw ==  SCARV_COP_PW_8) begin \
        result7 = `CRS1[31:28] OP `CRS2[31:28]; \
        result6 = `CRS1[27:24] OP `CRS2[27:24]; \
        result5 = `CRS1[23:20] OP `CRS2[23:20]; \
        result4 = `CRS1[19:16] OP `CRS2[19:16]; \
        result3 = `CRS1[15:12] OP `CRS2[15:12]; \
        result2 = `CRS1[11: 8] OP `CRS2[11: 8]; \
        result1 = `CRS1[ 7: 4] OP `CRS2[ 7: 4]; \
        result0 = `CRS1[ 3: 0] OP `CRS2[ 3: 0]; \
        result  = HI ?                                                   \
                  {result7[7:4],result6[7:4],result5[7:4],result4[7:4],  \
                   result3[7:4],result2[7:4],result1[7:4],result0[7:4]}: \
                  {result7[3:0],result6[3:0],result5[3:0],result4[3:0],  \
                   result3[3:0],result2[3:0],result1[3:0],result0[3:0]}; \
    end else if(pw ==  SCARV_COP_PW_16) begin \
        result15 = `CRS1[31:30] OP `CRS2[31:30]; \
        result14 = `CRS1[29:28] OP `CRS2[29:28]; \
        result13 = `CRS1[27:26] OP `CRS2[27:26]; \
        result12 = `CRS1[25:24] OP `CRS2[25:24]; \
        result11 = `CRS1[23:22] OP `CRS2[23:22]; \
        result10 = `CRS1[21:20] OP `CRS2[21:20]; \
        result9  = `CRS1[19:18] OP `CRS2[19:18]; \
        result8  = `CRS1[17:16] OP `CRS2[17:16]; \
        result7  = `CRS1[15:14] OP `CRS2[15:14]; \
        result6  = `CRS1[13:12] OP `CRS2[13:12]; \
        result5  = `CRS1[11:10] OP `CRS2[11:10]; \
        result4  = `CRS1[ 9: 8] OP `CRS2[ 9: 8]; \
        result3  = `CRS1[ 7: 6] OP `CRS2[ 7: 6]; \
        result2  = `CRS1[ 5: 4] OP `CRS2[ 5: 4]; \
        result1  = `CRS1[ 3: 2] OP `CRS2[ 3: 2]; \
        result0  = `CRS1[ 1: 0] OP `CRS2[ 1: 0]; \
        result  = HI ?                                                      \
              {result15[3:2],result14[3:2],result13[3:2],result12[3:2],   \
               result11[3:2],result10[3:2],result9 [3:2],result8 [3:2],   \
               result7 [3:2],result6 [3:2],result5 [3:2],result4 [3:2],   \
               result3 [3:2],result2 [3:2],result1 [3:2],result0 [3:2]} : \
              {result15[1:0],result14[1:0],result13[1:0],result12[1:0],   \
               result11[1:0],result10[1:0],result9 [1:0],result8 [1:0],   \
               result7 [1:0],result6 [1:0],result5 [1:0],result4 [1:0],   \
               result3 [1:0],result2 [1:0],result1 [1:0],result0 [1:0]} ; \
    end \
end \


//
// Implement a 32x32 carryless multiply expression.
//
`define PW_CLMUL32(A,B,W) ({{64-W{1'b0}},A} ^ \
    ({{64-W{1'b0}},B} << 0 ) ^              \
    ({{64-W{1'b0}},B} << 1 ) ^              \
    ({{64-W{1'b0}},B} << 2 ) ^              \
    ({{64-W{1'b0}},B} << 3 ) ^              \
    ({{64-W{1'b0}},B} << 4 ) ^              \
    ({{64-W{1'b0}},B} << 5 ) ^              \
    ({{64-W{1'b0}},B} << 6 ) ^              \
    ({{64-W{1'b0}},B} << 7 ) ^              \
    ({{64-W{1'b0}},B} << 8 ) ^              \
    ({{64-W{1'b0}},B} << 9 ) ^              \
    ({{64-W{1'b0}},B} << 10) ^              \
    ({{64-W{1'b0}},B} << 11) ^              \
    ({{64-W{1'b0}},B} << 12) ^              \
    ({{64-W{1'b0}},B} << 13) ^              \
    ({{64-W{1'b0}},B} << 14) ^              \
    ({{64-W{1'b0}},B} << 15) ^              \
    ({{64-W{1'b0}},B} << 16) ^              \
    ({{64-W{1'b0}},B} << 17) ^              \
    ({{64-W{1'b0}},B} << 18) ^              \
    ({{64-W{1'b0}},B} << 19) ^              \
    ({{64-W{1'b0}},B} << 20) ^              \
    ({{64-W{1'b0}},B} << 21) ^              \
    ({{64-W{1'b0}},B} << 22) ^              \
    ({{64-W{1'b0}},B} << 23) ^              \
    ({{64-W{1'b0}},B} << 24) ^              \
    ({{64-W{1'b0}},B} << 25) ^              \
    ({{64-W{1'b0}},B} << 26) ^              \
    ({{64-W{1'b0}},B} << 27) ^              \
    ({{64-W{1'b0}},B} << 28) ^              \
    ({{64-W{1'b0}},B} << 29) ^              \
    ({{64-W{1'b0}},B} << 30) ^              \
    ({{64-W{1'b0}},B} << 31) )

