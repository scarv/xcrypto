
#include "common.h"

#include "scarv/sha2_256.h"

int main() {
    
    const uint32_t  input_len   = 32;
    const uint32_t  hash_len    = 32;

    uint8_t         input_bytes [input_len];
    uint8_t         hash        [hash_len ];

    for(int i = 0; i < input_len; i ++) {
        input_bytes[i] = i & 0xFF;
    }

    putstr("import hashlib\n");
    putstr("import binascii\n");
    putstr("import sys\n");

    for(int i = 0; i < 3; i  ++) {
        
        putstr("msg = '");
        for(int j = 0; j < input_len; j ++) {
            puthex8(input_bytes[j]);
        }
        putstr("'\n");
        putstr("msg_in = binascii.a2b_hex(msg)\n");

        uint32_t cycles = rdcycle();
        uint32_t iret   = rdinstret();
        sha2_256(hash, 1, input_bytes, input_len);
        cycles = rdcycle() - cycles;
        iret   = rdinstret() - iret;

        putstr("cycles = 0x"); puthex(cycles); putstr("\n");
        putstr("instrs = 0x"); puthex(iret  ); putstr("\n");
        
        putstr("hash_out = '");
        for(int j = 0; j < hash_len; j ++) {
            puthex8(hash[j]);

            input_bytes[j] = hash[j];
        }
        putstr("'\n");

        putstr("golden = hashlib.sha256(msg_in).hexdigest().upper()\n");
        putstr("print('cycles   = %d' % cycles  )\n");
        putstr("print('instrs   = %d' % instrs  )\n");
        putstr("print('msg      = %s' % msg     )\n");
        putstr("print('hash_out = %s' % hash_out)\n");
        putstr("print('golden   = %s' % golden  )\n");
        putstr("print('')\n");
        putstr("if(golden != hash_out):\n");
        putstr("    print('ERROR')\n");
        putstr("    sys.exit(1)\n");

    }

    __pass();
}
