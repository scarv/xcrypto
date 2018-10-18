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
// module: scarv_cop_palu
//
//  Combinatorial Packed arithmetic and shift module.
//
// notes:
//  - LMIX/HMIX expect crd value to be in palu_rs3
//  - LUI/LLI expect crd value to be in palu_rs3
//  - INS expects crd value to be in palu_rs3
//
module scarv_cop_palu (
input  wire         g_clk            ,
input  wire         g_resetn         ,

input  wire         palu_ivalid      , // Valid instruction input
output wire         palu_idone       , // Instruction complete

input  wire [31:0]  gpr_rs1          , // GPR Source register 1
input  wire [31:0]  palu_rs1         , // Source register 1
input  wire [31:0]  palu_rs2         , // Source register 2
input  wire [31:0]  palu_rs3         , // Source register 3

input  wire [31:0]  id_imm           , // Source immedate
input  wire [ 2:0]  id_pw            , // Pack width
input  wire [ 2:0]  id_class         , // Instruction class
input  wire [ 3:0]  id_subclass      , // Instruction subclass

output wire [ 3:0]  palu_cpr_rd_ben  , // Writeback byte enable
output wire [31:0]  palu_cpr_rd_wdata  // Writeback data
);

// Commom field name and values.
`include "scarv_cop_common.vh"

// Purely combinatoral block.
assign palu_idone = palu_ivalid &&
                    (is_mul_px ? pmul_done : 1'b1);

// Detect which subclass of instruction to execute.
wire is_mov_insn  = 
    palu_ivalid && id_class == SCARV_COP_ICLASS_MOVE;

wire is_bitwise_insn = 
    palu_ivalid && id_class == SCARV_COP_ICLASS_BITWISE;

wire is_parith_insn = 
    palu_ivalid && id_class == SCARV_COP_ICLASS_PACKED_ARITH;

wire is_twid_insn = 
    palu_ivalid && id_class == SCARV_COP_ICLASS_TWIDDLE;

//
// Result data muxing
assign palu_cpr_rd_wdata = 
    {32{is_mov_insn     }} & result_cmov    |
    {32{is_bitwise_insn }} & result_bitwise |
    {32{is_parith_insn  }} & result_parith  |
    {32{is_twid_insn    }} & result_twid    ;

//
// Should the result be written back?
assign palu_cpr_rd_ben = {4{palu_idone}} & (
    is_mov_insn                                       ? {4{wen_cmov}} :
    is_bitwise_insn || is_parith_insn || is_twid_insn ? 4'hF          :
                                                        4'h0         );

// ----------------------------------------------------------------------

//
//  Conditional Move Instructions
//

wire        cmov_cond   = palu_rs2 == 0;
wire [31:0] result_cmov = is_gpr2xcr ? gpr_rs1 : palu_rs1;

wire        is_cmov   = is_mov_insn && id_subclass == SCARV_COP_SCLASS_CMOV  ;
wire        is_cmovn  = is_mov_insn && id_subclass == SCARV_COP_SCLASS_CMOVN ;
wire        is_gpr2xcr = is_mov_insn && id_subclass == SCARV_COP_SCLASS_GPR2XCR;

wire        wen_cmov    = 
        (is_gpr2xcr             ) ||
        (is_cmov  &&  cmov_cond) ||
        (is_cmovn && !cmov_cond)  ;

// ----------------------------------------------------------------------

//
//  Bitwise Instructions
//

wire bw_lmix_cr = is_bitwise_insn && id_subclass == SCARV_COP_SCLASS_LMIX_CR;
wire bw_hmix_cr = is_bitwise_insn && id_subclass == SCARV_COP_SCLASS_HMIX_CR;
wire bw_bop_cr  = is_bitwise_insn && id_subclass == SCARV_COP_SCLASS_BOP_CR ;
wire bw_ins_cr  = is_bitwise_insn && id_subclass == SCARV_COP_SCLASS_INS_CR ; 
wire bw_ext_cr  = is_bitwise_insn && id_subclass == SCARV_COP_SCLASS_EXT_CR ;
wire bw_lli_cr  = is_bitwise_insn && id_subclass == SCARV_COP_SCLASS_LLI_CR ;
wire bw_lui_cr  = is_bitwise_insn && id_subclass == SCARV_COP_SCLASS_LUI_CR ;

// Result computation for the BOP.cr instruction
wire [31:0] bop_result;
genvar br;
generate for (br = 0; br < 32; br = br + 1)
    assign bop_result[br] = id_imm[{palu_rs1[br],palu_rs2[br]}];
endgenerate

// Result computation for EXT / INST instructions
wire [ 4:0] ei_start    = {id_imm[7:4],1'b0};
wire [ 4:0] ei_len      = {id_imm[3:0],1'b0};

wire [31:0] ext_result  =
    (palu_rs1 >> ei_start) & ~(32'hFFFF_FFFF << ei_len);

wire [31:0] ins_mask    = 32'hFFFF_FFFF >> (32-ei_len);

wire [31:0] ins_result  =
    ((palu_rs1 & ins_mask) << ei_start) | 
    (palu_rs3 & ~(ins_mask << ei_start));

// Result computation for the MIX instructions
wire [ 4:0] mix_ramt = {bw_hmix_cr,id_imm[3:0]};

wire [31:0] mix_t0   =
    (palu_rs1 >> mix_ramt) | (palu_rs1 << (32-mix_ramt));

wire [31:0] mix_result =
    (palu_rs2 & mix_t0) | (~palu_rs2 & palu_rs3);

// AND/ORing the various bitwise results together.
wire [31:0] result_bitwise = 
    {32{bw_lli_cr }} & {palu_rs3[31:16], id_imm[15:0]    } |
    {32{bw_lui_cr }} & {id_imm[15:0]   , palu_rs3[15: 0] } |
    {32{bw_bop_cr }} & {bop_result                       } |
    {32{bw_bop_cr }} & {bop_result                       } |
    {32{bw_ext_cr }} & {ext_result                       } |
    {32{bw_ins_cr }} & {ins_result                       } |
    {32{bw_lmix_cr}} & {mix_result                       } |
    {32{bw_hmix_cr}} & {mix_result                       } ;

// ----------------------------------------------------------------------

//
//  Twiddle Instructions
//

wire twid_b  = is_twid_insn && id_subclass == SCARV_COP_SCLASS_TWID_B ;
wire twid_n0 = is_twid_insn && id_subclass == SCARV_COP_SCLASS_TWID_N0;
wire twid_n1 = is_twid_insn && id_subclass == SCARV_COP_SCLASS_TWID_N1;
wire twid_c0 = is_twid_insn && id_subclass == SCARV_COP_SCLASS_TWID_C0;
wire twid_c1 = is_twid_insn && id_subclass == SCARV_COP_SCLASS_TWID_C1;
wire twid_c2 = is_twid_insn && id_subclass == SCARV_COP_SCLASS_TWID_C2;
wire twid_c3 = is_twid_insn && id_subclass == SCARV_COP_SCLASS_TWID_C3;

// Input signals to the twiddle logic
wire [7:0] twid_b_in  [3:0];
wire [3:0] twid_n_in  [3:0];
wire [1:0] twid_c_in  [3:0];

// Output signals from the twiddle logic
wire [31:0] twid_b_out;
wire [15:0] twid_n_out;
wire [ 7:0] twid_c_out;

// Result signals for the writeback logic
wire [31:0] twid_b_result;
wire [31:0] twid_n_result;
wire [31:0] twid_c_result;

// Twiddle select indexes from instruction immediate
wire [1:0] b0  = id_imm[7:6];
wire [1:0] b1  = id_imm[5:4];
wire [1:0] b2  = id_imm[3:2];
wire [1:0] b3  = id_imm[1:0];

// Input halfword to twid.nX
wire [15:0] twid_n_hw = twid_n0 ? palu_rs1[15:0] : palu_rs1[31:16];

// Input byte to twid.cX
wire [ 7:0] twid_c_b  =
    {8{twid_c3}} & palu_rs1[31:24] |
    {8{twid_c2}} & palu_rs1[23:16] |
    {8{twid_c1}} & palu_rs1[15: 8] |
    {8{twid_c0}} & palu_rs1[ 7: 0] ;

// Twiddle byte input array
assign twid_b_in[3] = palu_rs1[31:24];
assign twid_b_in[2] = palu_rs1[23:16];
assign twid_b_in[1] = palu_rs1[15: 8];
assign twid_b_in[0] = palu_rs1[ 7: 0];

// Twiddle nibble input array
assign twid_n_in[3] = twid_n_hw[15:12];
assign twid_n_in[2] = twid_n_hw[11: 8];
assign twid_n_in[1] = twid_n_hw[ 7: 4];
assign twid_n_in[0] = twid_n_hw[ 3: 0];

// Twiddle crumb input array.
assign twid_c_in[3] = twid_c_b[7:6];
assign twid_c_in[2] = twid_c_b[5:4];
assign twid_c_in[1] = twid_c_b[3:2];
assign twid_c_in[0] = twid_c_b[1:0];

// Output array gathering
assign twid_b_out = 
    {twid_b_in[b3], twid_b_in[b2], twid_b_in[b1], twid_b_in[b0]};

assign twid_n_out =
    {twid_n_in[b3], twid_n_in[b2], twid_n_in[b1], twid_n_in[b0]};

assign twid_c_out =
    {twid_c_in[b3], twid_c_in[b2], twid_c_in[b1], twid_c_in[b0]};

// Result construction
assign twid_b_result = 
    {32{twid_b}} & twid_b_out;

assign twid_n_result = 
    {32{twid_n0}} & {palu_rs1[31:16], twid_n_out} |
    {32{twid_n1}} & {twid_n_out, palu_rs1[15: 0]} ;

assign twid_c_result = 
{32{twid_c0}} & {palu_rs1[31:24],palu_rs1[23:16],palu_rs1[15:8],twid_c_out} |
{32{twid_c1}} & {palu_rs1[31:24],palu_rs1[23:16],twid_c_out, palu_rs1[7:0]} |
{32{twid_c2}} & {palu_rs1[31:24],twid_c_out, palu_rs1[15:8], palu_rs1[7:0]} |
{32{twid_c3}} & {twid_c_out, palu_rs1[23:16],palu_rs1[15:8], palu_rs1[7:0]} ;

wire [31:0] result_twid = 
    twid_b_result | twid_n_result | twid_c_result;

// ----------------------------------------------------------------------

//
//  Packed Arithmetic Instructions
//


wire [31:0] result_parith;
    
wire [31:0] padd_a ;  // LHS input
wire [31:0] padd_b ;  // RHS input
wire        padd_sub; // Do subtract instead of add.
wire        padd_ci;  // Carry in
wire [31:0] padd_c ;  // Result
wire        padd_co;  // Carry out

wire        pmul_start ; // Trigger to start multiplying
wire        pmul_done  ; // Signal multiplication has finished.
wire [31:0] pmul_a     ; // LHS operand
wire [31:0] pmul_b     ; // RHS operand
wire [63:0] pmul_add_a ; // LHS operand for shared adder
wire [63:0] pmul_add_b ; // RHS operand for shared adder
wire [63:0] pmul_add_c ; // RHS operand for shared adder
wire [63:0] pmul_result; // Result of the multiplication.
wire [ 4:0] pmul_shf_sham;   // Shifter shift amount.
wire [31:0] pmul_shf_a   ;   // Shifter input operand.
wire [31:0] pmul_shf_c   ;   // Shifter output result.
    
wire [31:0] pshf_a    ; // LHS input
wire [ 5:0] pshf_shamt; // RHS input
wire        pshf_sl   ; // shift left / n shift right
wire        pshf_r    ; // rotate / n shift
wire [31:0] pshf_c    ; // Result

assign padd_a = is_mul_px ? pmul_add_a[31:0] : palu_rs1;
assign padd_b = is_mul_px ? pmul_add_b[31:0] : palu_rs2;

assign pmul_a       = palu_rs1;
assign pmul_b       = palu_rs2;
assign pmul_add_c   = padd_c;
assign pmul_start   = is_mul_px && is_parith_insn;
assign pmul_shf_c   = pshf_c;

wire   shift_imm    = is_slli_px || is_srli_px || is_roti_px;
assign pshf_a       = is_mul_px ? pmul_shf_a : palu_rs1;
assign pshf_shamt   = is_mul_px ? pmul_shf_sham      :
                      shift_imm ? {1'b0,id_imm[4:0]  } :
                                  {1'b0,palu_rs2[4:0]} ;
assign pshf_r       = is_rot_px || is_roti_px;
assign pshf_sl      = is_mul_px || is_sll_px || is_slli_px;

assign padd_ci      = is_sub_px;
assign padd_sub     = is_sub_px;

wire is_add_px  = is_parith_insn && id_subclass == SCARV_COP_SCLASS_ADD_PX;
wire is_sub_px  = is_parith_insn && id_subclass == SCARV_COP_SCLASS_SUB_PX;
wire is_mul_px  = is_parith_insn && id_subclass == SCARV_COP_SCLASS_MUL_PX;
wire is_sll_px  = is_parith_insn && id_subclass == SCARV_COP_SCLASS_SLL_PX;
wire is_srl_px  = is_parith_insn && id_subclass == SCARV_COP_SCLASS_SRL_PX;
wire is_rot_px  = is_parith_insn && id_subclass == SCARV_COP_SCLASS_ROT_PX;
wire is_slli_px = is_parith_insn && id_subclass == SCARV_COP_SCLASS_SLLI_PX;
wire is_srli_px = is_parith_insn && id_subclass == SCARV_COP_SCLASS_SRLI_PX;
wire is_roti_px = is_parith_insn && id_subclass == SCARV_COP_SCLASS_ROTI_PX;

wire is_shift   =  is_sll_px  || is_srl_px  || is_rot_px  || is_slli_px ||
                   is_srli_px || is_roti_px ;

assign result_parith =
    {32{is_mul_px}} & pmul_result   |
    {32{is_add_px}} & padd_c        |
    {32{is_sub_px}} & padd_c        |
    {32{is_shift }} & pshf_c        ;


scarv_cop_palu_adder i_palu_adder(
.a  (padd_a ),  // LHS input
.b  (padd_b ),  // RHS input
.pw (id_pw  ),  // Current operation pack width
.sub(padd_sub), // Do subtract instead of add.
.ci (padd_ci),  // Carry in
.c  (padd_c ),  // Result
.co (padd_co)   // Carry out
);

scarv_cop_palu_shifter i_palu_shifter (
.a    (pshf_a    ), // LHS input
.shamt(pshf_shamt), // RHS input
.pw   (id_pw     ), // Current operation pack width
.sl   (pshf_sl   ), // shift left / n shift right
.r    (pshf_r    ), // rotate / n shift
.c    (pshf_c    )  // Result
);

scarv_cop_palu_multiplier i_palu_multiplier (
.g_clk   (g_clk      ),   // Global clock.
.g_resetn(g_resetn   ),   // Global synchronous active low reset
.start   (pmul_start ),   // Trigger to start multiplying
.done    (pmul_done  ),   // Signal multiplication has finished.
.a       (pmul_a     ),   // LHS operand
.b       (pmul_b     ),   // RHS operand
.add_a   (pmul_add_a ),   // ADDER LHS operand
.add_b   (pmul_add_b ),   // ADDER RHS operand
.add_c   (pmul_add_c ),   // ADDER result
.shf_sham(pmul_shf_sham), // SHIFTER LHS operand
.shf_a   (pmul_shf_a   ), // SHIFTER RHS operand
.shf_c   (pmul_shf_c   ), // SHIFTER result
.pw      (id_pw      ),   // Pack width.
.result  (pmul_result)    // Result of the multiplication.
);

endmodule
