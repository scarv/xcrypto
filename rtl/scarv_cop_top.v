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
output wire             cop_insn_ack    , // Instruction request acknowledge
input  wire             cpu_abort_req   , // Abort Instruction
input  wire [31:0]      cpu_insn_enc    , // Encoded instruction data
input  wire [31:0]      cpu_rs1         , // RS1 source data

output wire             cop_wen         , // COP write enable
output wire [ 4:0]      cop_waddr       , // COP destination register address
output wire [31:0]      cop_wdata       , // COP write data
output wire [ 2:0]      cop_result      , // COP execution result
output wire             cop_insn_rsp    , // COP instruction finished
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

assign cop_wen = 1'b0;
assign cop_waddr = 0;
assign cop_result = 0;
assign cop_wdata = 0;

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
wire [ 3:0]   id_crd1         ; // Instruction destination register 1
wire [ 3:0]   id_crd2         ; // Instruction destination register 2
wire [ 4:0]   id_rd           ; // GPR destination register
wire [ 4:0]   id_rs1          ; // GPR source register
wire [31:0]   id_imm          ; // Decoded immediate.

wire          crs1_ren        ; // CPR Port 1 read enable
wire [ 3:0]   crs1_addr       ; // CPR Port 1 address
wire [31:0]   crs1_rdata      ; // CPR Port 1 read data

wire          crs2_ren        ; // CPR Port 2 read enable
wire [ 3:0]   crs2_addr       ; // CPR Port 2 address
wire [31:0]   crs2_rdata      ; // CPR Port 2 read data

wire          crs3_ren        ; // CPR Port 3 read enable
wire [ 3:0]   crs3_addr       ; // CPR Port 3 address
wire [31:0]   crs3_rdata      ; // CPR Port 3 read data

wire [ 3:0]   crd_wen         ; // CPR Port 4 write enable
wire [ 3:0]   crd_addr        ; // CPR Port 4 address
wire [31:0]   crd_wdata       ; // CPR Port 4 write data

//
// BEGIN DUMMY CODE

reg dummy_ack = 0;
reg dummy_rsp = 0;

assign cop_insn_ack = dummy_ack && (cpu_insn_ack == cop_insn_rsp);
assign cop_insn_rsp = dummy_rsp;

wire new_in = cop_insn_ack && cpu_insn_req;

always @(posedge g_clk) dummy_ack <= !g_resetn    ? 1'b0 :
                                     cop_insn_rsp ? 1'b0 :
                                                    cpu_insn_req;

always @(posedge g_clk) begin
    if(      new_in)
        dummy_rsp <= 1'b1;
    else if(dummy_rsp && !cpu_insn_ack)
        dummy_rsp <= 1'b1;
    else
        dummy_rsp <= 1'b0;

end

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
.id_crd1     (id_crd1     ), // Instruction destination register 1
.id_crd2     (id_crd2     ), // Instruction destination register 2
.id_rd       (id_rd       ), // GPR destination register
.id_rs1      (id_rs1      ), // GPR source register
.id_imm      (id_imm      )  // Decoded immediate.
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

endmodule
