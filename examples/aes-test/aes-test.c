
#include "common.h"

#include <scarv/aes_enc.h> 
#include <scarv/aes_dec.h> 

extern void aes_enc_sub_gather( uint8_t* s, uint8_t* sbox	   );
  
void test_aes_rand( uint8_t* r, int l_r ) {
//  FILE* fd = fopen( "/dev/urandom", "rb" ); fread( r, sizeof( uint8_t ), l_r, fd ); fclose( fd );
  uint32_t rnd;
  
  for (int i=0;i<l_r;i+=4){ 
    rngsamp(&rnd); 
    r[i] = rnd & 0xFF; rnd>>=8; 
    if (i+1<l_r) {r[i+1] = rnd & 0xFF; rnd>>=8;}
    if (i+2<l_r) {r[i+2] = rnd & 0xFF; rnd>>=8;}
    if (i+3<l_r) {r[i+3] = rnd & 0xFF; rnd>>=8;}
  } 
}    

void test_aes_dump( char* id, uint8_t* x, int l_x ) {
//   printf( "%s = binascii.a2b_hex( '", id );

  putstr(id);
  putstr(" = binascii.a2b_hex( '");
	 
  for( int i = 3; i < l_x; i+=4 ) {
    int t;
    t  = x[i-3]; t<<=8;
    t += x[i-2]; t<<=8;
    t += x[i-1]; t<<=8;		
    t += x[i];
//	printf( "%02X", x[ i ] ); 
	puthex(t);
  }

  putstr( "' ) \n" );  
}

void uint32_dump(char* id, uint32_t n){
  putstr(id);
  putstr(" = 0x");
  puthex(n);
  putstr( "\n" ); 
}

int main() {   
 
  int n = 1; 

  uint32_t random = 32;  
  rngseed(&random);      
 
  uint32_t key_cyc, cyc, start_t, end_t; 
  uint32_t key_ins, ins, start_i, end_i;     
	
  putstr( "import binascii, Crypto.Cipher.AES as AES\n" );

  #if defined( CONF_AES_ENABLE_ENC ) 
  for( int i = 0; i < n; i++ ) {
    uint8_t c[ 16 ], m[ 16 ], k[ 16 ];

    test_aes_rand( m, 16 );  
   	test_aes_rand( k, 16 );   
 		           
   
	uint8_t rk[ ( Nr + 1 ) * ( 4 * Nb ) ];  

    start_t = rdcycle(); start_i = rdinstret();
	aes_enc_exp( rk, k );  
    end_t   = rdcycle(); end_i   = rdinstret();

    key_cyc = end_t-start_t; key_ins = end_i-start_i;

    start_t = rdcycle(); start_i = rdinstret();
    aes_enc( c, m, rk,  AES_ENC_SBOX,  AES_MULX );
//  aes_enc( c, m, rk );
    end_t   = rdcycle(); end_i   = rdinstret();
 		
    cyc = end_t-start_t; ins = end_i-start_i;

    uint32_dump("key_cyc", key_cyc);
    uint32_dump("key_ins", key_ins);
    uint32_dump("cyc", cyc);
    uint32_dump("ins", ins);

    test_aes_dump( "m", m, 16 ); 
    test_aes_dump( "k", k, 16 ); 
   	test_aes_dump( "c", c, 16 ); 

    putstr( "print ('AES encryption executes %d instructions taking == %d cycles' % (ins, cyc))" "\n" );  	
    putstr( "print ('\t Pre-computed key expansion executes %d instructions taking == %d cycles' % (key_ins, key_cyc))" "\n\n" );

    putstr( "t = AES.new( k ).encrypt( m )                  " "\n" );
  
    putstr( "if( c != t ) :                                 " "\n" );
   	putstr( "  print ('failed test_aes: enc')                 " "\n" );
   	putstr( "  print ('m == %s' % ( binascii.b2a_hex( m ) ))" "\n" );
   	putstr( "  print ('k == %s' % ( binascii.b2a_hex( k ) ))" "\n" );
   	putstr( "  print ('c == %s' % ( binascii.b2a_hex( c ) ))" "\n" );
   	putstr( "  print ('  != %s' % ( binascii.b2a_hex( t ) ))" "\n" );
 	}   
  #endif              
  
  #if defined( CONF_AES_ENABLE_DEC )
  for( int i = 0; i < n; i++ ) {
    uint8_t m[ 16 ], c[ 16 ], k[ 16 ];
  
    test_aes_rand( c, 16 );
    test_aes_rand( k, 16 );     
      
  
    uint8_t rk[ ( Nr + 1 ) * ( 4 * Nb ) ];  
    start_t = rdcycle(); start_i = rdinstret();
    aes_dec_exp( rk, k ); 
    end_t   = rdcycle(); end_i   = rdinstret();
    key_cyc = end_t-start_t; key_ins = end_i-start_i;
			
    start_t = rdcycle(); start_i = rdinstret();
    aes_dec( m, c, rk,  AES_DEC_SBOX,  AES_MULX );
//  aes_dec( m, c, rk );
    end_t   = rdcycle(); end_i   = rdinstret(); 

    cyc = end_t-start_t; ins = end_i-start_i;

    test_aes_dump("k", k, 16 );
    test_aes_dump("c", c, 16 );
    test_aes_dump("m", m, 16 ); 

    uint32_dump("key_cyc", key_cyc);
    uint32_dump("key_ins", key_ins);
    uint32_dump("cyc", cyc);  
    uint32_dump("ins", ins);

    putstr( "print ('AES decryption executes %d instructions taking == %d cycles' % (ins, cyc))" "\n" );  
    putstr( "print ('\t Pre-computed key expansion executes %d instructions taking == %d cycles' % (key_ins, key_cyc))" "\n\n" );  

    putstr( "t = AES.new( k ).decrypt( c )                  " "\n" );
  
    putstr( "if( m != t ) :                                 " "\n" );
    putstr( "  print ('failed test_aes: dec')                 " "\n" );
    putstr( "  print ('c == %s' % ( binascii.b2a_hex( c ) ))" "\n" );
    putstr( "  print ('k == %s' % ( binascii.b2a_hex( k ) ))" "\n" );
    putstr( "  print ('m == %s' % ( binascii.b2a_hex( m ) ))" "\n" );
    putstr( "  print ('  != %s' % ( binascii.b2a_hex( t ) ))" "\n" );
  }
  #endif

  __pass();
}
