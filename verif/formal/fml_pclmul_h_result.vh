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


integer i;
integer j;

// Partial results
reg [63:0] pres [15:0];

always @(*) begin : pclmul_h_compute_expected_result
    
    expected_result = 0;

    for(j = 0; j < 16; j = j + 1) begin
        pres[j] = 0;
    end

    if         (pw == SCARV_COP_PW_1 ) begin
        
        pres[0] = `PW_CLMUL32(`CRS1[31: 0], `CRS2[31: 0],32);

        expected_result = pres[0][63:32];

    end else if(pw == SCARV_COP_PW_2 ) begin
        
        pres[1] = `PW_CLMUL32(`CRS1[31:16], `CRS2[31:16],16);
        pres[0] = `PW_CLMUL32(`CRS1[15: 0], `CRS2[15: 0],16);

        expected_result = {pres[1][31:16],pres[0][31:16]};

    end else if(pw == SCARV_COP_PW_4 ) begin
        
        pres[3] = `PW_CLMUL32(`CRS1[31:24], `CRS2[31:24],8);
        pres[2] = `PW_CLMUL32(`CRS1[23:16], `CRS2[23:16],8);
        pres[1] = `PW_CLMUL32(`CRS1[15: 8], `CRS2[15: 8],8);
        pres[0] = `PW_CLMUL32(`CRS1[ 7: 0], `CRS2[ 7: 0],8);

        expected_result = 
            {pres[3][15: 8],pres[2][15: 8],pres[1][15: 8],pres[0][15: 8]};

    end else if(pw == SCARV_COP_PW_8 ) begin
        
        pres[7] = `PW_CLMUL32(`CRS1[31:28], `CRS2[31:28],4);
        pres[6] = `PW_CLMUL32(`CRS1[27:24], `CRS2[27:24],4);
        pres[5] = `PW_CLMUL32(`CRS1[23:20], `CRS2[23:20],4);
        pres[4] = `PW_CLMUL32(`CRS1[19:16], `CRS2[19:16],4);
        pres[3] = `PW_CLMUL32(`CRS1[15:12], `CRS2[15:12],4);
        pres[2] = `PW_CLMUL32(`CRS1[11: 8], `CRS2[11: 8],4);
        pres[1] = `PW_CLMUL32(`CRS1[ 7: 4], `CRS2[ 7: 4],4);
        pres[0] = `PW_CLMUL32(`CRS1[ 3: 0], `CRS2[ 3: 0],4);

        expected_result = 
            {pres[7][ 7: 4],pres[6][ 7: 4],pres[5][ 7: 4],pres[4][ 7: 4], 
             pres[3][ 7: 4],pres[2][ 7: 4],pres[1][ 7: 4],pres[0][ 7: 4]};

    end else if(pw == SCARV_COP_PW_16) begin
        
        pres[15] = `PW_CLMUL32(`CRS1[31:30], `CRS2[31:30],2);
        pres[14] = `PW_CLMUL32(`CRS1[29:28], `CRS2[29:28],2);
        pres[13] = `PW_CLMUL32(`CRS1[27:26], `CRS2[27:26],2);
        pres[12] = `PW_CLMUL32(`CRS1[25:24], `CRS2[25:24],2);
        pres[11] = `PW_CLMUL32(`CRS1[23:22], `CRS2[23:22],2);
        pres[10] = `PW_CLMUL32(`CRS1[21:20], `CRS2[21:20],2);
        pres[9 ] = `PW_CLMUL32(`CRS1[19:18], `CRS2[19:18],2);
        pres[8 ] = `PW_CLMUL32(`CRS1[17:16], `CRS2[17:16],2);
        pres[7 ] = `PW_CLMUL32(`CRS1[15:14], `CRS2[15:14],2);
        pres[6 ] = `PW_CLMUL32(`CRS1[13:12], `CRS2[13:12],2);
        pres[5 ] = `PW_CLMUL32(`CRS1[11:10], `CRS2[11:10],2);
        pres[4 ] = `PW_CLMUL32(`CRS1[ 9: 8], `CRS2[ 9: 8],2);
        pres[3 ] = `PW_CLMUL32(`CRS1[ 7: 6], `CRS2[ 7: 6],2);
        pres[2 ] = `PW_CLMUL32(`CRS1[ 5: 4], `CRS2[ 5: 4],2);
        pres[1 ] = `PW_CLMUL32(`CRS1[ 3: 2], `CRS2[ 3: 2],2);
        pres[0 ] = `PW_CLMUL32(`CRS1[ 1: 0], `CRS2[ 1: 0],2);

        expected_result = 
            {pres[15][ 3: 2],pres[14][ 3: 2],pres[13][ 3: 2],pres[12][ 3: 2], 
             pres[11][ 3: 2],pres[10][ 3: 2],pres[9 ][ 3: 2],pres[8 ][ 3: 2],
             pres[7 ][ 3: 2],pres[6 ][ 3: 2],pres[5 ][ 3: 2],pres[4 ][ 3: 2], 
             pres[3 ][ 3: 2],pres[2 ][ 3: 2],pres[1 ][ 3: 2],pres[0 ][ 3: 2]};

    end

end
