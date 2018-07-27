
//
// University of Brisol SCARV Project
//


//
//  module: rop_ba_cop
//
//      Random Operand Padded, Byte Addressable Co-Processor
//
//      cop_* inputs must be stable until cop_rsp is asserted.
//
module rop_ba_cop (

input   wire        clk             , // Global clock
output  wire        clk_req         , // Block clock request

input   wire        resetn          , // Active low sychronous reset.

input   wire        cop_req         , // COP request valid
output  wire        cop_acc         , // COP request accept
output  wire        cop_rsp         , // COP response valid
input   wire [31:0] cop_instr_in    , // Input instruction word
input   wire [31:0] cop_rs1         , // Input source register 1
input   wire [31:0] cop_rs2         , // Input source register 2

output  wire [ 2:0] cop_rd_byte     , // Output destination byte / register.
output  wire [ 4:0] cop_rd          , // Output destination register.
output  wire [31:0] cop_wdata       , // Output result writeback data.
output  wire        cop_wen         , // Output result write enable.

output  wire        cop_mem_ld_error, // Memory error on load.
output  wire        cop_mem_st_error, // Memory error on store.

output  wire        cop_mem_cen     , // COP memory if chip enable.
input   wire        cop_mem_stall   , // COP memory if stall
input   wire        cop_mem_error   , // COP memory if error
output  wire        cop_mem_wen     , // COP memory if write enable.
output  wire [ 3:0] cop_mem_ben     , // COP memory write byte enable.
output  wire [31:0] cop_mem_wdata   , // COP memory if write data
input   wire [31:0] cop_mem_rdata   , // COP memory if read data
output  wire [31:0] cop_mem_addr      // COP memory if address

);

// Local parameter for opcode defining instruction membership of ISE.
localparam DEC_ISE_OPCODE   = 7'b0101011;

localparam DEC_F3_SB_B      = 3'b000;   // SB.B instruction F3 field.
localparam DEC_F3_R         = 3'b001;   // R-type instruction F3 field.
localparam DEC_F3_LB_B      = 3'b010;   // LB.B instruction F3 field.
localparam DEC_F3_LB_BK     = 3'b011;   // LB.BK instruction F3 field.

localparam DEC_F7_XOR_RB    = 7'b0000000; // XOR.RB encoding for f7 field
localparam DEC_F7_XOR_RBK   = 7'b0000001; // XOR.RBK    ""
localparam DEC_F7_AND_RB    = 7'b0000010; // AND.RB     ""
localparam DEC_F7_AND_RBK   = 7'b0000011; // AND.RBK    ""
localparam DEC_F7_OR_RB     = 7'b0000100; // OR.RB      ""
localparam DEC_F7_OR_RBK    = 7'b0000101; // OR.RBK     ""

localparam WB_WORD = 3'b100;
localparam WB_BYTE = 1'b0;

//
// ----------------------------------------------------------------------
//
//  Top level routing & operand wires
//

// Ask for a clock signal only when handling instructions
assign      clk_req     = cop_req;

// Output of the pseudo random number generator.
wire [63:0] prng_out;

// Generate a new random number each clock cycle
wire        prng_en     = 1'b1;

wire        arith_op;  // Is the current instruction an arithmetic op?
wire        rand_keep; // Keep random result from arithmetic operation?

wire [31:0] arith_lhs; // Left hand arithmetic operand
wire [31:0] arith_rhs; // Right hand arithmetic operand
wire [31:0] arith_out; // Arithmetic instruction output.

wire        mem_op_done; // Is the current memory operation finished?

//
// ----------------------------------------------------------------------
//
//  ISE Instruction Decode
//

// Opcode decode fields for all RISC-V instructions, include custom ones.
wire    dec_opcode = cop_instr_in[6:0];
wire    dec_f3     = cop_instr_in[14:12];
wire    dec_f7     = cop_instr_in[31:25];

// Offered instruction is in the ISE major opcode space?
wire    dec_in_ise = cop_req && dec_opcode == DEC_ISE_OPCODE;

// Have we decoded a load / store instruction?
wire    dec_instr_sb_b  = dec_in_ise && dec_f3 == DEC_F3_SB_B   ;
wire    dec_instr_lb_b  = dec_in_ise && dec_f3 == DEC_F3_LB_B   ; 
wire    dec_instr_lb_bk = dec_in_ise && dec_f3 == DEC_F3_LB_BK  ;

// Have we decode an arithmetic instruction?
wire    dec_instr_rtype   = dec_in_ise      && dec_f3 == DEC_F3_R      ;
wire    dec_instr_xor_rb  = dec_instr_rtype && dec_f7 == DEC_F7_XOR_RB ;
wire    dec_instr_xor_rbk = dec_instr_rtype && dec_f7 == DEC_F7_XOR_RBK;
wire    dec_instr_and_rb  = dec_instr_rtype && dec_f7 == DEC_F7_AND_RB ;
wire    dec_instr_and_rbk = dec_instr_rtype && dec_f7 == DEC_F7_AND_RBK;
wire    dec_instr_or_rb   = dec_instr_rtype && dec_f7 == DEC_F7_OR_RB  ;
wire    dec_instr_or_rbk  = dec_instr_rtype && dec_f7 == DEC_F7_OR_RBK ;

