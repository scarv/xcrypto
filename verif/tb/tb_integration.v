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

`timescale 1ns/1ps

//
// module: tb_integration
//
//  The top level integration testbench.
//
module tb_integration ();

//
// Clock and reset generation
//

reg g_clk;
reg g_resetn;

initial g_clk           = 0;
always @(g_clk) #20 g_clk <= !g_clk;

initial g_resetn        = 0;
initial #80 g_resetn    = 1;

//
// Simulation Parameter Handling
//
integer    TB_MAX_CYCLES    = 1000;

reg [31:0] TB_PASS_ADDRESS  = 32'hFFFF_FFF3;
reg [31:0] TB_FAIL_ADDRESS  = 32'hFFFF_FFF5;

reg [255*8:0] tb_wavesfile;
reg [255*8:0] tb_imemfile;

//
// Read command line arguments
initial begin
    if($value$plusargs("IMEM=%s",tb_imemfile)) begin
        $display("IMEM :    %s", tb_imemfile);
    end
    if($value$plusargs("TIMEOUT=%d",TB_MAX_CYCLES)) begin
        $display("TIMEOUT : %d", TB_MAX_CYCLES);
    end
    if($value$plusargs("PASS_ADDR=%h",TB_PASS_ADDRESS)) begin
        TB_PASS_ADDRESS = TB_PASS_ADDRESS;
        $display("PASS :    %h", TB_PASS_ADDRESS);
    end
    if($value$plusargs("FAIL_ADDR=%h",TB_FAIL_ADDRESS)) begin
        TB_FAIL_ADDRESS = TB_FAIL_ADDRESS;
        $display("FAIL :    %h", TB_FAIL_ADDRESS);
    end
end



//
// Simulation halting

integer cycle_count = 0;

always @(posedge g_clk) begin
    if(cycle_count > TB_MAX_CYCLES) begin
        $display("TIMEOUT. Cycle count > %d", TB_MAX_CYCLES);
        $finish;
    end else if(M_AXI_I_ARADDR == TB_PASS_ADDRESS) begin
        $display("Simulation pass address hit - SIM PASS");
        $finish;
    end else if(M_AXI_I_ARADDR == TB_FAIL_ADDRESS) begin
        $display("Simulation fail address hit - SIM FAIL");
        $finish;
    end else begin
        cycle_count = cycle_count + 1;
    end
end


//
// Setup wave dumping
initial begin
    if($value$plusargs("WAVES=%s",tb_wavesfile)) begin
        $display("WAVES : %s", tb_wavesfile);
    end else begin
        tb_wavesfile="work/integ-waves-icarus.vcd";
    end
    $dumpfile(tb_wavesfile);
    $dumpvars(0,tb_integration);
end

//
// Testbench wiring
//

wire        prv_trap          ; // PicoRV32 Exception

//
// PicoRV32 AXI4-lite master memory interface
wire        prv_axi_awvalid   ;
wire        prv_axi_awready   ;
wire [31:0] prv_axi_awaddr    ;
wire [ 2:0] prv_axi_awprot    ;

wire        prv_axi_wvalid    ;
wire        prv_axi_wready    ;
wire [31:0] prv_axi_wdata     ;
wire [ 3:0] prv_axi_wstrb     ;

wire        prv_axi_bvalid    ;
wire        prv_axi_bready    ;

wire        prv_axi_arvalid   ;
wire        prv_axi_arready   ;
wire [31:0] prv_axi_araddr    ;
wire [ 2:0] prv_axi_arprot    ;

wire        prv_axi_rvalid    ;
wire        prv_axi_rready    ;
wire [31:0] prv_axi_rdata     ;

//
// XCrypto Cop AXI4-lite master memory interface
wire        cop_axi_awvalid   ;
wire        cop_axi_awready   ;
wire [31:0] cop_axi_awaddr    ;
wire [ 2:0] cop_axi_awprot    ;

wire        cop_axi_wvalid    ;
wire        cop_axi_wready    ;
wire [31:0] cop_axi_wdata     ;
wire [ 3:0] cop_axi_wstrb     ;

wire        cop_axi_bvalid    ;
wire        cop_axi_bready    ;

wire        cop_axi_arvalid   ;
wire        cop_axi_arready   ;
wire [31:0] cop_axi_araddr    ;
wire [ 2:0] cop_axi_arprot    ;

wire        cop_axi_rvalid    ;
wire        cop_axi_rready    ;
wire [31:0] cop_axi_rdata     ;

//
// PicoRV32 IRQ interface
wire [31:0] prv_irq           ;
wire [31:0] prv_eoi           ;

//
// PicoRV32 Trace Interface
wire        prv_trace_valid   ;
wire [35:0] prv_trace_data    ;

// --------------------- Simulation SRAM Models --------------------------

//
//  PicoRV memory model.
//
module axi_sram i_sram_pico(
.memfile      (tb_imemfile    ),  
.ACLK         (g_clk          ), // Master clock for the AXI interface.
.ARESETn      (g_resetn       ), // Active low asynchronous reset.
.M_AXI_ARADDR (prv_axi_araddr ), // 
.M_AXI_ARREADY(prv_axi_arready), // 
.M_AXI_ARSIZE (prv_axi_arsize ), // 
.M_AXI_ARVALID(prv_axi_arvalid), // 
.M_AXI_AWADDR (prv_axi_awaddr ), // 
.M_AXI_AWREADY(prv_axi_awready), // 
.M_AXI_AWSIZE (prv_axi_awsize ), // 
.M_AXI_AWVALID(prv_axi_awvalid), // 
.M_AXI_BREADY (prv_axi_bready ), // 
.M_AXI_BRESP  (prv_axi_bresp  ), // 
.M_AXI_BVALID (prv_axi_bvalid ), // 
.M_AXI_RDATA  (prv_axi_rdata  ), // 
.M_AXI_RREADY (prv_axi_rready ), // 
.M_AXI_RRESP  (prv_axi_rresp  ), // 
.M_AXI_RVALID (prv_axi_rvalid ), // 
.M_AXI_WDATA  (prv_axi_wdata  ), // 
.M_AXI_WREADY (prv_axi_wready ), // 
.M_AXI_WSTRB  (prv_axi_wstrb  ), // 
.M_AXI_WVALID (prv_axi_wvalid )  // 
);

//
//  Crypto co-processor memory model.
//
module axi_sram i_sram_cop(
.memfile      (tb_imemfile    ),  
.ACLK         (g_clk          ), // Master clock for the AXI interface.
.ARESETn      (g_resetn       ), // Active low asynchronous reset.
.M_AXI_ARADDR (prv_axi_araddr ), // 
.M_AXI_ARREADY(prv_axi_arready), // 
.M_AXI_ARSIZE (prv_axi_arsize ), // 
.M_AXI_ARVALID(prv_axi_arvalid), // 
.M_AXI_AWADDR (prv_axi_awaddr ), // 
.M_AXI_AWREADY(prv_axi_awready), // 
.M_AXI_AWSIZE (prv_axi_awsize ), // 
.M_AXI_AWVALID(prv_axi_awvalid), // 
.M_AXI_BREADY (prv_axi_bready ), // 
.M_AXI_BRESP  (prv_axi_bresp  ), // 
.M_AXI_BVALID (prv_axi_bvalid ), // 
.M_AXI_RDATA  (prv_axi_rdata  ), // 
.M_AXI_RREADY (prv_axi_rready ), // 
.M_AXI_RRESP  (prv_axi_rresp  ), // 
.M_AXI_RVALID (prv_axi_rvalid ), // 
.M_AXI_WDATA  (prv_axi_wdata  ), // 
.M_AXI_WREADY (prv_axi_wready ), // 
.M_AXI_WSTRB  (prv_axi_wstrb  ), // 
.M_AXI_WVALID (prv_axi_wvalid )  // 
);

// --------------------- Subsystem Model ---------------------------------

//
// instance: scarv_prv_xcrypt_top
//
//  The top level module for the integrated PicoRV32 and XCrypto
//  Co-Processor.
//
scarv_prv_xcrypt_top i_dut(
g_clk          (g_clk          ),
g_resetn       (g_resetn       ),
prv_trap       (prv_trap       ), // PicoRV32 Exception
prv_axi_awvalid(prv_axi_awvalid),
prv_axi_awready(prv_axi_awready),
prv_axi_awaddr (prv_axi_awaddr ),
prv_axi_awprot (prv_axi_awprot ),
prv_axi_wvalid (prv_axi_wvalid ),
prv_axi_wready (prv_axi_wready ),
prv_axi_wdata  (prv_axi_wdata  ),
prv_axi_wstrb  (prv_axi_wstrb  ),
prv_axi_bvalid (prv_axi_bvalid ),
prv_axi_bready (prv_axi_bready ),
prv_axi_arvalid(prv_axi_arvalid),
prv_axi_arready(prv_axi_arready),
prv_axi_araddr (prv_axi_araddr ),
prv_axi_arprot (prv_axi_arprot ),
prv_axi_rvalid (prv_axi_rvalid ),
prv_axi_rready (prv_axi_rready ),
prv_axi_rdata  (prv_axi_rdata  ),
cop_axi_awvalid(cop_axi_awvalid),
cop_axi_awready(cop_axi_awready),
cop_axi_awaddr (cop_axi_awaddr ),
cop_axi_awprot (cop_axi_awprot ),
cop_axi_wvalid (cop_axi_wvalid ),
cop_axi_wready (cop_axi_wready ),
cop_axi_wdata  (cop_axi_wdata  ),
cop_axi_wstrb  (cop_axi_wstrb  ),
cop_axi_bvalid (cop_axi_bvalid ),
cop_axi_bready (cop_axi_bready ),
cop_axi_arvalid(cop_axi_arvalid),
cop_axi_arready(cop_axi_arready),
cop_axi_araddr (cop_axi_araddr ),
cop_axi_arprot (cop_axi_arprot ),
cop_axi_rvalid (cop_axi_rvalid ),
cop_axi_rready (cop_axi_rready ),
cop_axi_rdata  (cop_axi_rdata  ),
prv_irq        (prv_irq        ),
prv_eoi        (prv_eoi        ),
prv_trace_valid(prv_trace_valid),
prv_trace_data (prv_trace_data )
);

endmodule
