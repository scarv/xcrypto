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
// module: model_checks
//
//  The set of checks used to make sure the model and DUT outputs
//  match.
//
module model_checks(

//
// Clock and reset interface

input  wire             g_clk           , // Global clock
output wire             g_clk_req       , // Clock request
input  wire             g_resetn        , // Synchronous active low reset.


//
// CPU -> COP interface
input  wire             dut_in_valid    , // Input Instruction valid
input  wire [31:0]      dut_insn_enc    , // Encoded instruction data
input  wire [31:0]      dut_rs1         , // RS1 source data

input  wire             grm_in_valid    , // Input Instruction valid
input  wire [31:0]      grm_insn_enc    , // Encoded instruction data
input  wire [31:0]      grm_rs1         , // RS1 source data


//
// COP -> CPU interface
input  wire             dut_out_valid   , // Output of DUT valid.
input  wire [ 2:0]      dut_result      , // Instruction execution result
input  wire             dut_rd_wen      , // GPR Write Enable
input  wire [ 4:0]      dut_rd_addr     , // GPR Write Address
input  wire [31:0]      dut_rd_data     , // Data to write to GPR

input  wire             grm_out_valid   , // Output of GRM valid.
input  wire [ 2:0]      grm_result      , // Instruction execution result
input  wire             grm_rd_wen      , // GPR Write Enable
input  wire [ 4:0]      grm_rd_addr     , // GPR Write Address
input  wire [31:0]      grm_rd_data       // Data to write to GPR

);

//
// Checking Macros
//
//  These allow the module to be used in both formal and simulation
//  based verification flows.
//

`ifdef FORMAL

`define MC_ASSERT_EQ(A,B) assert(!(A === B));

`else

`define MC_ASSERT_EQ(A,B) if(!(A === B)) begin \
    $display("t=%0d ERROR: Assertion failed: A (0x%h) === B (0x%h) ", \
        $time,A,B);  \
    #40 $finish; \
end \

`endif

// ------------------------------------------------------------------------

//
// Input Output Consistency
//
//  Check that we get the right number of output transactions for
//  the number of input transactions.
//

reg [10:0] tx_i_counter;
reg [10:0] tx_o_counter;

wire [10:0] n_tx_i_counter = tx_i_counter + dut_in_valid;
wire [10:0] n_tx_o_counter = tx_o_counter + dut_out_valid;

always @(posedge g_clk) tx_i_counter <= 
    !g_resetn ? 0 : n_tx_i_counter;

always @(posedge g_clk) tx_o_counter <= 
    !g_resetn ? 0 : n_tx_o_counter;

always @(posedge g_clk) if(
    grm_in_valid && dut_in_valid && !(dut_out_valid && grm_out_valid)) begin
    `MC_ASSERT_EQ(tx_o_counter, tx_i_counter)
end

// ------------------------------------------------------------------------


//
// Output Interface Checking
//
//  Check that the output / writeback interface of the DUT behaves as
//  expected.
//

always @(posedge g_clk) if(g_resetn) begin

    if(dut_out_valid && grm_out_valid) begin
        
        `MC_ASSERT_EQ(dut_result, grm_result)
        `MC_ASSERT_EQ(dut_rd_wen, grm_rd_wen)
        
        if(grm_rd_wen) begin
            
            `MC_ASSERT_EQ(dut_rd_addr, grm_rd_addr)
            `MC_ASSERT_EQ(dut_rd_data, grm_rd_data)

        end

    end

end


endmodule
