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
// module: scarv_prv_xcrypt_top
//
//  The top level module for the integrated PicoRV32 and XCrypto
//  Co-Processor.
//
module scarv_prv_xcrypt_top (
input   wire  g_clk             ,
input   wire  g_resetn          ,

output  wire  prv_trap          , // PicoRV32 Exception

//
// PicoRV32 AXI4-lite master memory interface
output        prv_axi_awvalid   ,
input         prv_axi_awready   ,
output [31:0] prv_axi_awaddr    ,
output [ 2:0] prv_axi_awprot    ,

output        prv_axi_wvalid    ,
input         prv_axi_wready    ,
output [31:0] prv_axi_wdata     ,
output [ 3:0] prv_axi_wstrb     ,

input         prv_axi_bvalid    ,
output        prv_axi_bready    ,

output        prv_axi_arvalid   ,
input         prv_axi_arready   ,
output [31:0] prv_axi_araddr    ,
output [ 2:0] prv_axi_arprot    ,

input         prv_axi_rvalid    ,
output        prv_axi_rready    ,
input  [31:0] prv_axi_rdata     ,

//
// XCrypto Cop AXI4-lite master memory interface
output        cop_axi_awvalid   ,
input         cop_axi_awready   ,
output [31:0] cop_axi_awaddr    ,
output [ 2:0] cop_axi_awprot    ,

output        cop_axi_wvalid    ,
input         cop_axi_wready    ,
output [31:0] cop_axi_wdata     ,
output [ 3:0] cop_axi_wstrb     ,

input         cop_axi_bvalid    ,
output        cop_axi_bready    ,

output        cop_axi_arvalid   ,
input         cop_axi_arready   ,
output [31:0] cop_axi_araddr    ,
output [ 2:0] cop_axi_arprot    ,

input         cop_axi_rvalid    ,
output        cop_axi_rready    ,
input  [31:0] cop_axi_rdata     ,

//
// PicoRV32 IRQ interface
input  [31:0] prv_irq           ,
output [31:0] prv_eoi           ,

//
// PicoRV32 Trace Interface
output        prv_trace_valid   ,
output [35:0] prv_trace_data
);

//
// Expose parameters from the PicoRV32 up to the top level.
//
parameter  [ 0:0] PRV_ENABLE_COUNTERS       = 1;
parameter  [ 0:0] PRV_ENABLE_COUNTERS64     = 1;
localparam [ 0:0] PRV_ENABLE_REGS_16_31     = 1;
localparam [ 0:0] PRV_ENABLE_REGS_DUALPORT  = 1;
parameter  [ 0:0] PRV_TWO_STAGE_SHIFT       = 1;
parameter  [ 0:0] PRV_BARREL_SHIFTER        = 1;
parameter  [ 0:0] PRV_TWO_CYCLE_COMPARE     = 0;
parameter  [ 0:0] PRV_TWO_CYCLE_ALU         = 0;
parameter  [ 0:0] PRV_COMPRESSED_ISA        = 0;
parameter  [ 0:0] PRV_CATCH_MISALIGN        = 1;
parameter  [ 0:0] PRV_CATCH_ILLINSN         = 1;
localparam [ 0:0] PRV_ENABLE_PCPI           = 1;
parameter  [ 0:0] PRV_ENABLE_MUL            = 0;
parameter  [ 0:0] PRV_ENABLE_FAST_MUL       = 0;
parameter  [ 0:0] PRV_ENABLE_DIV            = 0;
parameter  [ 0:0] PRV_ENABLE_IRQ            = 0;
parameter  [ 0:0] PRV_ENABLE_IRQ_QREGS      = 1;
parameter  [ 0:0] PRV_ENABLE_IRQ_TIMER      = 1;
parameter  [ 0:0] PRV_ENABLE_TRACE          = 0;
parameter  [ 0:0] PRV_REGS_INIT_ZERO        = 1;
parameter  [31:0] PRV_MASKED_IRQ            = 32'h 0000_0000;
parameter  [31:0] PRV_LATCHED_IRQ           = 32'h ffff_ffff;
parameter  [31:0] PRV_PROGADDR_RESET        = 32'h C000_0000;
parameter  [31:0] PRV_PROGADDR_IRQ          = 32'h 0000_0004;
parameter  [31:0] PRV_STACKADDR             = 32'h ffff_ffff;


// Pico Co-Processor Interface (PCPI)
wire        pcpi_valid    ;
wire [31:0] pcpi_insn     ;
wire [31:0] pcpi_rs1      ;
wire [31:0] pcpi_rs2      ;
wire        pcpi_wr       ;
wire [31:0] pcpi_rd       ;
wire        pcpi_wait     ;
wire        pcpi_ready    ;

// XCrypto Co-Processor Interface
wire        cpu_insn_req  ; // Instruction request
wire        cop_insn_ack  ; // Instruction request acknowledge
wire [31:0] cpu_insn_enc  ; // Encoded instruction data
wire [31:0] cpu_rs1       ; // RS1 source data