assign  rand_keep = dec_instr_lb_bk     || dec_instr_xor_rbk ||
                    dec_instr_and_rbk   || dec_instr_or_rbk   ;

//
// ----------------------------------------------------------------------
//
//  Co-processor interface handling
//

// Accept the instruction iff we decode something which belongs to this ISE.
assign cop_acc  = dec_instr_sb_b    ||
                  dec_instr_lb_b    ||
                  dec_instr_lb_bk   ||
                  dec_instr_xor_rb  ||
                  dec_instr_xor_rbk ||
                  dec_instr_and_rb  ||
                  dec_instr_and_rbk ||
                  dec_instr_or_rb   ||
                  dec_instr_or_rbk   ;

assign cop_rsp = arith_op || mem_op_done;

//
// ----------------------------------------------------------------------
//
//  Arithmetic Instruction Execution
//

// Source random bits for lhs/rhs of the operands
assign arith_lhs[31:8] = prng_out[31: 8];
assign arith_rhs[31:8] = prng_out[55:32];

// Source actual parts of data we want to compute.
assign arith_lhs[7:0]  = cop_rs1[7:0];
assign arith_rhs[7:0]  = cop_rs2[7:0];

wire   arith_op_xor = dec_instr_xor_rb || dec_instr_xor_rbk;
wire   arith_op_and = dec_instr_and_rb || dec_instr_and_rbk;
wire   arith_op_or  = dec_instr_or_rb  || dec_instr_or_rbk ;
assign arith_op     = arith_op_or || arith_op_xor || arith_op_and;

// Compute result of arithmetic operands
assign arith_out =
    ({32{arith_op_xor}}  & (arith_lhs ^ arith_rhs))   |
    ({32{arith_op_and}}  & (arith_lhs & arith_rhs))   |
    ({32{arith_op_or }}  & (arith_lhs | arith_rhs))   ;

//
// ----------------------------------------------------------------------
//
//  Memory Instruction Execution
//

// Are we currently executing a memory operation?
wire  mem_load  = dec_instr_lb_b || dec_instr_lb_bk;
wire  mem_op    = dec_instr_sb_b || mem_load;

wire [31:0] sb_offset = 
    {{20{cop_instr_in[31]}},cop_instr_in[31:25],cop_instr_in[11:7]};

wire [31:0] lb_offset = {{20{cop_instr_in[31]}},cop_instr_in[31:20]};

// Compute the target address for the memory.
wire [31:0] mem_offset =     dec_instr_sb_b ? sb_offset :
                                              lb_offset ;

wire [32:0] mem_addr   = (mem_offset + cop_rs1);

assign cop_mem_cen    = (mem_op || cop_mem_stall) && !cop_mem_error;
assign cop_mem_wen    = dec_instr_sb_b;
assign cop_mem_wdata  = cop_rs2;
assign cop_mem_addr   = mem_addr[31:0] & 32'hFFFF_FFFC;
assign cop_mem_ben[0] = mem_addr[1:0] == 2'b00;
assign cop_mem_ben[1] = mem_addr[1:0] == 2'b01;
assign cop_mem_ben[2] = mem_addr[1:0] == 2'b10;
assign cop_mem_ben[3] = mem_addr[1:0] == 2'b11;

assign cop_mem_ld_error = cop_mem_error && !cop_mem_wen;
assign cop_mem_st_error = cop_mem_error &&  cop_mem_wen;

assign mem_op_done = cop_mem_cen && (!cop_mem_stall || cop_mem_error);

//
// ----------------------------------------------------------------------
//
//  COP Writeback interface.
//

assign cop_wen  = arith_op || (mem_op && !dec_instr_sb_b);
assign cop_wdata= mem_op ? cop_mem_rdata :
                           arith_out     ;

wire [4:0] instr_rd     = cop_instr_in[11:7];

// When writing back to a byte addressable register, map the low three
// bits of the RD encoded in the instruction onto one of the "argument"
// registers as specified in the RISC-V ABI.
wire [4:0] areg_rd  = 
    ({5{instr_rd[2:0] == 3'd0}} & 5'd10) |
    ({5{instr_rd[2:0] == 3'd1}} & 5'd11) |
    ({5{instr_rd[2:0] == 3'd2}} & 5'd12) |
    ({5{instr_rd[2:0] == 3'd3}} & 5'd13) |
    ({5{instr_rd[2:0] == 3'd4}} & 5'd14) |
    ({5{instr_rd[2:0] == 3'd5}} & 5'd15) |
    ({5{instr_rd[2:0] == 3'd6}} & 5'd16) |
    ({5{instr_rd[2:0] == 3'd7}} & 5'd17) ;

assign cop_rd       = !rand_keep ? instr_rd              :
                                   areg_rd               ;

// If not keeping a extra random data, use the top two bits of the
// Instruction rd field as the destination byte index of whichever argument
// register we are writing too.
// Otherwise, set it to write back the whole word.
assign cop_rd_byte  = rand_keep  ?  WB_WORD                :
                                   {WB_BYTE,instr_rd[4:3]} ;

//
// ----------------------------------------------------------------------
//
//  Submodule instantiations
//


//
//  submodule: i_prng
//  
//      The random number source used by the co-processor.
//
rop_prng i_prng (
.clk        (clk        ),
.resetn     (resetn     ),
.rng_en     (prng_en    ),
.rng_random (prng_out   )
);

endmodule
