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
// module: scarv_cop_top
//
//  The top level module of the Crypto ISE co-processor.
//
module scarv_cop_top (

//
// Clock and reset interface

input  wire             g_clk           , // Global clock
output wire             g_clk_req       , // Clock request
input  wire             g_resetn        , // Synchronous active low reset.

//
// Status Interface

// TBD


//
// CPU / COP Interface
input  wire             cpu_insn_req    , // Instruction request
output reg              cop_insn_ack    , // Instruction request acknowledge
input  wire             cpu_abort_req   , // Abort Instruction
input  wire [31:0]      cpu_insn_enc    , // Encoded instruction data
input  wire [31:0]      cpu_rs1         , // RS1 source data

output wire             cop_wen         , // COP write enable
output wire [ 4:0]      cop_waddr       , // COP destination register address
output wire [31:0]      cop_wdata       , // COP write data
output wire [ 2:0]      cop_result      , // COP execution result
output reg              cop_insn_rsp    , // COP instruction finished
input  wire             cpu_insn_ack    , // Instruction finish acknowledge

//
// Memory Interface
output wire             cop_mem_cen     , // Chip enable
output wire             cop_mem_wen     , // write enable
output wire [31:0]      cop_mem_addr    , // Read/write address (word aligned)
output wire [31:0]      cop_mem_wdata   , // Memory write data
input  wire [31:0]      cop_mem_rdata   , // Memory read data
output wire [ 3:0]      cop_mem_ben     , // Write Byte enable
input  wire             cop_mem_stall   , // Stall
input  wire             cop_mem_error     // Error

);

