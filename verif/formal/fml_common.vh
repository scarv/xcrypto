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
// file: fml_common.vh
//
//  Contains various commonly used macros for the formal environment.
//

`define VTX_CLK_NAME vtx_clk

// Start a checker block
`define VTX_CHECK_BEGIN(NAME) always @(posedge `VTX_CLK_NAME) \
    if(vtx_valid) begin : NAME

// End a checker block
`define VTX_CHECK_END(NAME) end

// Start an instruction checker block.
`define VTX_CHECK_INSTR_BEGIN(NAME) always @(posedge `VTX_CLK_NAME) \
    if(vtx_valid && dec_``NAME) begin : check_instr_``NAME


// Name of arrays to registers ports.
`define VTX_REGISTER_PORT_NAME(NAME,IDX) _``IDX``_``NAME``

`define VTX_REGISTER_PORTS_CON(PORT,CONN) \
    .`VTX_REGISTER_PORT_NAME(PORT, 0 )(``CONN[0 ]),  \
    .`VTX_REGISTER_PORT_NAME(PORT, 1 )(``CONN[1 ]),  \
    .`VTX_REGISTER_PORT_NAME(PORT, 2 )(``CONN[2 ]),  \
    .`VTX_REGISTER_PORT_NAME(PORT, 3 )(``CONN[3 ]),  \
    .`VTX_REGISTER_PORT_NAME(PORT, 4 )(``CONN[4 ]),  \
    .`VTX_REGISTER_PORT_NAME(PORT, 5 )(``CONN[5 ]),  \
    .`VTX_REGISTER_PORT_NAME(PORT, 6 )(``CONN[6 ]),  \
    .`VTX_REGISTER_PORT_NAME(PORT, 7 )(``CONN[7 ]),  \
    .`VTX_REGISTER_PORT_NAME(PORT, 8 )(``CONN[8 ]),  \
    .`VTX_REGISTER_PORT_NAME(PORT, 9 )(``CONN[9 ]),  \
    .`VTX_REGISTER_PORT_NAME(PORT, 10)(``CONN[10]),  \
    .`VTX_REGISTER_PORT_NAME(PORT, 11)(``CONN[11]),  \
    .`VTX_REGISTER_PORT_NAME(PORT, 12)(``CONN[12]),  \
    .`VTX_REGISTER_PORT_NAME(PORT, 13)(``CONN[13]),  \
    .`VTX_REGISTER_PORT_NAME(PORT, 14)(``CONN[14]),  \
    .`VTX_REGISTER_PORT_NAME(PORT, 15)(``CONN[15]),  \


`define VTX_REGISTER_PORTS_IN(NAME) \
    input wire [31:0]   `VTX_REGISTER_PORT_NAME(NAME, 0 ), \
    input wire [31:0]   `VTX_REGISTER_PORT_NAME(NAME, 1 ), \
    input wire [31:0]   `VTX_REGISTER_PORT_NAME(NAME, 2 ), \
    input wire [31:0]   `VTX_REGISTER_PORT_NAME(NAME, 3 ), \
    input wire [31:0]   `VTX_REGISTER_PORT_NAME(NAME, 4 ), \
    input wire [31:0]   `VTX_REGISTER_PORT_NAME(NAME, 5 ), \
    input wire [31:0]   `VTX_REGISTER_PORT_NAME(NAME, 6 ), \
    input wire [31:0]   `VTX_REGISTER_PORT_NAME(NAME, 7 ), \
    input wire [31:0]   `VTX_REGISTER_PORT_NAME(NAME, 8 ), \
    input wire [31:0]   `VTX_REGISTER_PORT_NAME(NAME, 9 ), \
    input wire [31:0]   `VTX_REGISTER_PORT_NAME(NAME, 10), \
    input wire [31:0]   `VTX_REGISTER_PORT_NAME(NAME, 11), \
    input wire [31:0]   `VTX_REGISTER_PORT_NAME(NAME, 12), \
    input wire [31:0]   `VTX_REGISTER_PORT_NAME(NAME, 13), \
    input wire [31:0]   `VTX_REGISTER_PORT_NAME(NAME, 14), \
    input wire [31:0]   `VTX_REGISTER_PORT_NAME(NAME, 15), \

`define VTX_REGISTER_PORTS_ASSIGN(TO,FROM) \
    assign TO[0 ] = `VTX_REGISTER_PORT_NAME(FROM, 0 ); \
    assign TO[1 ] = `VTX_REGISTER_PORT_NAME(FROM, 1 ); \
    assign TO[2 ] = `VTX_REGISTER_PORT_NAME(FROM, 2 ); \
    assign TO[3 ] = `VTX_REGISTER_PORT_NAME(FROM, 3 ); \
    assign TO[4 ] = `VTX_REGISTER_PORT_NAME(FROM, 4 ); \
    assign TO[5 ] = `VTX_REGISTER_PORT_NAME(FROM, 5 ); \
    assign TO[6 ] = `VTX_REGISTER_PORT_NAME(FROM, 6 ); \
    assign TO[7 ] = `VTX_REGISTER_PORT_NAME(FROM, 7 ); \
    assign TO[8 ] = `VTX_REGISTER_PORT_NAME(FROM, 8 ); \
    assign TO[9 ] = `VTX_REGISTER_PORT_NAME(FROM, 9 ); \
    assign TO[10] = `VTX_REGISTER_PORT_NAME(FROM, 10); \
    assign TO[11] = `VTX_REGISTER_PORT_NAME(FROM, 11); \
    assign TO[12] = `VTX_REGISTER_PORT_NAME(FROM, 12); \
    assign TO[13] = `VTX_REGISTER_PORT_NAME(FROM, 13); \
    assign TO[14] = `VTX_REGISTER_PORT_NAME(FROM, 14); \
    assign TO[15] = `VTX_REGISTER_PORT_NAME(FROM, 15); \

