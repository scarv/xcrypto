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
// module: scarv_cop_mem
//
//  Load/store memory access module.
//
module scarv_cop_mem (
input  wire         g_clk            , // Global clock
input  wire         g_resetn         , // Synchronous active low reset.

input  wire         mem_ivalid       , // Valid instruction input
output wire         mem_idone        , // Instruction complete

output wire         mem_addr_error   , // Memory address exception
output wire         mem_bus_error    , // Memory bus exception
output wire         mem_is_store     , // Is this a store instruction?

input  wire [31:0]  gpr_rs1          , // GPR Source register 1
input  wire [31:0]  cpr_rs1          , // Source register 2
input  wire [31:0]  cpr_rs2          , // Source register 2
input  wire [31:0]  cpr_rs3          , // Source register 3

input  wire         id_wb_h          , // Halfword index (load/store)
input  wire         id_wb_b          , // Byte index (load/store)
input  wire [31:0]  id_imm           , // Source immedate
input  wire [ 2:0]  id_class         , // Instruction class
input  wire [ 4:0]  id_subclass      , // Instruction subclass

output wire [ 3:0]  mem_cpr_rd_ben   , // Writeback byte enable
output wire [31:0]  mem_cpr_rd_wdata , // Writeback data

//
// Memory Interface
output wire         cop_mem_cen      , // Chip enable
output wire         cop_mem_wen      , // write enable
output wire [31:0]  cop_mem_addr     , // Read/write address (word aligned)
output wire [31:0]  cop_mem_wdata    , // Memory write data
input  wire [31:0]  cop_mem_rdata    , // Memory read data
output wire [ 3:0]  cop_mem_ben      , // Write Byte enable
input  wire         cop_mem_stall    , // Stall
input  wire         cop_mem_error      // Error
);