// Common constants & definitions
`include "scarv_cop_common.vh"

//
// Glue logic wires
//

wire          id_exception    ; // Illegal instruction exception.

wire [ 2:0]   id_class        ; // Instruction class.
wire [ 3:0]   id_subclass     ; // Instruction subclass.

wire [ 2:0]   id_pw           ; // Instruction pack width.
wire [ 3:0]   id_crs1         ; // Instruction source register 1
wire [ 3:0]   id_crs2         ; // Instruction source register 2
wire [ 3:0]   id_crs3         ; // Instruction source register 3
wire [ 3:0]   id_crd          ; // Instruction destination register  
wire [ 3:0]   id_crd1         ; // MP Instruction destination register 1
wire [ 3:0]   id_crd2         ; // MP Instruction destination register 2
wire [ 4:0]   id_rd           ; // GPR destination register
wire [ 4:0]   id_rs1          ; // GPR source register
wire [31:0]   id_imm          ; // Decoded immediate.
wire [31:0]   id_wb_h         ; // Halfword index (load/store)
wire [31:0]   id_wb_b         ; // Byte index (load/store)

wire          crs1_ren   = 1'b1   ; // CPR Port 1 read enable
wire [ 3:0]   crs1_addr  = id_crs1; // CPR Port 1 address

wire          crs2_ren   = 1'b1   ; // CPR Port 2 read enable
wire [ 3:0]   crs2_addr  = id_crs2; // CPR Port 2 address

wire          crs3_ren   = 1'b1   ; // CPR Port 3 read enable
wire [ 3:0]   crs3_addr  = id_crs3; // CPR Port 3 address

wire [31:0]   crs1_rdata      ; // CPR Port 1 read data
wire [31:0]   crs2_rdata      ; // CPR Port 2 read data
wire [31:0]   crs3_rdata      ; // CPR Port 3 read data

wire [ 3:0]   crd_wen         ; // CPR Port 4 write enable
wire [ 3:0]   crd_addr        ; // CPR Port 4 address
wire [31:0]   crd_wdata       ; // CPR Port 4 write data

wire          palu_ivalid      ; // Valid instruction input
wire          palu_idone       ; // Instruction complete
wire [ 3:0]   palu_cpr_rd_ben  ; // Writeback byte enable
wire [31:0]   palu_cpr_rd_wdata; // Writeback data

wire          mem_ivalid       ; // Valid instruction input
wire          mem_idone        ; // Instruction complete
wire          mem_addr_error   ; // Memory address exception
wire          mem_bus_error    ; // Memory bus exception
wire [ 3:0]   mem_cpr_rd_ben   ; // Writeback byte enable
wire [31:0]   mem_cpr_rd_wdata ; // Writeback data

wire          malu_ivalid      ; // Valid instruction input
wire          malu_idone       ; // Instruction complete
wire [ 3:0]   malu_cpr_rd_ben  ; // Writeback byte enable
wire [31:0]   malu_cpr_rd_wdata; // Writeback data

//
// Functional unit dispatch
//
//  Send instructions to FU based on the decoded id_class.
//

assign palu_ivalid = id_class == SCARV_COP_ICLASS_PACKED_ARITH ||
                     id_class == SCARV_COP_ICLASS_MOVE         ||
                     id_class == SCARV_COP_ICLASS_BITWISE      ||
                     id_class == SCARV_COP_ICLASS_TWIDDLE       ;

assign malu_ivalid = id_class == SCARV_COP_ICLASS_MP            ;

assign mem_ivalid  = id_class == SCARV_COP_ICLASS_LOADSTORE     ;

//
// CPR Writeback data selection
//
//  CPR writeback muxing from the functional units.
//

assign crd_wen   = palu_cpr_rd_ben |
                   mem_cpr_rd_ben  |
                   malu_cpr_rd_ben ;

assign crd_addr  = id_crd;

assign crd_wdata = palu_cpr_rd_wdata |
                   mem_cpr_rd_wdata  |
                   malu_cpr_rd_wdata ;

//
// GPR Writeback data and instruction result selection
//
//  Control writeback data for the GPRs, and the result of each
//  instruction.
//

assign cop_waddr = id_rd;

assign cop_wen   = id_class     == SCARV_COP_ICLASS_MOVE    &&
                   id_subclass  == SCARV_COP_SCLASS_MV2GPR  ;

assign cop_wdata = palu_cpr_rd_wdata;

// FIXME - bug here, address / bus errors should differentiate between
//         whether a load or store caused them.
assign cop_result= id_exception     ? SCARV_COP_INSN_BAD_INS    :
                   mem_addr_error   ? SCARV_COP_INSN_BAD_LAD    :
                   mem_bus_error    ? SCARV_COP_INSN_LD_ERR     :
                                      SCARV_COP_INSN_SUCCESS    ;

//
// BEGIN DUMMY CODE

reg cop_insn_ack_r;
reg n_cop_insn_ack;
reg n_cop_insn_rsp;

assign cop_insn_ack = cop_insn_ack_r && !(cop_insn_rsp && !cpu_insn_ack);

always @(*) begin : p_ack
    n_cop_insn_ack = 1'b1;

    if(cop_insn_rsp && !cpu_insn_ack) begin
        n_cop_insn_ack = 1'b0;
    end
end

always @(*) begin : p_rsp
    n_cop_insn_rsp = 1'b0;

    if(cop_insn_ack && cpu_insn_req) begin
        n_cop_insn_rsp = 1'b1;
    end else if(cop_insn_rsp && !cpu_insn_ack) begin
        n_cop_insn_rsp = 1'b1;
    end
end

always @(posedge g_clk) cop_insn_ack_r <=  !g_resetn ? 1'b1 : n_cop_insn_ack;
always @(posedge g_clk) cop_insn_rsp   <=  !g_resetn ? 1'b0 : n_cop_insn_rsp;


// END DUMMY CODE
//

// ----------------------------------------------------------------------

//
// Submodule Instantiations
//

//
// instance: scarv_cop_idecode
//
//  The instruction decoder for the ISE.
//
scarv_cop_idecode i_scarv_cop_idecode (
.id_encoded  (cpu_insn_enc), // Encoding 32-bit instruction
.id_exception(id_exception), // Illegal instruction exception.
.id_class    (id_class    ), // Instruction class.
.id_subclass (id_subclass ), // Instruction subclass.
.id_pw       (id_pw       ), // Instruction pack width.
.id_crs1     (id_crs1     ), // Instruction source register 1
.id_crs2     (id_crs2     ), // Instruction source register 2
.id_crs3     (id_crs3     ), // Instruction source register 3
.id_crd      (id_crd      ), // Instruction destination register
.id_crd1     (id_crd1     ), // MP Instruction destination register 1
.id_crd2     (id_crd2     ), // MP Instruction destination register 2
.id_rd       (id_rd       ), // GPR destination register
.id_rs1      (id_rs1      ), // GPR source register
.id_imm      (id_imm      ), // Decoded immediate.
.id_wb_h     (id_wb_h     ),
.id_wb_b     (id_wb_b     )
);


//
// instance: scarv_cop_cprs
//
//  The general purpose register file used by the COP.
//
scarv_cop_cprs i_scarv_cop_cprs(
.g_clk     (g_clk     ), // Global clock
.g_clk_req (g_clk_req ), // Clock request
.g_resetn  (g_resetn  ), // Synchronous active low reset.
.crs1_ren  (crs1_ren  ), // Port 1 read enable
.crs1_addr (crs1_addr ), // Port 1 address
.crs1_rdata(crs1_rdata), // Port 1 read data
.crs2_ren  (crs2_ren  ), // Port 2 read enable
.crs2_addr (crs2_addr ), // Port 2 address
.crs2_rdata(crs2_rdata), // Port 2 read data
.crs3_ren  (crs3_ren  ), // Port 3 read enable
.crs3_addr (crs3_addr ), // Port 3 address
.crs3_rdata(crs3_rdata), // Port 3 read data
.crd_wen   (crd_wen   ), // Port 4 write enable
.crd_addr  (crd_addr  ), // Port 4 address
.crd_wdata (crd_wdata )  // Port 4 write data
);


//
// instance: scarv_cop_palu
//
//  Combinatorial Packed arithmetic and shift module.
//
// notes:
//  - LMIX/HMIX expect crd value to be in palu_rs3
//  - INS expects crd value to be in palu_rs3
//
scarv_cop_palu i_scarv_cop_palu (
.palu_ivalid      (palu_ivalid      ), // Valid instruction input
.palu_idone       (palu_idone       ), // Instruction complete
.gpr_rs1          (cpu_rs1          ), // GPR rs1
.palu_rs1         (crs1_rdata       ), // Source register 1
.palu_rs2         (crs2_rdata       ), // Source register 2
.palu_rs3         (crs3_rdata       ), // Source register 3
.id_imm           (id_imm           ), // Source immedate
.id_pw            (id_pw            ), // Pack width
.id_class         (id_class         ), // Instruction class
.id_subclass      (id_subclass      ), // Instruction subclass
.palu_cpr_rd_ben  (palu_cpr_rd_ben  ), // Writeback byte enable
.palu_cpr_rd_wdata(palu_cpr_rd_wdata)  // Writeback data
);


//
// instance: scarv_cop_mem
//
//  Load/store memory access module.
//
scarv_cop_mem i_scarv_cop_mem (
.g_clk           (g_clk           ), // Global clock
.g_resetn        (g_resetn        ), // Synchronous active low reset.
.mem_ivalid      (mem_ivalid      ), // Valid instruction input
.mem_idone       (mem_idone       ), // Instruction complete
.mem_addr_error  (mem_addr_error  ), // Memory address exception
.mem_bus_error   (mem_bus_error   ), // Memory bus exception
.gpr_rs1         (cpu_rs1         ), // Source register 1
.cpr_rs1         (crs1_rdata      ), // Source register 2
.cpr_rs2         (crs2_rdata      ), // Source register 3
.id_wb_h         (id_wb_h         ), // Halfword index (load/store)
.id_wb_b         (id_wb_b         ), // Byte index (load/store)
.id_imm          (id_imm          ), // Source immedate
.id_class        (id_class        ), // Instruction class
.id_subclass     (id_subclass     ), // Instruction subclass
.mem_cpr_rd_ben  (mem_cpr_rd_ben  ), // Writeback byte enable
.mem_cpr_rd_wdata(mem_cpr_rd_wdata), // Writeback data
.cop_mem_cen     (cop_mem_cen     ), // Chip enable
.cop_mem_wen     (cop_mem_wen     ), // write enable
.cop_mem_addr    (cop_mem_addr    ), // Read/write address (word aligned)
.cop_mem_wdata   (cop_mem_wdata   ), // Memory write data
.cop_mem_rdata   (cop_mem_rdata   ), // Memory read data
.cop_mem_ben     (cop_mem_ben     ), // Write Byte enable
.cop_mem_stall   (cop_mem_stall   ), // Stall
.cop_mem_error   (cop_mem_error   )  // Error
);


//
// instance: scarv_cop_malu
//
//  Multi-precision arithmetic and shift module.
//
scarv_cop_malu i_scarv_cop_malu (
.g_clk            (g_clk           ), // Global clock
.g_resetn         (g_resetn        ), // Synchronous active low reset.
.malu_ivalid      (malu_ivalid      ), // Valid instruction input
.malu_idone       (malu_idone       ), // Instruction complete
.malu_rs1         (crs1_rdata       ), // Source register 1
.malu_rs2         (crs2_rdata       ), // Source register 2
.malu_rs3         (crs3_rdata       ), // Source register 3
.id_imm           (id_imm           ), // Source immedate
.id_class         (id_class         ), // Instruction class
.id_subclass      (id_subclass      ), // Instruction subclass
.malu_cpr_rd_ben  (malu_cpr_rd_ben  ), // Writeback byte enable
.malu_cpr_rd_wdata(malu_cpr_rd_wdata)  // Writeback data
);

endmodule
