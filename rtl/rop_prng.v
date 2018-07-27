
// 
//  University of Bristol SCARV project
//


//
// module: rop_prng
//
//  Pseudo Random Number Generator (PRNG) block. Generates a random number
//  whenever `rng_en` is high on a rising clock edge.
// 
//  The RNG is a simple linear feedback shift register (LFSR) design, where
//  the random number N is used as the seed for N+1.
//
//  The seed can be updated manually using the `rng_wdata` and `rng_*_wen`
//  signals. Writing a word of the seed takes precedence over generating
//  a new random number.
//
module rop_prng (

input              clk     , // Global clock signal
input              resetn  , // Active low reset signal

input              rng_en    , // Generate the next random number.

output reg  [63:0] rng_random  // Current random number output

);

//
// parameter: SHF_RNG_RST
//
//  The value taken by the random seed register on a reset.
//
parameter [63:0] SHF_RNG_RST = 64'hFFFF_FFFF_FFFF_FFFF;

//
// process: p_rng
//
//  Process responsible for computing the next output value of rng_random.
//
always @(posedge clk ) begin : p_rng

    if(!resetn) begin
        
        rng_random <= SHF_RNG_RST;

    end else  if(rng_en) begin
            
        // Left shift up one bit.
        rng_random[63:1] <= rng_random[62:0];

        // The new input random bit:
        rng_random[0]    <= rng_random[63] ^ rng_random[62] ^
                            rng_random[60] ^ rng_random[59] ;

    end

end



endmodule
