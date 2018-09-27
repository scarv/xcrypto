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
// module:      axi_sram
//
//  Description: A simple AXI SRAM module for testing.
//
//
module axi_sram(

input  wire [255*8:0] memfile,

input              ACLK         , // Master clock for the AXI interface.
input              ARESETn      , // Active low asynchronous reset.

input       [31:0] M_AXI_ARADDR,     // 
output reg         M_AXI_ARREADY,    // 
input       [ 2:0] M_AXI_ARSIZE,     // 
input              M_AXI_ARVALID,    // 

input       [31:0] M_AXI_AWADDR,     // 
output reg         M_AXI_AWREADY,    // 
input       [ 2:0] M_AXI_AWSIZE,     // 
input              M_AXI_AWVALID,    // 

input              M_AXI_BREADY,     // 
output reg  [ 1:0] M_AXI_BRESP,      // 
output reg         M_AXI_BVALID,     // 

output reg  [31:0] M_AXI_RDATA,      // 
input              M_AXI_RREADY,     // 
output reg  [ 1:0] M_AXI_RRESP,      // 
output reg         M_AXI_RVALID,     // 

input       [31:0] M_AXI_WDATA,      // 
output reg         M_AXI_WREADY,     // 
input       [ 3:0] M_AXI_WSTRB,      // 
input              M_AXI_WVALID      // 

);

parameter DEPTH = 8192 * 2;

// Stall lengths for each interface.
integer AR_STALL    = 0;
integer AW_STALL    = 0;
integer B_STALL     = 0;
integer R_STALL     = 0;
integer W_STALL     = 0;

// The internal memory array.
reg [7:0] memory [DEPTH-1:0];

//
// New values for the AXI Slave SRAM controlled outputs.
reg         n_ar_ready;
reg         ar_ready;
reg         n_aw_ready = 1'b0;
reg         n_w_ready = 1'b0;
reg [ 2: 0] n_b_resp;
reg         n_b_valid = 1'b0;
reg [ 2: 0] n_r_resp;
reg [31: 0] n_r_data;
reg         n_r_valid = 1'b0;

// Read addresses being responded too.
reg [31:0] raddr;
reg [31:0] waddr;
reg [ 2:0] wsize;
reg        w_pend;
initial    w_pend = 0;

integer read_rsp_pending;
initial read_rsp_pending = 0;

wire    block_read_req = read_rsp_pending > 0   &&
                         !M_AXI_RREADY          &&
                          M_AXI_ARVALID         &&
                          ar_ready               ;

assign M_AXI_ARREADY = ar_ready && !block_read_req;

always @(posedge ACLK) begin
if(M_AXI_ARVALID && M_AXI_ARREADY) read_rsp_pending = read_rsp_pending + 1;
if(M_AXI_RVALID  && M_AXI_RREADY ) read_rsp_pending = read_rsp_pending - 1;
end


//
// Process handling the AXI read request channel.
//
always @(ACLK, M_AXI_ARVALID) begin
    
    n_ar_ready = 1'b0; // Not ready by default.

    if         ( M_AXI_ARVALID &&  M_AXI_ARREADY) begin
        
        // Transaction complete. Randomise the next ready state.
        n_ar_ready = $random;
        raddr = M_AXI_ARADDR & 32'h0000_FFFF;

    end else if( M_AXI_ARVALID && !M_AXI_ARREADY) begin
        
        // Indicate ready on the next cycle, iff the master can accept
        // whatever currently in flight ready data there is being returned.
        n_ar_ready = !M_AXI_RVALID ||
                      M_AXI_RVALID && M_AXI_RREADY;
    
    end else if(!M_AXI_ARVALID &&  M_AXI_ARREADY) begin
        
        // No request pending. Randomise the next ready state.
        n_ar_ready = $random;
    
    end else if(!M_AXI_ARVALID && !M_AXI_ARREADY) begin
        
        // No request pending. Randomise the next ready state.
        n_ar_ready = $random;

    end

end

//
// Process handling the AXI read response channel.
//
always @(ACLK, M_AXI_RREADY) begin
    
    n_r_valid = 1'b0; // Not valid by default.
    n_r_resp  = 2'b00;
    n_r_data  = 'b0;

    if         ( M_AXI_RVALID &&  M_AXI_RREADY) begin
        
        // Transaction complete. If there is a read request pending, then
        // serve the response.
        n_r_valid = M_AXI_ARVALID && M_AXI_ARREADY;

        n_r_data[31:24] = memory[raddr + 3];
        n_r_data[23:16] = memory[raddr + 2];
        n_r_data[15: 8] = memory[raddr + 1];
        n_r_data[ 7: 0] = memory[raddr + 0];

    end else if( M_AXI_RVALID && !M_AXI_RREADY) begin

        // Trying to give a request but the master can't accept it yet.
        // RVALID must stay high until the request is accepted.
        n_r_valid = 1'b1;

        n_r_data[31:24] = M_AXI_RDATA[31:24];
        n_r_data[23:16] = M_AXI_RDATA[23:16];
        n_r_data[15: 8] = M_AXI_RDATA[15: 8];
        n_r_data[ 7: 0] = M_AXI_RDATA[ 7: 0];
    
    end else if(!M_AXI_RVALID) begin
        
        // If there is a request pending, service it. Otherwise. leave
        // RVALID low.
        
        n_r_valid = M_AXI_ARVALID && M_AXI_ARREADY;

        n_r_data[31:24] = memory[raddr + 3];
        n_r_data[23:16] = memory[raddr + 2];
        n_r_data[15: 8] = memory[raddr + 1];
        n_r_data[ 7: 0] = memory[raddr + 0];

    end

