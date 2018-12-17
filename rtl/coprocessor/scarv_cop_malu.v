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
input  wire [ 3:0]  id_class         , // Instruction class
input  wire [ 4:0]  id_subclass      , // Instruction subclass

output wire [ 3:0]  malu_cpr_rd_ben  , // Writeback byte enable
output wire [31:0]  malu_cpr_rd_wdata  // Writeback data
);

`include "scarv_cop_common.vh"

//
// Individual instruction decoding.
//

wire is_mequ     = malu_ivalid && id_subclass == SCARV_COP_SCLASS_MEQU ;
wire is_mlte     = malu_ivalid && id_subclass == SCARV_COP_SCLASS_MLTE ;
wire is_mgte     = malu_ivalid && id_subclass == SCARV_COP_SCLASS_MGTE ;
wire is_madd_3   = malu_ivalid && id_subclass == SCARV_COP_SCLASS_MADD_3;
wire is_madd_2   = malu_ivalid && id_subclass == SCARV_COP_SCLASS_MADD_2;
wire is_msub_3   = malu_ivalid && id_subclass == SCARV_COP_SCLASS_MSUB_3;
wire is_msub_2   = malu_ivalid && id_subclass == SCARV_COP_SCLASS_MSUB_2;
wire is_msll_i   = malu_ivalid && id_subclass == SCARV_COP_SCLASS_MSLL_I;
wire is_msll     = malu_ivalid && id_subclass == SCARV_COP_SCLASS_MSLL ;
wire is_msrl_i   = malu_ivalid && id_subclass == SCARV_COP_SCLASS_MSRL_I;
wire is_msrl     = malu_ivalid && id_subclass == SCARV_COP_SCLASS_MSRL ;
wire is_macc_2   = malu_ivalid && id_subclass == SCARV_COP_SCLASS_MACC_2;
wire is_macc_1   = malu_ivalid && id_subclass == SCARV_COP_SCLASS_MACC_1;
wire is_mmul_3   = malu_ivalid && id_subclass == SCARV_COP_SCLASS_MMUL_3 ;
wire is_mclmul_3 = malu_ivalid && id_subclass == SCARV_COP_SCLASS_MCLMUL_3 ;

//
// MP instruction control FSM
//
//  Implemented as a 2 bit counter.
//

assign malu_rdm_in_rs = mp_fsm == 0 && is_macc_2 || is_macc_1;

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
    fsm0 && (is_mequ  || is_mlte  || is_mgte                       ) ||
    fsm1 && (is_madd_2 || is_msub_2 || is_macc_1 || is_msll_i ||
             is_msrl_i || is_msll  || is_msrl || is_mclmul_3       ) ||
    fsm2 && (is_madd_3 || is_msub_3 || is_macc_2 || is_mmul_3      ) ;

//
// Utility wires
//

wire        wb_en; // Writeback to CPR enable

// Should we do a subtract on the adder inputs?
wire        do_sub      = is_msub_2 || is_msub_3;

// Results for each of the major arithmetic operations.
wire [63:0] result_add;
wire [63:0] result_mul;
wire [63:0] result_clmul;
wire [63:0] result_shf;

// Inputs for each of the major arithmetic operations
wire [63:0] add_lhs, add_rhs;
wire [31:0] mul_lhs, mul_rhs;
wire [31:0] clmul_lhs, clmul_rhs;
wire [63:0] shf_lhs         ;

// Writeback low word of carryless multiply
wire wb_clmul_lo = fsm0 && is_mclmul_3;

// Writeback high word of tmp register.
wire wb_tmp_hi = 
    fsm1 && (is_madd_2 || is_msub_2 || is_macc_1 || is_msll_i || 
             is_msll  || is_msrl_i || is_msrl    || is_mclmul_3     ) ||
    fsm2 && (is_madd_3 || is_msub_3 || is_macc_2 || is_mmul_3   
                                                                    ) ;

// Writeback low word of adder result.
wire wb_add_lo =
    fsm0 && (is_madd_2 || is_msub_2 || is_macc_1                    ) ||
    fsm1 && (is_madd_3 || is_msub_3 || is_macc_2 || is_mmul_3       ) ;

// Writeback low word of shifter result.
wire wb_shf_lo =
    fsm0 && (is_msll_i || is_msll  || is_msrl_i || is_msrl        ) ;

// Writeback comparison result bit.
wire wb_cmp    =
    fsm0 && (is_mequ || is_mgte || is_mlte                        ) ;

//
// Temporary value register
//

reg  [63:0] tmp;
wire [63:0] n_tmp;

// Load adder result into tmp.
wire       tmp_ld_add = 
    fsm0 && (is_madd_2 || is_madd_3 || is_msub_2 || is_msub_3 ||
             is_macc_1 || is_macc_2                                 ) ||
    fsm1 && (is_madd_3 || is_msub_3 || is_macc_2 || is_mmul_3       ) ;

// Load multiplier result into tmp.
wire       tmp_ld_mul =
    fsm0 && (is_mmul_3                                                  ) ;

// Load carryless multiplier result into tmp.
wire       tmp_ld_clmul =
    fsm0 && (is_mclmul_3                                                ) ;

// Load Shifter result into tmp.
wire       tmp_ld_shf =
    fsm0 && (is_msll  || is_msll_i || is_msrl  || is_msrl_i       ) ;

wire tmp_ld = tmp_ld_add || tmp_ld_mul || tmp_ld_shf || tmp_ld_clmul;

assign n_tmp = 
    {64{tmp_ld_add  }} & {result_add  } |
    {64{tmp_ld_mul  }} & {result_mul  } |
    {64{tmp_ld_clmul}} & {result_clmul} |
    {64{tmp_ld_shf  }} & {result_shf  } ;

always @(posedge g_clk) begin
    if(!g_resetn) begin
        tmp <= 63'b0;
    end else if(tmp_ld) begin
        tmp <= n_tmp;
    end
end

//
// 32-bit comparator.
//

wire is_cmp = is_mequ || is_mlte || is_mgte;

wire [31:0] cmp_lhs = {32{is_cmp}} & malu_rs2;
wire [31:0] cmp_rhs = {32{is_cmp}} & malu_rs3;

wire cmp_eq = cmp_lhs == cmp_rhs;
wire cmp_lt = cmp_lhs <  cmp_rhs;

wire result_cmp =
    (is_mequ && ((cmp_eq && |gpr_rs1)                       )) ||
    (is_mlte && ((cmp_eq && |gpr_rs1) ||  (cmp_lt          ))) ||
    (is_mgte && ((cmp_eq && |gpr_rs1) || !(cmp_lt || cmp_eq))) ;

//
// 64 bit adder
//

wire add_lhs_rs1 =
    fsm0 && (is_madd_2 || is_madd_3 || is_msub_2 || is_msub_3 ||
             is_macc_1 || is_macc_2                                 ) ;

wire add_lhs_tmp = 
    fsm1 && (is_madd_3 || is_msub_3 || is_macc_2 || is_mmul_3       ) ;

wire add_rhs_rs2 = 
    fsm0 && (is_madd_2 || is_madd_3 || is_msub_2 || is_msub_3       ) ||
    fsm1 && (is_macc_2                                                 ) ;

wire add_rhs_rs3 =
    fsm1 && (is_mmul_3  || is_madd_3                                  ) ;

wire add_rhs_rs3_0 =
    fsm1 && (is_msub_3                                                ) ;

wire add_rhs_r23 =
    fsm0 && (is_macc_1 || is_macc_2                                   ) ;

assign add_lhs =
    {64{add_lhs_rs1}}   & {32'b0   , malu_rs1}   |
    {64{add_lhs_tmp}}   & {          tmp     }   ;

assign add_rhs =
    {64{add_rhs_rs2  }}   & {32'b0   , malu_rs2   }   |
    {64{add_rhs_rs3  }}   & {32'b0   , malu_rs3   }   |
    {64{add_rhs_rs3_0}}   & {63'b0   , malu_rs3[0]}   |
    {64{add_rhs_r23  }}   & {malu_rs2, malu_rs3   }   ;

assign result_add   = do_sub ? add_lhs - add_rhs :
                               add_lhs + add_rhs ;

//
// 32x32 multiplier
//

assign mul_lhs = {64{fsm0 && is_mmul_3}} & {32'b0, malu_rs1};
assign mul_rhs = {64{fsm0 && is_mmul_3}} & {32'b0, malu_rs2};

assign result_mul   = mul_lhs * mul_rhs ;

//
// 32x32 carryless multiplier
//

assign clmul_lhs = {64{fsm0 && is_mclmul_3}} & {32'b0, malu_rs1};
assign clmul_rhs = {64{fsm0 && is_mclmul_3}} & {32'b0, malu_rs2};

wire [63:0] clmul_reduce[63:0];

genvar cl;

generate for(cl = 0; cl < 32; cl = cl + 1) begin
   
    assign clmul_reduce[32+cl] = (clmul_lhs << cl) & {64{clmul_rhs[cl]}};

    if(cl > 0) begin
        assign clmul_reduce[cl] = clmul_reduce[2*cl] ^ clmul_reduce[2*cl + 1];
    end else begin
        assign clmul_reduce[cl] = clmul_reduce[1];
    end

end endgenerate

assign result_clmul = clmul_reduce[0] ^ malu_rs3;

//
// 64 bit shifter
//

wire        shiftright  = is_msrl  || is_msrl_i                  ;

wire [5:0]  shamt       = 
    is_msrl_i || is_msll_i ? id_imm  [5:0] : 
                             malu_rs3[5:0] ;

// Shift results return zero if shift amount greater than 63.
wire        shift_ret_z = (is_msrl || is_msll) && |malu_rs3[31:6];

wire   shf_gated        = is_msrl_i || is_msll_i ||
                          is_msrl  || is_msll;

assign shf_lhs          = {64{shf_gated}} & {malu_rs2, malu_rs1}    ;

assign result_shf       = shift_ret_z ? 64'b0                        :
                          shiftright  ? shf_lhs >> shamt             :
                                        shf_lhs << shamt             ;

//
// MP instruction writeback data
//

assign wb_en = wb_tmp_hi || wb_add_lo || wb_shf_lo || wb_clmul_lo;

assign malu_cpr_rd_ben  = {4{wb_en}};

assign malu_cpr_rd_wdata=
    {32{wb_clmul_lo}} & result_clmul[31:0] |
    {32{wb_tmp_hi}}   & tmp[63:32]         |
    {32{wb_add_lo}}   & result_add[31:0]   |
    {32{wb_shf_lo}}   & result_shf[31:0]   |
    {32{wb_cmp   }}   & {31'b0, result_cmp};


endmodule
