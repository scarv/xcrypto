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

input  wire [31:0]  malu_rs1         , // Source register 1
input  wire [31:0]  malu_rs2         , // Source register 2
input  wire [31:0]  malu_rs3         , // Source register 3

input  wire [31:0]  id_imm           , // Source immedate
input  wire [ 2:0]  id_class         , // Instruction class
input  wire [ 3:0]  id_subclass      , // Instruction subclass

output wire [ 3:0]  malu_cpr_rd_ben  , // Writeback byte enable
output wire [31:0]  malu_cpr_rd_wdata  // Writeback data
);

//
// All MP instructions take two cycles
reg  cycle2     ;
wire n_cycle2   = malu_ivalid && !malu_idone;

always @(posedge g_clk) begin
    if(!g_resetn)
        cycle2 <= 1'b0;
    else begin
        cycle2 <= n_cycle2;
    end
end

assign malu_idone = cycle2;

// 64 bit result of all MALU instructions.
wire [63:0] malu_result = adder2_result;

assign malu_cpr_rd_ben   = malu_idone || malu_ivalid && !cycle2;
assign malu_cpr_rd_wdata = cycle2 ? malu_result[31:0] : malu_result[63:32];

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
// Utility wires for controlling the number of operators we implement.
//

assign adder1_lhs = {32'b0,malu_rs1};
assign adder1_rhs = {32'b0,malu_rs2};

wire [63:0] adder1_lhs;
wire [63:0] adder1_rhs;
wire [64:0] adder2_result = adder1_lhs + adder1_rhs;

endmodule
