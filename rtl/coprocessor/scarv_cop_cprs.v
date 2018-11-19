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

`ifdef FORMAL
`include "fml_common.vh"
`endif

//
// module: scarv_cop_cprs
//
//  The general purpose register file used by the COP.
//
module scarv_cop_cprs (

input  wire             g_clk         , // Global clock
output wire             g_clk_req     , // Clock request
input  wire             g_resetn      , // Synchronous active low reset.

`ifdef FORMAL
`VTX_REGISTER_PORTS_OUT(cprs_snoop)
`endif

input  wire             crs1_ren      , // Port 1 read enable
input  wire [ 3:0]      crs1_addr     , // Port 1 address
output wire [31:0]      crs1_rdata    , // Port 1 read data

input  wire             crs2_ren      , // Port 2 read enable
input  wire [ 3:0]      crs2_addr     , // Port 2 address
output wire [31:0]      crs2_rdata    , // Port 2 read data

input  wire             crs3_ren      , // Port 3 read enable
input  wire [ 3:0]      crs3_addr     , // Port 3 address
output wire [31:0]      crs3_rdata    , // Port 3 read data

input  wire [ 3:0]      crd_wen       , // Port 4 write enable
input  wire [ 3:0]      crd_addr      , // Port 4 address
input  wire [31:0]      crd_wdata       // Port 4 write data

);

// Only need a clock when doing a write.
assign g_clk_req = crd_wen;

// Storage for the registers
reg [31:0] cprs [15:0];

`ifdef FORMAL
`VTX_REGISTER_PORTS_ASSIGNR(cprs_snoop,cprs)
`endif

//
// Read port logic
//

assign crs1_rdata = {32{crs1_ren}} & cprs[crs1_addr];
assign crs2_rdata = {32{crs2_ren}} & cprs[crs2_addr];
assign crs3_rdata = {32{crs3_ren}} & cprs[crs3_addr];

//
// Generate logic for each register.
//
genvar i;
generate for (i = 0; i < 16; i = i + 1) begin : gen_cprs

    always @(posedge g_clk) begin
        
        if(!g_resetn) begin
            `ifdef FORMAL
                // If running the yosys formal flow, allow initial
                // register values to be any constant value.
                cprs[i] <= $anyconst;
            `else
                cprs[i] <= 32'b0;
            `endif

        end else if((|crd_wen) && (crd_addr == i)) begin
            if(crd_wen[3]) cprs[i][31:24] <= crd_wdata[31:24];
            if(crd_wen[2]) cprs[i][23:16] <= crd_wdata[23:16];
            if(crd_wen[1]) cprs[i][15: 8] <= crd_wdata[15: 8];
            if(crd_wen[0]) cprs[i][ 7: 0] <= crd_wdata[ 7: 0];
        end

    end

end endgenerate

endmodule

