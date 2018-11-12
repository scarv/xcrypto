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

`include "fml_common.vh"

//
// module: fml_top
//
//  Top level module for the formal abstraction logic.
//  Instantated in the top level formal testbench `tb_formal`.
//
module fml_top (

//
// Clock and reset interface

input  wire             g_clk           , // Global clock
input  wire             g_clk_req       , // Clock request
input  wire             g_resetn        , // Synchronous active low reset.

//
// Status Interface
input  wire [31:0]      cop_random      , // The most recent random sample
input  wire             cop_rand_sample , // cop_random valid when this high.

`VTX_REGISTER_PORTS_IN(cprs_snoop)

//
// CPU / COP Interface
input  wire             cpu_insn_req    , // Instruction request
input  wire             cop_insn_ack    , // Instruction request acknowledge
input  wire [31:0]      cpu_insn_enc    , // Encoded instruction data
input  wire [31:0]      cpu_rs1         , // RS1 source data

input  wire             cop_wen         , // COP write enable
input  wire [ 4:0]      cop_waddr       , // COP destination register address
input  wire [31:0]      cop_wdata       , // COP write data
input  wire [ 2:0]      cop_result      , // COP execution result
input  wire             cop_insn_rsp    , // COP instruction finished
input  wire             cpu_insn_ack    , // Instruction finish acknowledge

//
// Memory Interface
input  wire             cop_mem_cen     , // Chip enable
input  wire             cop_mem_wen     , // write enable
input  wire [31:0]      cop_mem_addr    , // Read/write address (word aligned)
input  wire [31:0]      cop_mem_wdata   , // Memory write data
input  wire [31:0]      cop_mem_rdata   , // Memory read data
input  wire [ 3:0]      cop_mem_ben     , // Write Byte enable
input  wire             cop_mem_stall   , // Stall
input  wire             cop_mem_error     // Error

);


// ----------------------------------------------------------------------
//
//  Top level constraints on inputs.
//
//

