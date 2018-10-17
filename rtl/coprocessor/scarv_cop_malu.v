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
// module: scarv_cop_malu
//
//  Multi-precision arithmetic and shift module.
//
module scarv_cop_malu (
input  wire         g_clk            , // Global clock
input  wire         g_resetn         , // Synchronous active low reset.

input  wire         malu_ivalid      , // Valid instruction input
output wire         malu_idone       , // Instruction complete

output wire         malu_rdm_in_rs   , // Source destination regs in rs1/2

input  wire [31:0]  gpr_rs1          , // RS1 from the CPU.
input  wire [31:0]  malu_rs1         , // Source register 1
input  wire [31:0]  malu_rs2         , // Source register 2
input  wire [31:0]  malu_rs3         , // Source register 3

input  wire [31:0]  id_imm           , // Source immedate
input  wire [ 2:0]  id_class         , // Instruction class
input  wire [ 3:0]  id_subclass      , // Instruction subclass

output wire [ 3:0]  malu_cpr_rd_ben  , // Writeback byte enable
output wire [31:0]  malu_cpr_rd_wdata  // Writeback data
);

`include "scarv_cop_common.vh"

//
// Individual instruction decoding.
//

wire is_equ_mp  = malu_ivalid && id_subclass == SCARV_COP_SCLASS_EQU_MP ;
wire is_ltu_mp  = malu_ivalid && id_subclass == SCARV_COP_SCLASS_LTU_MP ;
wire is_gtu_mp  = malu_ivalid && id_subclass == SCARV_COP_SCLASS_GTU_MP ;
wire is_add3_mp = malu_ivalid && id_subclass == SCARV_COP_SCLASS_ADD3_MP;
wire is_add2_mp = malu_ivalid && id_subclass == SCARV_COP_SCLASS_ADD2_MP;
wire is_sub3_mp = malu_ivalid && id_subclass == SCARV_COP_SCLASS_SUB3_MP;
wire is_sub2_mp = malu_ivalid && id_subclass == SCARV_COP_SCLASS_SUB2_MP;
wire is_slli_mp = malu_ivalid && id_subclass == SCARV_COP_SCLASS_SLLI_MP;
wire is_sll_mp  = malu_ivalid && id_subclass == SCARV_COP_SCLASS_SLL_MP ;
wire is_srli_mp = malu_ivalid && id_subclass == SCARV_COP_SCLASS_SRLI_MP;
wire is_srl_mp  = malu_ivalid && id_subclass == SCARV_COP_SCLASS_SRL_MP ;
wire is_acc2_mp = malu_ivalid && id_subclass == SCARV_COP_SCLASS_ACC2_MP;
wire is_acc1_mp = malu_ivalid && id_subclass == SCARV_COP_SCLASS_ACC1_MP;
wire is_mac_mp  = malu_ivalid && id_subclass == SCARV_COP_SCLASS_MAC_MP ;

//
// MP instruction control FSM
//
//  Implemented as a 2 bit counter.
//

assign malu_rdm_in_rs = mp_fsm == 0 && is_acc2_mp || is_acc1_mp;

reg  [1:0] mp_fsm;
wire [1:0] n_mp_fsm = mp_fsm + 1;

// Which step of the FSM are we in?
wire    fsm0 = mp_fsm == 0;
wire    fsm1 = mp_fsm == 1;
wire    fsm2 = mp_fsm == 2;
wire    fsm3 = mp_fsm == 3;

always @(posedge g_clk) begin
    if(!g_resetn || malu_idone)
        mp_fsm <= 0;
    else if(malu_ivalid && !malu_idone) begin
        mp_fsm <= n_mp_fsm;
    end
end

// Signal the instruction has finished.
assign malu_idone = 
    fsm0 && (is_equ_mp  || is_ltu_mp  || is_gtu_mp                      ) ||
    fsm1 && (is_add2_mp || is_sub2_mp || is_acc1_mp || is_slli_mp ||
             is_srli_mp || is_sll_mp  || is_srl_mp                      ) ||
    fsm2 && (is_add3_mp || is_sub3_mp || is_acc2_mp || is_mac_mp        ) ;

//
// Utility wires
//

wire        wb_en; // Writeback to CPR enable

// Should we do a subtract on the adder inputs?
wire        do_sub      = is_sub2_mp || is_sub3_mp;

// Results for each of the major arithmetic operations.
wire [63:0] result_add;
wire [63:0] result_mul;
wire [63:0] result_shf;

// Inputs for each of the major arithmetic operations
wire [63:0] add_lhs, add_rhs;
wire [31:0] mul_lhs, mul_rhs;
wire [63:0] shf_lhs         ;

// Writeback high word of tmp register.
wire wb_tmp_hi = 
    fsm1 && (is_add2_mp || is_sub2_mp || is_acc1_mp || is_slli_mp || 
             is_sll_mp  || is_srli_mp || is_srl_mp                      ) ||
    fsm2 && (is_add3_mp || is_sub3_mp || is_acc2_mp || is_mac_mp        ) ;

// Writeback low word of adder result.
wire wb_add_lo =
    fsm0 && (is_add2_mp || is_sub2_mp || is_acc1_mp                     ) ||
    fsm1 && (is_add3_mp || is_sub3_mp || is_acc2_mp || is_mac_mp        ) ;

// Writeback low word of shifter result.
wire wb_shf_lo =
    fsm0 && (is_slli_mp || is_sll_mp  || is_srli_mp || is_srl_mp        ) ;

// Writeback comparison result bit.
wire wb_cmp    =
    fsm0 && (is_equ_mp || is_gtu_mp || is_ltu_mp                        ) ;

//
// Temporary value register
//

reg  [63:0] tmp;
wire [63:0] n_tmp;

// Load adder result into tmp.
wire       tmp_ld_add = 
    fsm0 && (is_add2_mp || is_add3_mp || is_sub2_mp || is_sub3_mp ||
             is_acc1_mp || is_acc2_mp                                   ) ||
    fsm1 && (is_add3_mp || is_sub3_mp || is_acc2_mp                     ) ;

// Load multiplier result into tmp.
wire       tmp_ld_mul =
    fsm0 && (is_mac_mp                                                  ) ;

// Load Shifter result into tmp.
wire       tmp_ld_shf =
    fsm0 && (is_sll_mp  || is_slli_mp || is_srl_mp  || is_srli_mp       ) ;

assign n_tmp = 
    {64{tmp_ld_add}} & {result_add} |
    {64{tmp_ld_mul}} & {result_mul} |
    {64{tmp_ld_shf}} & {result_shf} ;

always @(posedge g_clk) begin
    if(!g_resetn) begin
        tmp <= 63'b0;
    end else if(tmp_ld_add || tmp_ld_mul || tmp_ld_shf) begin
        tmp <= n_tmp;
    end
end

//
// 32-bit comparator.
//

wire is_cmp = is_equ_mp || is_ltu_mp || is_gtu_mp;

wire [31:0] cmp_lhs = {32{is_cmp}} & malu_rs2;
wire [31:0] cmp_rhs = {32{is_cmp}} & malu_rs3;

wire cmp_eq = cmp_lhs == cmp_rhs;
wire cmp_lt = cmp_lhs <  cmp_rhs;

wire result_cmp =
    (is_equ_mp && ((cmp_eq && |gpr_rs1)                       )) ||
    (is_ltu_mp && ((cmp_eq && |gpr_rs1) ||  (cmp_lt          ))) ||
    (is_gtu_mp && ((cmp_eq && |gpr_rs1) || !(cmp_lt || cmp_eq))) ;

//
// 64 bit adder
//

wire add_lhs_rs1 =
    fsm0 && (is_add2_mp || is_add3_mp || is_sub2_mp || is_sub3_mp ||
             is_acc1_mp || is_acc2_mp                                   ) ;

wire add_lhs_tmp = 
    fsm1 && (is_add3_mp || is_sub3_mp || is_acc2_mp || is_mac_mp        ) ;

wire add_rhs_rs2 = 
    fsm0 && (is_add2_mp || is_add3_mp || is_sub2_mp || is_sub3_mp       ) ||
    fsm1 && (is_acc2_mp                                                 ) ;

wire add_rhs_rs3 =
    fsm1 && (is_mac_mp  || is_add3_mp || is_sub3_mp                     ) ;

wire add_rhs_r23 =
    fsm0 && (is_acc1_mp || is_acc2_mp                                   ) ;

assign add_lhs =
    {64{add_lhs_rs1}}   & {32'b0   , malu_rs1}   |
    {64{add_lhs_tmp}}   & {          tmp     }   ;

assign add_rhs =
    {64{add_rhs_rs2}}   & {32'b0   , malu_rs2}   |
    {64{add_rhs_rs3}}   & {32'b0   , malu_rs3}   |
    {64{add_rhs_r23}}   & {malu_rs2, malu_rs3}   ;

assign result_add   = do_sub ? add_lhs - add_rhs :
                               add_lhs + add_rhs ;

//
// 32x32 multiplier
//

assign mul_lhs = {64{fsm0 && is_mac_mp}} & {32'b0, malu_rs1};
assign mul_rhs = {64{fsm0 && is_mac_mp}} & {32'b0, malu_rs2};

assign result_mul   = mul_lhs * mul_rhs ;

//
// 64 bit shifter
//

wire        shiftright  = is_srl_mp  || is_srli_mp                  ;

wire [5:0]  shamt       = is_srli_mp || is_slli_mp ? id_imm[5:0]    : 
                                                     malu_rs3[5:0]  ;

wire   shf_gated        = is_srli_mp || is_slli_mp ||
                          is_srl_mp  || is_sll_mp;

assign shf_lhs          = {64{shf_gated}} & {malu_rs1, malu_rs2}    ;

assign result_shf       = shiftright ? shf_lhs >> shamt             :
                                       shf_lhs << shamt             ;

//
// MP instruction writeback data
//

assign wb_en = wb_tmp_hi || wb_add_lo || wb_shf_lo;

assign malu_cpr_rd_ben  = {4{wb_en}};

assign malu_cpr_rd_wdata=
    {32{wb_tmp_hi}} & tmp[63:32]         |
    {32{wb_add_lo}} & result_add[31:0]   |
    {32{wb_shf_lo}} & result_shf[31:0]   |
    {32{wb_cmp   }} & {31'b0, result_cmp};


endmodule
