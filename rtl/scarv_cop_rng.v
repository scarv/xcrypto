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

input  wire [31:0]  rng_rs1          , // Source register 1

input  wire [31:0]  id_imm           , // Source immedate
input  wire [31:0]  id_class         , // Instruction class
input  wire [31:0]  id_subclass      , // Instruction subclass

output wire [ 3:0]  rng_cpr_rd_ben   , // Writeback byte enable
output wire [ 3:0]  rng_cpr_rd_wdata  // Writeback data
);

`include "scarv_cop_common.vh"

//
// Which RNG type to use?
//
parameter   RNG_TYPE        = SCARV_COP_RNG_TYPE_LFSR32;
parameter   RNG_RESET_VALUE = 0;

//
// Routing wires
wire [31:0] rng_output;

//
// Which RNG instruction is this?
wire is_rseed   = rng_ivalid                            && 
                  id_class == SCARV_COP_ICLASS_RANDOM   &&
                  id_subclass == SCARV_COP_SCLASS_RSEED ;

wire is_rsamp   = rng_ivalid                            && 
                  id_class == SCARV_COP_ICLASS_RANDOM   &&
                  id_subclass == SCARV_COP_SCLASS_RSAMP ;

//
// Writeback handling
assign rng_cpr_rd_ben   = is_rsamp ? 4'b1111    : 4'b0000;
assign rng_cpr_rd_wdata = is_rsamp ? rng_output : 32'b0  ;
assign rng_idone        = is_rseed || is_rsamp;

generate if(RNG_TYPE == SCARV_COP_RNG_TYPE_LFSR32) begin

    //
    // Generate a simple 32-bit LFSR for testing purposes.
    //
    //  !! This is absolutely *not* appropriate for cryptography !!
    //

    reg [31:0] rng_value;
    wire[31:0] n_rng_value;
    wire       n_lsb = rng_value[32] ~^ 
                       rng_value[22] ~^ 
                       rng_value[ 2] ~^
                       rng_value[ 1]  ;

    assign n_rng_value = is_rseed ? rng_rs1
                                  : {rng_value[31:1],n_lsb};

    always @(posedge g_clk) if(!g_resetn) begin
        rng_value <= RNG_RESET_VALUE;
    end else begin
        rng_value <= n_rng_value;
    end

end else begin

    assign rng_output = 0;

end endgenerate

endmodule