//
// Assume reset at the start of the trace and that there is only one
// reset event.
//
initial assume(g_resetn == 1'b0);

always @(posedge g_clk) begin
    if($past(g_resetn)) restrict(g_resetn == 1'b1);
end

// No requests during a reset
always @(posedge g_clk) if(!g_resetn) begin
    assume(!cpu_insn_req);
    assume(!cop_mem_stall);
    assume(!cop_mem_error);
end

//
// Assume correct behaviour of the memory interface
//
always @(posedge g_clk) begin
    if(!$past(cop_mem_cen)) begin
        // The error signal can only be asserted when the chip enable is high
        // in the previous cycle.
        assume(cop_mem_error == 1'b0);
    end
end

//
// Assume that the instruction request interface will behave correctly
//
always @(posedge g_clk) if(g_resetn) begin
    if        ($past(!cpu_insn_req && !cop_insn_ack)) begin
        
        // Require nothing

    end else if($past(cpu_insn_req && !cop_insn_ack)) begin
        
        assume($stable(cpu_insn_req));
        assume($stable(cpu_insn_enc));
        assume($stable(cpu_rs1     ));

    end else if($past( cpu_insn_req &&  cop_insn_ack)) begin

        // Require nothing
    
    end else if($past(!cpu_insn_req && !cop_insn_ack)) begin
        
        // Require nothing

    end
end

// ----------------------------------------------------------------------
//
// Transaction capture
//

wire vtx_new_instr = cpu_insn_req && cop_insn_ack;

reg [ 0:0] vtx_reset                ;
reg [ 0:0] vtx_valid                ;
reg [31:0] vtx_instr_enc    [ 1:0]  ;
reg [31:0] vtx_instr_rs1    [ 1:0]  ;
reg [ 2:0] vtx_instr_result         ;
reg [31:0] vtx_instr_wdata          ;
reg [ 4:0] vtx_instr_waddr          ;
reg [ 0:0] vtx_instr_wen            ;

wire[31:0] vtx_cprs_snoop   [15:0]  ;
reg [31:0] vtx_cprs_pre     [15:0]  ;
reg [31:0] vtx_cprs_post    [15:0]  ;

// Assign cpts_snoop_* ports in `VTX_REGISTER_PORTS_IN macro to the
// vtx_cprs_snoop array.
`VTX_REGISTER_PORTS_ASSIGN(vtx_cprs_snoop, cprs_snoop)

// Random sample tracking
reg [31:0] vtx_rand_sample          ;

always @(posedge g_clk) if (!g_resetn) vtx_rand_sample <= 32'b0;
    else if(cop_rand_sample) vtx_rand_sample <= cop_random;

// Memory transaction tracking per instruction.
reg        vtx_mem_cen      [ 4:0]  ;
reg        vtx_mem_wen      [ 4:0]  ;
reg [31:0] vtx_mem_addr     [ 4:0]  ;
reg [31:0] vtx_mem_wdata    [ 4:0]  ;
reg [31:0] vtx_mem_rdata    [ 4:0]  ;
reg [ 3:0] vtx_mem_ben      [ 4:0]  ;
reg        vtx_mem_error    [ 4:0]  ;

reg p_mem_cen;
always @(posedge g_clk) if(!g_resetn) p_mem_cen <= 1'b0;
    else p_mem_cen <= cop_mem_cen;

wire mem_txn_new    = !cop_mem_error &&
                      ((cop_mem_cen && !p_mem_cen) ||
                      (cop_mem_cen &&  p_mem_cen && !cop_mem_stall));

wire mem_txn_finish = p_mem_cen && !(cop_mem_stall);
    
always @(posedge g_clk) begin
    if(mem_txn_new) begin
        vtx_mem_cen  [0] <= cop_mem_cen  ;
        vtx_mem_wen  [0] <= cop_mem_wen  ;
        vtx_mem_addr [0] <= cop_mem_addr ;
        vtx_mem_wdata[0] <= cop_mem_wdata;
        vtx_mem_ben  [0] <= cop_mem_ben  ;
    end 
    if(mem_txn_finish) begin
        vtx_mem_rdata[0] <= cop_mem_rdata;
        vtx_mem_error[0] <= cop_mem_error;
    end
end

genvar i;
generate for (i=1 ; i < 5;i=i+1) begin
    always @(posedge g_clk) begin
        if(mem_txn_new) begin
            vtx_mem_cen  [i] <= vtx_mem_cen  [i-1];
            vtx_mem_wen  [i] <= vtx_mem_wen  [i-1];
            vtx_mem_addr [i] <= vtx_mem_addr [i-1];
            vtx_mem_wdata[i] <= vtx_mem_wdata[i-1];
            vtx_mem_ben  [i] <= vtx_mem_ben  [i-1];
        end
        if(mem_txn_finish) begin
            vtx_mem_rdata[i] <= vtx_mem_rdata[i-1];
            vtx_mem_error[i] <= vtx_mem_error[i-1];
        end
    end
end endgenerate

always @(posedge g_clk) vtx_reset <= g_resetn;

initial assume(vtx_valid == 0);

//
// Capture input instructions to the COP
//
always @(posedge g_clk) if(!g_resetn) begin
end else if(g_resetn && cpu_insn_req && cop_insn_ack) begin
    vtx_instr_enc[0]    <= cpu_insn_enc;
    vtx_instr_rs1[0]    <= cpu_rs1;
end

//
// Capture COP instruction results.
//
always @(posedge g_clk) if(
    g_resetn && cop_insn_rsp && cpu_insn_ack
) begin
    vtx_valid           <= 1'b1             ;
    vtx_instr_enc[1]    <= vtx_instr_enc[0] ;
    vtx_instr_rs1[1]    <= vtx_instr_rs1[0] ;
    vtx_instr_result    <= cop_result       ;
    vtx_instr_wdata     <= cop_wdata        ;
    vtx_instr_waddr     <= cop_waddr        ;
    vtx_instr_wen       <= cop_wen          ;
end else begin
    vtx_valid           <= 1'b0             ;
end

//
// Capture CPR values pre each instruction
//
generate for(i=0; i < 16; i = i + 1) begin
    always @(posedge g_clk) if(!g_resetn) begin
        vtx_cprs_pre[i] <= 0;
    end else if(vtx_new_instr) begin
        vtx_cprs_pre[i] <= vtx_cprs_snoop[i];
    end
end endgenerate

//
// Capture CPR values post each instruction
//
generate for(i=0; i < 16; i = i + 1) begin
    always @(posedge g_clk) if(!g_resetn) begin
        vtx_cprs_post[i] <= 0;
    end else if(cop_insn_rsp && cpu_insn_ack) begin
        vtx_cprs_post[i] <= vtx_cprs_snoop[i];
    end
end endgenerate


//
// Checker Instance
//
`FML_CHECK_NAME i_fml_checks(
    `VTX_FORMAL_MODULE_INSTANCE_PORTS
);

endmodule