// Common field encodings and definitions
`include "scarv_cop_common.vh"

wire is_mem  = mem_ivalid && id_class == SCARV_COP_ICLASS_LOADSTORE;

wire is_lw   = is_mem && id_subclass == SCARV_COP_SCLASS_LD_W;
wire is_lh   = is_mem && id_subclass == SCARV_COP_SCLASS_LH_CR;
wire is_lb   = is_mem && id_subclass == SCARV_COP_SCLASS_LB_CR;
wire is_sw   = is_mem && id_subclass == SCARV_COP_SCLASS_ST_W;
wire is_sh   = is_mem && id_subclass == SCARV_COP_SCLASS_ST_H;
wire is_sb   = is_mem && id_subclass == SCARV_COP_SCLASS_ST_B;

wire single_mem = is_lw || is_lh || is_lb || is_sw || is_sh || is_sb;

wire is_ga_b = is_mem && id_subclass == SCARV_COP_SCLASS_GATHER_B;
wire is_ga_h = is_mem && id_subclass == SCARV_COP_SCLASS_GATHER_H;

wire is_sc_b = is_mem && id_subclass == SCARV_COP_SCLASS_SCATTER_B;
wire is_sc_h = is_mem && id_subclass == SCARV_COP_SCLASS_SCATTER_H;

wire word_op     = is_lw || is_sw;
wire halfword_op = is_lh || is_sh || is_sc_h || is_ga_h;
wire byte_op     = is_lb || is_sb || is_sc_b || is_ga_b;

// Current and next memory FSM states.
reg [3:0]   mem_fsm;
reg [3:0] n_mem_fsm;

wire    fsm_idle   = mem_fsm == FSM_IDLE;
wire    fsm_h1     = mem_fsm == FSM_SG_H_1;
wire    fsm_b1     = mem_fsm == FSM_SG_B_1;
wire    fsm_b2     = mem_fsm == FSM_SG_B_2;
wire    fsm_b3     = mem_fsm == FSM_SG_B_3;
wire    n_fsm_idle = n_mem_fsm == FSM_IDLE;
wire    n_fsm_h1   = n_mem_fsm == FSM_SG_H_1;
wire    n_fsm_b1   = n_mem_fsm == FSM_SG_B_1;
wire    n_fsm_b2   = n_mem_fsm == FSM_SG_B_2;
wire    n_fsm_b3   = n_mem_fsm == FSM_SG_B_3;

// Previous value of chip enable.
reg       p_cen;

// Previous address least significant two bits
reg [1:0] p_addr_lsbs;

//
// Address computation
reg  [15:0] sg_offset;
always @(*) begin
    if(is_ga_b || is_sc_b)
        sg_offset = cpr_rs2[7:0];
    else
        sg_offset = cpr_rs2[15:0];

    if(n_fsm_h1 || fsm_h1)
        sg_offset = cpr_rs2[31:16];
    
    if(n_fsm_b1 || fsm_b1)
        sg_offset = cpr_rs2[15: 8];

    if(n_fsm_b2 || fsm_b2)
        sg_offset = cpr_rs2[23:16];

    if(n_fsm_b3 || fsm_b3)
        sg_offset = cpr_rs2[31:24];
end

wire [31:0] addr_offset = single_mem ? id_imm       :
                                       sg_offset    ;
wire [31:0] mem_address = gpr_rs1 + addr_offset     ;

//
// Bus wire assignments.

assign cop_mem_cen    = mem_ivalid && !mem_idone && !mem_addr_error;

assign cop_mem_addr   = mem_address & {{30{cop_mem_cen}},2'b00};

assign cop_mem_wen    = is_sc_b || is_sc_h || is_sw || is_sh || is_sb;
assign mem_is_store   = cop_mem_wen;

// Byte lane select wires.
wire   ben_word       = is_sw;
wire   ben_hw_lo      = (is_sh || is_sc_h) && !mem_address[1];
wire   ben_hw_hi      = (is_sh || is_sc_h) &&  mem_address[1];
wire   ben_b_3        = (is_sb || is_sc_b) &&  mem_address[1:0] == 2'b11;
wire   ben_b_2        = (is_sb || is_sc_b) &&  mem_address[1:0] == 2'b10;
wire   ben_b_1        = (is_sb || is_sc_b) &&  mem_address[1:0] == 2'b01;
wire   ben_b_0        = (is_sb || is_sc_b) &&  mem_address[1:0] == 2'b00;

assign cop_mem_ben[3] = ben_word || ben_hw_hi || ben_b_3;
assign cop_mem_ben[2] = ben_word || ben_hw_hi || ben_b_2;
assign cop_mem_ben[1] = ben_word || ben_hw_lo || ben_b_1;
assign cop_mem_ben[0] = ben_word || ben_hw_lo || ben_b_0;
 
// Write data select.
wire [31:0] hw_wdata = id_wb_h ? cpr_rs2[31:16] : cpr_rs2[15:0];
reg  [31:0] by_wdata;

always @(*) begin
    if(is_sc_b) begin
        by_wdata = n_fsm_idle ? cpr_rs3[ 7: 0]    :
                   n_fsm_b1   ? cpr_rs3[15: 8]    :
                   n_fsm_b2   ? cpr_rs3[23:16]    :
                   n_fsm_b3   ? cpr_rs3[31:24]    :
                              0                 ;
    end else if(is_sc_h) begin
        by_wdata = n_fsm_idle ? cpr_rs3[15: 0]    :
                   n_fsm_h1   ? cpr_rs3[31:16]    :
                              0                 ;
    end else if(id_wb_h) begin
        by_wdata = id_wb_b ? cpr_rs2[31:24]: cpr_rs2[23:16];
    end else begin
        by_wdata = id_wb_b ? cpr_rs2[15: 8]: cpr_rs2[ 7: 0];
    end
end

assign cop_mem_wdata =
    is_sw            ? cpr_rs2                                  :
    is_sh || is_sc_h ? hw_wdata << (mem_address[1] ? 16 : 0)    :
    is_sb || is_sc_b ? by_wdata << {mem_address[1:0],3'b00}     :
                       32'b0                                    ;

// Memory transaction finish tracking
wire mem_txn_good  = 
    p_cen && !cop_mem_stall && !(cop_mem_error || mem_addr_error);

wire mem_txn_error = mem_bus_error || mem_addr_error;

//
// Is the instruction finished, and how did it finish.

assign mem_bus_error =
     mem_ivalid && p_cen && !cop_mem_stall && cop_mem_error;


// Compute address errors based on inputs to the address computation, not
// on the computed address.
//  This prevents logic loops where the next FSM state depends on the
//  computed memory address being correct, but where the computed memory
//  address also depends on the *next* fsm state.
wire w_addr_err     = |((gpr_rs1[1:0] + id_imm[1:0])&2'b11);
wire h_addr_err     = gpr_rs1[0] || id_imm[0];
wire sgh_0_addr_err = gpr_rs1[0] || cpr_rs2[0];
wire sgh_1_addr_err = gpr_rs1[0] || cpr_rs2[16];

assign mem_addr_error   = 
    (is_sw   || is_lw  ) && w_addr_err   ||
    (is_sh   || is_lh  ) && h_addr_err   ||
    (is_ga_h || is_sc_h) && (sgh_0_addr_err || sgh_1_addr_err);

assign mem_idone        = 
    mem_ivalid && mem_txn_good && n_mem_fsm == FSM_IDLE       ||
    mem_ivalid && mem_txn_error                                ;

// Clear high bytes/halfword
wire clear_hb = is_lb && !id_wb_h && !id_wb_b;
wire clear_hh = is_lh && !id_wb_h;

//
// Writeback data assignment.
wire wb_hw_hi = (is_lh &&  id_wb_h) || (is_ga_h && fsm_h1  );
wire wb_hw_lo = (is_lh && !id_wb_h) || (is_ga_h && fsm_idle);

wire wb_b_3   = (is_lb &&  id_wb_h &&  id_wb_b) || (is_ga_b && fsm_b3  );
wire wb_b_2   = (is_lb &&  id_wb_h && !id_wb_b) || (is_ga_b && fsm_b2  );
wire wb_b_1   = (is_lb && !id_wb_h &&  id_wb_b) || (is_ga_b && fsm_b1  );
wire wb_b_0   = (is_lb && !id_wb_h && !id_wb_b) || (is_ga_b && fsm_idle);

wire [7:0] loaded_bytes [3:0];  // Load data as array of bytes
reg  [7:0] wb_bytes     [3:0];  // Writeback data as array of bytes.

assign loaded_bytes[3] = cop_mem_rdata[31:24];
assign loaded_bytes[2] = cop_mem_rdata[23:16];
assign loaded_bytes[1] = cop_mem_rdata[15: 8];
assign loaded_bytes[0] = cop_mem_rdata[ 7: 0];

// Gathers the loaded bytes and arranges them so the
// correct loaded byte goes to the correct CPR destination
// byte.
always @(*) begin
    wb_bytes[3] = loaded_bytes[3];
    wb_bytes[2] = loaded_bytes[2];
    wb_bytes[1] = loaded_bytes[1];
    wb_bytes[0] = loaded_bytes[0];

    if(word_op) begin
        // Do nothing, correct by default

    end else if(halfword_op) begin
        if(wb_hw_hi) begin
            wb_bytes[3] = p_addr_lsbs[1] ? loaded_bytes[3] : loaded_bytes[1];
            wb_bytes[2] = p_addr_lsbs[1] ? loaded_bytes[2] : loaded_bytes[0];
        end else if(!p_addr_lsbs[1] && !id_wb_h) begin
            // Do nothing, correct by default

        end else if(!p_addr_lsbs[1] &&  id_wb_h) begin
            wb_bytes[3] = loaded_bytes[1];
            wb_bytes[2] = loaded_bytes[0];

        end else if( p_addr_lsbs[1] && !id_wb_h) begin
            wb_bytes[1] = loaded_bytes[3];
            wb_bytes[0] = loaded_bytes[2];

        end else if( p_addr_lsbs[1] &&  id_wb_h) begin
            // Do nothing, correct by default

        end
    end else if(byte_op) begin
        if(wb_b_0)
            wb_bytes[0] = loaded_bytes[p_addr_lsbs];
        else if(wb_b_1)
            wb_bytes[1] = loaded_bytes[p_addr_lsbs];
        else if(wb_b_2)
            wb_bytes[2] = loaded_bytes[p_addr_lsbs];
        else if(wb_b_3)
            wb_bytes[3] = loaded_bytes[p_addr_lsbs];
        else
            wb_bytes[{id_wb_h,id_wb_b}] = loaded_bytes[p_addr_lsbs];
    end
end

assign mem_cpr_rd_wdata  = 
    {32{mem_txn_good && mem_ivalid}} & 
    {wb_bytes[3] & {8{!(clear_hb || clear_hh)}},
     wb_bytes[2] & {8{!(clear_hb || clear_hh)}},
     wb_bytes[1] & {8{!clear_hb}},
     wb_bytes[0]};

assign mem_cpr_rd_ben[3] = mem_txn_good && (is_lw || wb_hw_hi || wb_b_3 || clear_hb || clear_hh);
assign mem_cpr_rd_ben[2] = mem_txn_good && (is_lw || wb_hw_hi || wb_b_2 || clear_hb || clear_hh);
assign mem_cpr_rd_ben[1] = mem_txn_good && (is_lw || wb_hw_lo || wb_b_1 || clear_hb);
assign mem_cpr_rd_ben[0] = mem_txn_good && (is_lw || wb_hw_lo || wb_b_0);

//
// FSM state names
localparam FSM_IDLE     = 4'd0;
localparam FSM_SG_B_1   = 4'd4;
localparam FSM_SG_B_2   = 4'd8;
localparam FSM_SG_B_3   = 4'd1;
localparam FSM_SG_H_1   = 4'd5;

//
// FSM next state computation
always @(*) begin: p_n_mem_fsm
    case(mem_fsm)
        FSM_IDLE:
            if(is_sc_b || is_ga_b)
                n_mem_fsm = mem_txn_good  ?  FSM_SG_B_1 :
                                             FSM_IDLE   ;
            else if(is_sc_h || is_ga_h)
                n_mem_fsm = mem_txn_good  ?  FSM_SG_H_1 :
                                             FSM_IDLE   ;
            else
                n_mem_fsm = FSM_IDLE;
        FSM_SG_H_1:
            n_mem_fsm = mem_txn_good  ? FSM_IDLE  :
                        mem_txn_error ? FSM_IDLE  :
                                        FSM_SG_H_1;
        FSM_SG_B_1:
            n_mem_fsm = mem_txn_good  ? FSM_SG_B_2:
                        mem_txn_error ? FSM_IDLE  :
                                        FSM_SG_B_1;
        FSM_SG_B_2:
            n_mem_fsm = mem_txn_good  ? FSM_SG_B_3:
                        mem_txn_error ? FSM_IDLE  :
                                        FSM_SG_B_2;
        FSM_SG_B_3:
            n_mem_fsm = mem_txn_good  ? FSM_IDLE  :
                        mem_txn_error ? FSM_IDLE  :
                                        FSM_SG_B_3;
        default:
            n_mem_fsm = FSM_IDLE;
    endcase
end


//
// FSM state progression
always @(posedge g_clk) begin
    if(!g_resetn) begin
        mem_fsm <= FSM_IDLE;
    end else begin
        mem_fsm <= n_mem_fsm;
    end
end


//
// Recording of chip enable.
wire n_p_cen = cop_mem_cen && !mem_idone;

always @(posedge g_clk) begin
    if(!g_resetn) begin
        p_cen <= 1'b0;
        p_addr_lsbs <= 2'b00;
    end else begin
        // If we are finishing the instruction, the for the purposes of
        // the next instruction,  p_cen is always clear.
        p_cen <= n_p_cen;
        p_addr_lsbs <= mem_address[1:0];
    end
end

endmodule
