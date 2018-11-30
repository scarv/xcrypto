
#include "common.h"

#include "scarv/mpn.h"
#include "scarv/limb.h"


int test_mpn_rand( limb_t* r, int l_min, int l_max ) {
    
    int rnum;
    rngsamp(&rnum);
    rnum = rnum & l_max;

    int l_r = (( rnum % ( l_max + 1 - l_min) ) + l_min);

    for (int i = 0; i < l_r; i ++) {
        rngsamp(&r[i]);
    }

    return l_r;
} 

void test_mpn_dump( char* id, limb_t* x, int l_x ) {
    putstr(id);
    putstr( " = long( '");

    for( int i = l_x - 1; i >= 0; i-- ) {
        puthex( x[ i ] );
    }

    putstr( "', 16 )\n" );
}

void test_mpn( int n, int l_min, int l_max ) {
  
  uint32_t instr_start = 0;
  uint32_t cycle_start = 0;
  uint32_t instr_end   = 0;
  uint32_t cycle_end   = 0;

  #define BMARK_START()   instr_start = rdinstret(); cycle_start = rdcycle()
  #define BMARK_END()     instr_end   = rdinstret(); cycle_end   = rdcycle()
  #define BMARK_DUMP(FN)  putstr("performance.append((\""); \
                          putstr( #FN );       putstr("\",0x"); \
                          puthex(l_x);         putstr(",0x"); \
                          puthex(l_y);         putstr(",0x"); \
                          puthex(instr_start); putstr(",0x"); \
                          puthex(instr_end  ); putstr(",0x"); \
                          puthex(cycle_start); putstr(",0x"); \
                          puthex(cycle_end  ); putstr("))\n"); \

  for( int i = 0; i < n; i++ ) {
    limb_t x[ 2 * l_max + 2 ]; int l_x;
    limb_t y[ 2 * l_max + 2 ]; int l_y;
    limb_t r[ 2 * l_max + 2 ]; int l_r;
    
    l_x = test_mpn_rand( x, l_min, l_max );
    l_y = test_mpn_rand( y, l_min, l_max );
    

      l_r = MAX( l_x, l_y ) + 1; 
      BMARK_START();
      r[ l_r - 1 ] = mpn_add( r, x, l_x, y, l_y ); 
      BMARK_END();
      BMARK_DUMP(mpn_add);
      l_r = mpn_lop( r, l_r );

    test_mpn_dump( "x", x, l_x );  
    test_mpn_dump( "y", y, l_y );  
    test_mpn_dump( "r", r, l_r );  

      putstr( "t = x + y                         " "\n" );
  
      putstr( "if( r != t ) :                    " "\n" );
      putstr( "  print 'failed test_mpn: add '   " "\n" );
      putstr( "  print 'x == %s' % ( hex( x ).rjust(75) )" "\n" );
      putstr( "  print 'y == %s' % ( hex( y ).rjust(75) )" "\n" );
      putstr( "  print 'r == %s' % ( hex( r ).rjust(75) )" "\n" );
      putstr( "  print '  != %s' % ( hex( t ).rjust(75) )" "\n" );
  }

  for( int i = 0; i < n; i++ ) {
    limb_t x[ 2 * l_max + 2 ]; int l_x;
    limb_t y[ 2 * l_max + 2 ]; int l_y;
    limb_t r[ 2 * l_max + 2 ]; int l_r;

    l_x = test_mpn_rand( x, l_min, l_max );
    l_y = test_mpn_rand( y, l_min, l_max );
  
    if( mpn_cmp( x, l_x, y, l_y ) >= 0 ) {
      l_r = MAX( l_x, l_y ) + 1; 
      BMARK_START();
      r[ l_r - 1 ] = mpn_sub( r, x, l_x, y, l_y ); 
      BMARK_END();
      BMARK_DUMP(mpn_sub);
      l_r = mpn_lop( r, l_r );
    } 
    else {
      l_r = MAX( l_y, l_x ) + 1; 
      BMARK_START();
      r[ l_r - 1 ] = mpn_sub( r, y, l_y, x, l_x ); 
      BMARK_END();
      BMARK_DUMP(mpn_sub);
      l_r = mpn_lop( r, l_r );
    }

    test_mpn_dump( "x", x, l_x );  
    test_mpn_dump( "y", y, l_y );  
    test_mpn_dump( "r", r, l_r );  

    if( mpn_cmp( x, l_x, y, l_y ) >= 0 ) {
      putstr( "t = x - y                         " "\n" );
    }
    else {
      putstr( "t = y - x                         " "\n" );
    }

      putstr( "if( r != t ) :                    " "\n" );
      putstr( "  print 'failed test_mpn: sub'    " "\n" );
      putstr( "  print 'x == %s' % ( hex( x ) )" "\n" );
      putstr( "  print 'y == %s' % ( hex( y ) )" "\n" );
      putstr( "  print 'r == %s' % ( hex( r ) )" "\n" );
      putstr( "  print '  != %s' % ( hex( t ) )" "\n" );
  }

  for( int i = 0; i < n; i++ ) {
    limb_t x[ 2 * l_max + 2 ]; int l_x;
    limb_t y[ 2 * l_max + 2 ]; int l_y;
    limb_t r[ 2 * l_max + 2 ]; int l_r;

    l_x = test_mpn_rand( x, l_min, l_max );
    l_y = test_mpn_rand( y, l_min, l_max );

      l_r = l_x + l_y;
      BMARK_START();
                     mpn_mul( r, x, l_x, y, l_y ); 
      BMARK_END();
      BMARK_DUMP(mpn_mul);
      l_r = mpn_lop( r, l_r );

    test_mpn_dump( "x", x, l_x );  
    test_mpn_dump( "y", y, l_y );  
    test_mpn_dump( "r", r, l_r );  

      putstr( "t = x * y                         " "\n" );

      putstr( "if( r != t ) :                    " "\n" );
      putstr( "  print 'failed test_mpn: mul'    " "\n" );
      putstr( "  print 'x == %s' % ( hex( x ) )" "\n" );
      putstr( "  print 'y == %s' % ( hex( y ) )" "\n" );
      putstr( "  print 'r == %s' % ( hex( r ).rjust(150) )" "\n" );
      putstr( "  print '  != %s' % ( hex( t ).rjust(150) )" "\n" );
  }
  
  putstr("#finish\n");

}


int main() {
  
    putstr("performance = []\n");
    
    for(int i = 1; i < 10; i ++) {
        test_mpn(5, i, i);
    }

    __pass();
}
