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

assign malu_rdm_in_rs = mp_fsm == 0 && is_acc2_mp || is_acc1_mp;

reg  [1:0] mp_fsm;
wire [1:0] n_mp_fsm = mp_fsm + 1;

always @(posedge g_clk) begin
    if(!g_resetn || malu_idone)
        mp_fsm <= 0;
    else if(malu_ivalid && !malu_idone) begin
        mp_fsm <= n_mp_fsm;
    end
end

assign malu_idone = 
    mp_fsm == 1 && (is_add2_mp || is_shift || is_acc1_mp)  
||  mp_fsm == 2 && (is_add3_mp || is_acc2_mp || is_acc1_mp) ;

// 64 bit result of all MALU instructions.

wire is_shift = is_sll_mp || is_slli_mp || is_srl_mp || is_srli_mp;

wire malu_result_inter =
    mp_fsm == 1 && (is_add2_mp || is_shift || is_acc1_mp  )     
||  mp_fsm == 2 && (is_add3_mp || is_acc2_mp)    ;

wire malu_result_adder = 
    mp_fsm == 0 && (is_add2_mp || is_add3_mp || is_acc1_mp)     
||  mp_fsm == 1 && (is_add2_mp || is_add3_mp || is_acc2_mp)    ;

wire malu_result_shift = 
    mp_fsm == 0 && (is_shift                )    ;

wire malu_result_mul   = 1'b0;

wire [63:0] malu_result = 
    {64{malu_result_inter}} & malu_intermediate |
    {64{malu_result_adder}} & adder1_result     |     
    {64{malu_result_shift}} & shift1_result     | 
    {64{malu_result_mul  }} & mul1_result       ;

// writeback the high word or low word of the result?
wire wb_hi = 
    mp_fsm == 0 && (1'b0                    )
||  mp_fsm == 1 && (is_add2_mp || is_shift || is_acc1_mp )  
||  mp_fsm == 2 && (is_add3_mp || is_acc2_mp) ;

// Write byte enable and write data selection,
assign malu_cpr_rd_ben   = {4{
    mp_fsm == 0 && (is_add2_mp || is_shift   || is_acc1_mp                  )
||  mp_fsm == 1 && (is_add2_mp || is_add3_mp || is_shift || is_acc1_mp ||
                    is_acc2_mp                                              )
||  mp_fsm == 2 && (is_add3_mp || is_acc2_mp                                )  
}};

assign malu_cpr_rd_wdata = 
    wb_hi ? malu_result[63:32] : malu_result[31: 0];


//
// Utility wires for controlling the number of operators we implement.
//

// 64-bit adder.
wire [63:0] adder1_lhs;
wire [63:0] adder1_rhs;
wire [64:0] adder1_result = adder1_lhs + adder1_rhs;

wire   adder1_lhs_rs1 =
    mp_fsm == 0 && (is_add2_mp || is_add3_mp    )
||  mp_fsm == 1 && (1'b0                        );

wire   adder1_lhs_crd =
    mp_fsm == 0 && (is_acc2_mp || is_acc1_mp    );

wire   adder1_lhs_inter = 
    mp_fsm == 0 && (1'b0                                    )
||  mp_fsm == 1 && (is_add3_mp || is_acc2_mp                )
||  mp_fsm == 2 && (is_add3_mp                              );

wire   adder1_rhs_rs1 =
    mp_fsm == 1 && (1'b0                     );

wire   adder1_rhs_rs2 =
    mp_fsm == 0 && (is_add2_mp || is_add3_mp )
||  mp_fsm == 1 && (is_acc2_mp               )
||  mp_fsm == 2 && (1'b0                     );

wire   adder1_rhs_rs3 =
    mp_fsm == 0 && (is_acc1_mp || is_acc2_mp    )
||  mp_fsm == 1 && (is_add3_mp                  );

assign adder1_lhs = 
    {64{adder1_lhs_rs1  }} & {32'b0   ,malu_rs1 } |
    {64{adder1_lhs_crd  }} & {malu_rs2,malu_rs1 } |
    {64{adder1_lhs_inter}} & {malu_intermediate } ;

assign adder1_rhs = 
    {64{adder1_rhs_rs1}} & {32'b0,malu_rs1      } |
    {64{adder1_rhs_rs2}} & {32'b0,malu_rs2      } |
    {64{adder1_rhs_rs3}} & {32'b0,malu_rs3      } ;

// Left/right barrel shifter

wire shift1_rhs_reg = is_srl_mp  || is_sll_mp ;
wire shift1_rhs_imm = is_srli_mp || is_slli_mp;
wire shift1_right   = is_srl_mp  || is_srli_mp;

wire [63:0] shift1_lhs = {malu_rs1,malu_rs2};
wire [ 5:0] shift1_rhs = 
    {6{shift1_rhs_reg}} & malu_rs3[5:0] |
    {6{shift1_rhs_imm}} & id_imm  [5:0] ;

wire [63:0] shift1_result = shift1_right ? shift1_lhs >> shift1_rhs :
                                           shift1_lhs << shift1_rhs ;

// Multiplier
wire [31:0] mul1_lhs;
wire [31:0] mul1_rhs;
wire [63:0] mul1_result = mul1_lhs * mul1_rhs;

//
// Intermediate value storage
reg  [63:0] malu_intermediate;
wire [63:0] n_malu_intermediate;

wire save_add = is_add2_mp || is_add3_mp ||
                (is_acc2_mp || is_acc1_mp) && mp_fsm == 0 ||
                (is_acc2_mp || is_acc1_mp) && mp_fsm == 1;

assign n_malu_intermediate = 
    {64{is_shift}} & shift1_result          |
    {64{save_add}} & adder1_result          ;

// load enable for malu_intermediate;
assign ld_intermediate =
    mp_fsm == 0 && (is_add2_mp  || is_add3_mp || is_shift || is_acc2_mp ||
                    is_acc1_mp                                              )
||  mp_fsm == 1 && (is_add3_mp || is_acc2_mp);

always @(posedge g_clk) begin
    if(!g_resetn) begin
        malu_intermediate <= 32'b0;
    end else if(ld_intermediate) begin
        malu_intermediate <= n_malu_intermediate;
    end
end

 endmodule