end



//
// Process handling the AXI write request channel.
//
always @(ACLK, M_AXI_AWREADY, M_AXI_WREADY) begin
    
    n_aw_ready = 1'b0; // Not ready by default.

    if         ( M_AXI_AWVALID &&  M_AXI_AWREADY) begin
        
        // Transaction complete. Randomise the next ready state.
        n_aw_ready = $random;
        waddr = M_AXI_AWADDR & 32'h0000_FFFF;
        wsize = M_AXI_AWSIZE;
        w_pend = 1'b1;

    end else if( M_AXI_AWVALID && !M_AXI_AWREADY) begin
        
        // Indicate ready on the next cycle, iff the master can accept
        // whatever currently in flight ready data there is being returned.
        n_aw_ready = !M_AXI_BVALID ||
                      M_AXI_BVALID && M_AXI_BREADY;
    
    end else if(!M_AXI_AWVALID &&  M_AXI_AWREADY) begin
        
        // No request pending. Randomise the next ready state.
        n_aw_ready = $random;
    
    end else if(!M_AXI_AWVALID && !M_AXI_AWREADY) begin
        
        // No request pending. Randomise the next ready state.
        n_aw_ready = $random;

    end

end


//
// Process handling the AXI write data channel.
//
always @(ACLK, M_AXI_WREADY, M_AXI_WREADY) begin
    
    n_w_ready = 1'b0; // Not ready by default.

    if         ( M_AXI_WVALID &&  M_AXI_WREADY) begin
        
        // Transaction complete. Randomise the next ready state.
        n_w_ready = $random;
        
        // Perform the actual write
        if(w_pend) begin
            if(wsize >= 3'b010) memory[waddr + 3] = M_AXI_WDATA[31:24];
            if(wsize >= 3'b010) memory[waddr + 2] = M_AXI_WDATA[23:16];
            if(wsize >= 3'b001) memory[waddr + 1] = M_AXI_WDATA[15: 8];
            if(wsize >= 3'b000) memory[waddr + 0] = M_AXI_WDATA[ 7: 0];
            w_pend = 1'b0;
        end

    end else if( M_AXI_WVALID && !M_AXI_WREADY) begin
        
        // Indicate ready on the next cycle, iff the master can accept
        // whatever currently in flight ready data there is being returned.
        n_w_ready = !M_AXI_BVALID ||
                     M_AXI_BVALID && M_AXI_BREADY;
    
    end else if(!M_AXI_WVALID &&  M_AXI_WREADY) begin
        
        // No request pending. Randomise the next ready state.
        n_w_ready = $random;
    
    end else if(!M_AXI_WVALID && !M_AXI_WREADY) begin
        
        // No request pending. Randomise the next ready state.
        n_w_ready = $random;

    end

end



//
// Process handling the AXI Write response channel.
//
always @(ACLK, M_AXI_BREADY) begin
    
    n_b_valid = 1'b0; // Not valid by default.
    n_b_resp  = 2'b00;

    if         ( M_AXI_BVALID &&  M_AXI_BREADY) begin
        
        // Transaction complete. If there is a read request pending, then
        // serve the response.
        n_b_valid = M_AXI_WVALID && M_AXI_WREADY;

    end else if( M_AXI_BVALID && !M_AXI_BREADY) begin

        // Trying to give a request but the master can't accept it yet.
        // RVALID must stay high until the request is accepted.
        n_b_valid = 1'b1;
    
    end else if(!M_AXI_BVALID) begin
        
        // If there is a request pending, service it. Otherwise. leave
        // RVALID low.
        
        n_b_valid = M_AXI_WVALID && M_AXI_WREADY;

    end

end



//
// Progress next to current values of the AXI outputs.
always @(posedge ACLK, negedge ARESETn) begin
    if(!ARESETn) begin
        ar_ready      <= 'b0;
        M_AXI_AWREADY <= 'b0; 
        M_AXI_WREADY  <= 'b0; 
        M_AXI_BRESP   <= 'b0;
        M_AXI_BVALID  <= 'b0;
        M_AXI_RRESP   <= 'b0;
        M_AXI_RDATA   <= 'b0;
        M_AXI_RVALID  <= 'b0;
    end else begin
        ar_ready      <= n_ar_ready;
        M_AXI_AWREADY <= n_aw_ready; 
        M_AXI_WREADY  <= n_w_ready ;
        M_AXI_BRESP   <= n_b_resp  ;
        M_AXI_BVALID  <= n_b_valid ;
        M_AXI_RRESP   <= n_r_resp  ;
        M_AXI_RDATA   <= n_r_data  ;
        M_AXI_RVALID  <= n_r_valid ;
    end
end


//
// Load the memory array with data on a reset.
always @(posedge ARESETn) begin
    integer i;

    if(memfile != "") begin
        $display("Loading %s", memfile);
        $readmemh(memfile, memory);
    end

    for(i = 0; i < DEPTH; i = i + 1) begin
        if(memory[i] == memory[i]) begin

        end else begin
            memory[i] = $random;
        end
    end
    
end



endmodule
