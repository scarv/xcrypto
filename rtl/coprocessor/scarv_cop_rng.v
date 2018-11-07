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
// module: scarv_cop_rng
//
//  Random number generator block.
//
module scarv_cop_rng (
input  wire         g_clk            , // Global clock
input  wire         g_resetn         , // Synchronous active low reset.

input  wire         rng_ivalid       , // Valid instruction input
output wire         rng_idone        , // Instruction complete

`ifndef SYNTHESIS
// Hint signals used by verification environments.
output wire [31:0]  cop_random       , // The most recent random sample
output wire         cop_rand_sample  , // cop_random valid when this high.
`endif

input  wire [31:0]  rng_rs1          , // Source register 1

input  wire [31:0]  id_imm           , // Source immedate
input  wire [ 3:0]  id_class         , // Instruction class
input  wire [ 4:0]  id_subclass      , // Instruction subclass

output wire [ 3:0]  rng_cpr_rd_ben   , // Writeback byte enable
output wire [31:0]  rng_cpr_rd_wdata  // Writeback data
);

`include "scarv_cop_common.vh"

//
// Which RNG type to use?
//
parameter   RNG_TYPE        = SCARV_COP_RNG_TYPE_LFSR32;
parameter   RNG_RESET_VALUE = 32'b0;

//
// Routing wires
wire [31:0] rng_output;

`ifndef SYNTHESIS

// Sample the random value for any verification models which need it.
assign cop_random       = rng_output;
assign cop_rand_sample  = is_rsamp;

`endif

//
// Which RNG instruction is this?
wire is_rseed   = rng_ivalid                            && 
                  id_class == SCARV_COP_ICLASS_RANDOM   &&
                  id_subclass == SCARV_COP_SCLASS_RSEED ;

wire is_rsamp   = rng_ivalid                            && 
                  id_class == SCARV_COP_ICLASS_RANDOM   &&
                  id_subclass == SCARV_COP_SCLASS_RSAMP ;

wire is_rtest   = rng_ivalid                            && 
                  id_class == SCARV_COP_ICLASS_RANDOM   &&
                  id_subclass == SCARV_COP_SCLASS_RTEST ;

//
// Writeback handling
assign rng_cpr_rd_ben   = is_rsamp ? 4'b1111    : 4'b0000;
assign rng_cpr_rd_wdata = is_rsamp ? rng_output :
                          is_rtest ? 32'b1      :
                                     32'b0      ;
assign rng_idone        = is_rseed || is_rsamp || is_rtest;

generate if(RNG_TYPE == SCARV_COP_RNG_TYPE_LFSR32) begin : gen_lfsr32

    //
    // Generate a simple 32-bit LFSR for testing purposes.
    //
    //  !! This is absolutely *not* appropriate fioryptography !!
    //

    reg [31:0] rng_value;
    wire[31:0] n_rng_value;
    wire       n_lsb = rng_value[31] ~^ 
                       rng_value[21] ~^ 
                       rng_value[ 1] ~^
                       rng_value[ 0]  ;

    assign n_rng_value = is_rseed ? rng_rs1
                                  : rng_value << 1 | n_lsb;

    always @(posedge g_clk) if(!g_resetn) begin
        rng_value <= RNG_RESET_VALUE;
    end else begin
        rng_value <= n_rng_value;
    end

    assign rng_output = rng_value;

end else begin

    assign rng_output = 0;

end endgenerate

endmodule
