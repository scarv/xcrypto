
#include "common.h"

#include "scarv/sha2_256.h"

int main() {
    
    const uint32_t  input_len   = 32;
    const uint32_t  hash_len    = 32;

    uint8_t         input_bytes [input_len];
    uint8_t         hash        [hash_len ];

    for(int i = 0; i < 10; i  ++) {
        
        putstr("0x");
        for(int j = input_len-1; j >= 0; j --) {
            puthex8(input_bytes[j]);
        }
        putstr(" ");

        sha2_256(hash, 1, input_bytes, input_len);
        
        putstr("0x");
        for(int j = hash_len-1; j >= 0; j --) {
            puthex8(hash[j]);

            input_bytes[j] = hash[j];
        }
        putchar('\n');

    }

    __pass();
}