wire        cop_wen       ; // COP write enable
wire [ 4:0] cop_waddr     ; // COP destination register address
wire [31:0] cop_wdata     ; // COP write data
wire [ 2:0] cop_result    ; // COP execution result
wire        cop_insn_rsp  ; // COP instruction finished
wire        cpu_insn_ack  ; // Instruction finish acknowledge

//
// XCrypto COP Memory Interface (SRAM-style)
wire        cop_mem_cen   ; // Chip enable
wire        cop_mem_wen   ; // write enable
wire [31:0] cop_mem_addr  ; // Read/write address (word aligned)
wire [31:0] cop_mem_wdata ; // Memory write data
wire [31:0] cop_mem_rdata ; // Memory read data
wire [ 3:0] cop_mem_ben   ; // Write Byte enable
wire        cop_mem_ready ; // Reqest ready

// Invert ready as picorv32 memory interface uses valid/ready whereas
// cop uses enable/stall
wire        cop_mem_stall = !cop_mem_ready;

// Bus error signal not supported by picorv32_axi_adapter
wire        cop_mem_error = 1'b0;


//
// instance: i_cop_mem2axi
//
//  Convert the COP memory interface to an AXI4 lite interface using the
//  existing PicoRV32 axi adapter module.
//
picorv32_axi_adapter i_cop_mem2axi (
.clk            (g_clk          ),
.resetn         (g_resetn       ),
.mem_axi_awvalid(cop_axi_awvalid),
.mem_axi_awready(cop_axi_awready),
.mem_axi_awaddr (cop_axi_awaddr ),
.mem_axi_awprot (cop_axi_awprot ),
.mem_axi_wvalid (cop_axi_wvalid ),
.mem_axi_wready (cop_axi_wready ),
.mem_axi_wdata  (cop_axi_wdata  ),
.mem_axi_wstrb  (cop_axi_wstrb  ),
.mem_axi_bvalid (cop_axi_bvalid ),
.mem_axi_bready (cop_axi_bready ),
.mem_axi_arvalid(cop_axi_arvalid),
.mem_axi_arready(cop_axi_arready),
.mem_axi_araddr (cop_axi_araddr ),
.mem_axi_arprot (cop_axi_arprot ),
.mem_axi_rvalid (cop_axi_rvalid ),
.mem_axi_rready (cop_axi_rready ),
.mem_axi_rdata  (cop_axi_rdata  ),
.mem_valid      (cop_mem_cen    ),
.mem_instr      (1'b0           ), // The COP never asks for instructions.
.mem_ready      (cop_mem_ready  ),
.mem_addr       (cop_mem_addr   ),
.mem_wdata      (cop_mem_wdata  ),
.mem_wstrb      (cop_mem_ben    ),
.mem_rdata      (cop_mem_rdata  )
);

//
// instance: i_pcpi2cop
//
//  Bridge module between the PicoRV32 PCPI and the COP
//
scarv_integ_prv_pcpi2cop i_pcpi2cop (
.pcpi_valid   (pcpi_valid   ),
.pcpi_insn    (pcpi_insn    ),
.pcpi_rs1     (pcpi_rs1     ),
.pcpi_rs2     (pcpi_rs2     ),
.pcpi_wr      (pcpi_wr      ),
.pcpi_rd      (pcpi_rd      ),
.pcpi_wait    (pcpi_wait    ),
.pcpi_ready   (pcpi_ready   ),
.cpu_insn_req (cpu_insn_req ), // Instruction request
.cop_insn_ack (cop_insn_ack ), // Instruction request acknowledge
.cpu_insn_enc (cpu_insn_enc ), // Encoded instruction data
.cpu_rs1      (cpu_rs1      ), // RS1 source data
.cop_wen      (cop_wen      ), // COP write enable
.cop_waddr    (cop_waddr    ), // COP destination register address
.cop_wdata    (cop_wdata    ), // COP write data
.cop_result   (cop_result   ), // COP execution result
.cop_insn_rsp (cop_insn_rsp ), // COP instruction finished
.cpu_insn_ack (cpu_insn_ack )  // Instruction finish acknowledge
);


//
// instance: scarv_cop_top
//
//  The top level module of the Crypto ISE co-processor.
//
scarv_fu_top i_scarv_cop_top(
.g_clk        (g_clk        ) , // Global clock
.g_resetn     (g_resetn     ) , // Synchronous active low reset.
.cpu_insn_req (cpu_insn_req ) , // Instruction request
.cop_insn_ack (cop_insn_ack ) , // Instruction request acknowledge
.cpu_insn_enc (cpu_insn_enc ) , // Encoded instruction data
.cpu_rs1      (cpu_rs1      ) , // RS1 source data
.cop_wen      (cop_wen      ) , // COP write enable
.cop_waddr    (cop_waddr    ) , // COP destination register address
.cop_wdata    (cop_wdata    ) , // COP write data
.cop_result   (cop_result   ) , // COP execution result
.cop_insn_rsp (cop_insn_rsp ) , // COP instruction finished
.cpu_insn_ack (cpu_insn_ack ) , // Instruction finish acknowledge
.cop_mem_cen  (cop_mem_cen  ) , // Chip enable
.cop_mem_wen  (cop_mem_wen  ) , // write enable
.cop_mem_addr (cop_mem_addr ) , // Read/write address (word aligned)
.cop_mem_wdata(cop_mem_wdata) , // Memory write data
.cop_mem_rdata(cop_mem_rdata) , // Memory read data
.cop_mem_ben  (cop_mem_ben  ) , // Write Byte enable
.cop_mem_stall(cop_mem_stall) , // Stall
.cop_mem_error(cop_mem_error)   // Error
);



//
// instance: i_picorv32_axi
//
//  The PicoRV32 core instance with AXI4-Lite interface.
//
picorv32_axi #(
.ENABLE_COUNTERS     (PRV_ENABLE_COUNTERS     ),
.ENABLE_COUNTERS64   (PRV_ENABLE_COUNTERS64   ),
.ENABLE_REGS_16_31   (PRV_ENABLE_REGS_16_31   ),
.ENABLE_REGS_DUALPORT(PRV_ENABLE_REGS_DUALPORT),
.TWO_STAGE_SHIFT     (PRV_TWO_STAGE_SHIFT     ),
.BARREL_SHIFTER      (PRV_BARREL_SHIFTER      ),
.TWO_CYCLE_COMPARE   (PRV_TWO_CYCLE_COMPARE   ),
.TWO_CYCLE_ALU       (PRV_TWO_CYCLE_ALU       ),
.COMPRESSED_ISA      (PRV_COMPRESSED_ISA      ),
.CATCH_MISALIGN      (PRV_CATCH_MISALIGN      ),
.CATCH_ILLINSN       (PRV_CATCH_ILLINSN       ),
.ENABLE_PCPI         (PRV_ENABLE_PCPI         ),
.ENABLE_MUL          (PRV_ENABLE_MUL          ),
.ENABLE_FAST_MUL     (PRV_ENABLE_FAST_MUL     ),
.ENABLE_DIV          (PRV_ENABLE_DIV          ),
.ENABLE_IRQ          (PRV_ENABLE_IRQ          ),
.ENABLE_IRQ_QREGS    (PRV_ENABLE_IRQ_QREGS    ),
.ENABLE_IRQ_TIMER    (PRV_ENABLE_IRQ_TIMER    ),
.ENABLE_TRACE        (PRV_ENABLE_TRACE        ),
.REGS_INIT_ZERO      (PRV_REGS_INIT_ZERO      ),
.MASKED_IRQ          (PRV_MASKED_IRQ          ),
.LATCHED_IRQ         (PRV_LATCHED_IRQ         ),
.PROGADDR_RESET      (PRV_PROGADDR_RESET      ),
.PROGADDR_IRQ        (PRV_PROGADDR_IRQ        ),
.STACKADDR           (PRV_STACKADDR           ) 
) i_picorv32_axi (
.clk            (g_clk          ),
.resetn         (g_resetn       ),
.trap           (prv_trap       ),
.mem_axi_awvalid(prv_axi_awvalid),
.mem_axi_awready(prv_axi_awready),
.mem_axi_awaddr (prv_axi_awaddr ),
.mem_axi_awprot (prv_axi_awprot ),
.mem_axi_wvalid (prv_axi_wvalid ),
.mem_axi_wready (prv_axi_wready ),
.mem_axi_wdata  (prv_axi_wdata  ),
.mem_axi_wstrb  (prv_axi_wstrb  ),
.mem_axi_bvalid (prv_axi_bvalid ),
.mem_axi_bready (prv_axi_bready ),
.mem_axi_arvalid(prv_axi_arvalid),
.mem_axi_arready(prv_axi_arready),
.mem_axi_araddr (prv_axi_araddr ),
.mem_axi_arprot (prv_axi_arprot ),
.mem_axi_rvalid (prv_axi_rvalid ),
.mem_axi_rready (prv_axi_rready ),
.mem_axi_rdata  (prv_axi_rdata  ),
.pcpi_valid     (pcpi_valid     ),
.pcpi_insn      (pcpi_insn      ),
.pcpi_rs1       (pcpi_rs1       ),
.pcpi_rs2       (pcpi_rs2       ),
.pcpi_wr        (pcpi_wr        ),
.pcpi_rd        (pcpi_rd        ),
.pcpi_wait      (pcpi_wait      ),
.pcpi_ready     (pcpi_ready     ),
.irq            (prv_irq        ),
.eoi            (prv_eoi        ),
.trace_valid    (prv_trace_valid),
.trace_data     (prv_trace_data ) 
);


endmodule
