
#include "common.h"
#include "benchmark.h"

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
    putstr( "int( '");

    for( int i = l_x - 1; i >= 0; i-- ) {
        puthex( x[ i ] );
    }

    putstr( "', 16 )" );
}

void test_mpn( int n, int l_min, int l_max ) {
    
  uint32_t instrs;
  uint32_t cycles;

  for( int i = 0; i < n; i++ ) {
    limb_t x[ 2 * l_max + 2 ]; int l_x;
    limb_t y[ 2 * l_max + 2 ]; int l_y;
    limb_t r[ 2 * l_max + 2 ]; int l_r;
    
    l_x = test_mpn_rand( x, l_min, l_max );
    l_y = test_mpn_rand( y, l_min, l_max );
    

    l_r = MAX( l_x, l_y ) + 1; 
    instrs = rdinstret();
    cycles = rdcycle  ();
    r[ l_r - 1 ] = mpn_add( r, x, l_x, y, l_y ); 
    instrs = rdinstret() - instrs;
    cycles = rdcycle  () - cycles;
    l_r = mpn_lop( r, l_r );

    XC_BENCHMARK_RECORD(addrec)
    XC_BENCHMARK_RECORD_ADD_INPUT(addrec, test_mpn_dump("x",x,l_x ))
    XC_BENCHMARK_RECORD_ADD_INPUT(addrec, test_mpn_dump("y",y,l_y ))
    XC_BENCHMARK_RECORD_ADD_OUTPUT(addrec, test_mpn_dump("r",r,l_r ))
    XC_BENCHMARK_RECORD_ADD_METRIC(addrec, cycles, putstr("0x");puthex(cycles));
    XC_BENCHMARK_RECORD_ADD_METRIC(addrec, instrs, putstr("0x");puthex(instrs));
    XC_BENCHMARK_SET_ADD(mpn_add, addrec)

  }

  for( int i = 0; i < n; i++ ) {
    limb_t x[ 2 * l_max + 2 ]; int l_x;
    limb_t y[ 2 * l_max + 2 ]; int l_y;
    limb_t r[ 2 * l_max + 2 ]; int l_r;

    l_x = test_mpn_rand( x, l_min, l_max );
    l_y = test_mpn_rand( y, l_min, l_max );


    XC_BENCHMARK_RECORD(subrec)
  
    if( mpn_cmp( x, l_x, y, l_y ) >= 0 ) {
      l_r = MAX( l_x, l_y ) + 1; 
      instrs = rdinstret();
      cycles = rdcycle  ();
      r[ l_r - 1 ] = mpn_sub( r, x, l_x, y, l_y ); 
      l_r = mpn_lop( r, l_r );
    
      XC_BENCHMARK_RECORD_ADD_INPUT(subrec, test_mpn_dump("x",x,l_x ))
      XC_BENCHMARK_RECORD_ADD_INPUT(subrec, test_mpn_dump("y",y,l_y ))
    } 
    else {
      l_r = MAX( l_y, l_x ) + 1; 
      instrs = rdinstret();
      cycles = rdcycle  ();
      r[ l_r - 1 ] = mpn_sub( r, y, l_y, x, l_x ); 
      instrs = rdinstret() - instrs;
      cycles = rdcycle  () - cycles;
      l_r = mpn_lop( r, l_r );
      
      XC_BENCHMARK_RECORD_ADD_INPUT(subrec, test_mpn_dump("y",y,l_y ))
      XC_BENCHMARK_RECORD_ADD_INPUT(subrec, test_mpn_dump("x",x,l_x ))
    }

    XC_BENCHMARK_RECORD_ADD_OUTPUT(subrec, test_mpn_dump("r",r,l_r ))
    XC_BENCHMARK_RECORD_ADD_METRIC(subrec, cycles, putstr("0x");puthex(cycles));
    XC_BENCHMARK_RECORD_ADD_METRIC(subrec, instrs, putstr("0x");puthex(instrs));
    XC_BENCHMARK_SET_ADD(mpn_sub, subrec)

  }

  for( int i = 0; i < n; i++ ) {
    limb_t x[ 2 * l_max + 2 ]; int l_x;
    limb_t y[ 2 * l_max + 2 ]; int l_y;
    limb_t r[ 2 * l_max + 2 ]; int l_r;

    l_x = test_mpn_rand( x, l_min, l_max );
    l_y = test_mpn_rand( y, l_min, l_max );

    l_r = l_x + l_y;
    instrs = rdinstret();
    cycles = rdcycle  ();
    mpn_mul( r, x, l_x, y, l_y ); 
    instrs = rdinstret() - instrs;
    cycles = rdcycle  () - cycles;
    
    XC_BENCHMARK_RECORD(mulrec)
    XC_BENCHMARK_RECORD_ADD_INPUT(mulrec, test_mpn_dump("x",x,l_x ))
    XC_BENCHMARK_RECORD_ADD_INPUT(mulrec, test_mpn_dump("y",y,l_y ))
    XC_BENCHMARK_RECORD_ADD_OUTPUT(mulrec, test_mpn_dump("r",r,l_r ))
    XC_BENCHMARK_RECORD_ADD_METRIC(mulrec, cycles, putstr("0x");puthex(cycles));
    XC_BENCHMARK_RECORD_ADD_METRIC(mulrec, instrs, putstr("0x");puthex(instrs));
    XC_BENCHMARK_SET_ADD(mpn_mul, mulrec)
  }

}


int main() {
  
  XC_BENCHMARK_INIT;

  XC_BENCHMARK_SET(mpn_add, MPNAddTester)
  XC_BENCHMARK_SET(mpn_sub, MPNSubTester)
  XC_BENCHMARK_SET(mpn_mul, MPNMulTester)
    
    for(int i = 1; i < 10; i ++) {
        test_mpn(5, i, i);
    }
  
  XC_BENCHMARK_SET_REPORT(mpn_add)
  XC_BENCHMARK_SET_REPORT(mpn_sub)
  XC_BENCHMARK_SET_REPORT(mpn_mul)
  
  XC_BENCHMARK_SET_PASS(mpn_add)
  XC_BENCHMARK_SET_PASS(mpn_sub)
  XC_BENCHMARK_SET_PASS(mpn_mul)

    __pass();
}
