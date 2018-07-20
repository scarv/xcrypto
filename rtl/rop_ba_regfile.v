
//
// University of Brisol SCARV Project
//


//
//  module: rop_ba_regfile
//
//      A byte-addressable register-file.
//
module rop_ba_regfile (
input  wire         clk             , // Global clock

input  wire [ 4:0]  a_reg_addr      , // Register word address
input  wire         a_byte          , // Make byte request
input  wire [ 1:0]  a_byte_addr     , // Which byte to ask for
output wire [31:0]  a_rdata           // Returned word / zero padded byte

input  wire [ 4:0]  b_reg_addr      , // Register word address
input  wire         b_byte          , // Make byte request
input  wire [ 1:0]  b_byte_addr     , // Which byte to ask for
output wire [31:0]  b_rdata           // Returned word / zero padded byte

input  wire         c_wen           , // Write enable pin
input  wire [ 4:0]  c_reg_addr      , // Which register to write too
input  wire         c_byte          , // Write to specific byte / whole word
input  wire [ 1:0]  c_byte_addr     , // Which byte to write
input  wire [31:0]  c_wdata         , // LSB aligned write data

);


genvar r;
genvar b;

// Easily accessible read data of every byte register.
wire [31:0] gpr_rdata [31:0];

// Register 0 is always 0.
assign gpr_rdata[0] = 32'b0;


wire [31:0] a_reg_rdata = gpr_rdata[a_reg_addr];
wire [31:0] b_reg_rdata = gpr_rdata[b_reg_addr];


wire [7:0]  a_byte_rdata= 
    {8{a_byte_addr == 2'b00}} & a_reg_rdata[ 7: 0] |
    {8{a_byte_addr == 2'b01}} & a_reg_rdata[15: 8] |
    {8{a_byte_addr == 2'b10}} & a_reg_rdata[23:16] |
    {8{a_byte_addr == 2'b11}} & a_reg_rdata[31:24] ;


wire [7:0]  b_byte_rdata= 
    {8{b_byte_addr == 2'b00}} & b_reg_rdata[ 7: 0] |
    {8{b_byte_addr == 2'b01}} & b_reg_rdata[15: 8] |
    {8{b_byte_addr == 2'b10}} & b_reg_rdata[23:16] |
    {8{b_byte_addr == 2'b11}} & b_reg_rdata[31:24] ;


// Constantly read out requested data.
assign a_rdata = a_byte ? a_reg_rdata : {24'b0, a_byte_rdata};
assign b_rdata = b_byte ? b_reg_rdata : {24'b0, b_byte_rdata};


generate for(r = 1; r < 32; r = r + 1) begin : g_reg

    // Is register r being written too?
    wire reg_w_en = c_wen && c_reg_addr == r;

    for(b = 0; b < 4; b = b + 1) begin g_reg_byte

        // Storage register for byte b of register r.
        reg r_byte[7:0];
        
        // Is byte b of register r being written too *specifically*
        wire byte_w_en = c_byte && c_byte_addr == b;

        // Make the register byte data accessible.
        assign gpr_rdata[r][7 + b*8:b*8] = r_byte;
        
        always @(posedge clk) begin
            
            if(reg_w_en && !byte_w_en) begin
               
                // Write byte b of c_wdata to this register.
                r_byte <= c_wdata[7 + b*8:b*8];

            end else if(reg_w_en && byte_w_en) begin
                
                // Write low byte of c_wdata to this byte register.
                r_byte <= c_wdata[7:0];

            end
        end

    end

end

endmodule
