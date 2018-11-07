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
// Implement a single 1-byte lookup for the AES SBox or inverse SBox
//
module scarv_cop_aes_sbox (
input  wire [7:0] in    ,   // Input byte
input  wire       inv   ,   // Perform inverse (set) or forward lookup
output wire [7:0] out       // Output byte
);


wire [7:0] mat_fwd [7:0];
wire [7:0] mat_inv [7:0];

wire [7:0] const_fwd = 8'b11000110;
wire [7:0] const_inv = 8'b10100000;

assign mat_fwd[0] = 8'b10001111;
assign mat_fwd[1] = 8'b11000111;
assign mat_fwd[2] = 8'b11100011;
assign mat_fwd[3] = 8'b11110001;
assign mat_fwd[4] = 8'b11111000;
assign mat_fwd[5] = 8'b01111100;
assign mat_fwd[6] = 8'b00111110;
assign mat_fwd[7] = 8'b00011111;

assign mat_inv[0] = 8'b00100101;
assign mat_inv[1] = 8'b10010010;
assign mat_inv[2] = 8'b01001001;
assign mat_inv[3] = 8'b10100100;
assign mat_inv[4] = 8'b01010010;
assign mat_inv[5] = 8'b00101001;
assign mat_inv[6] = 8'b10010100;
assign mat_inv[7] = 8'b01001010;

wire [7:0] out_fwd =
   ((in ^ mat_fwd[0]) ^
    (in ^ mat_fwd[1]) ^
    (in ^ mat_fwd[2]) ^
    (in ^ mat_fwd[3]) ^
    (in ^ mat_fwd[4]) ^
    (in ^ mat_fwd[5]) ^
    (in ^ mat_fwd[6]) ^
    (in ^ mat_fwd[7])) ^
         const_fwd;

wire [7:0] out_inv =
    (in ^ const_inv) ^
   ((in ^ mat_inv[0]) ^
    (in ^ mat_inv[1]) ^
    (in ^ mat_inv[2]) ^
    (in ^ mat_inv[3]) ^
    (in ^ mat_inv[4]) ^
    (in ^ mat_inv[5]) ^
    (in ^ mat_inv[6]) ^
    (in ^ mat_inv[7])) ;

assign out = inv ? out_inv : out_fwd;

endmodule
