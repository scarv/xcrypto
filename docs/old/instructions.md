
# Candidate Instructions

Using RISC-V as a base, the following instructions and their behaviours are
proposed.

All of these assume that some subset of the general purpose registers are byte
addressable on write, and all are byte addressable for reads.

## Notation

```
GPRS[x]
```

Denotes the entire 32-bit value of GPR `x`.

```
GPRS[x][y]
```

Denotes the `y`'th byte of GPR `x`.

```
im[x:y]
```

Denotes the slice from bit `x` to bit `y` of variable `im`

```
{x,y}
```

Denotes the concatenation of variables `x` and `y`.

## Instructions

The encoding space for the instructions uses the predefined `custom1` RISC-V
opcode: `0101011`.

**R-type** Instructions:

XOR.RB, XOR.RBK, AND.RB, AND.RBK, OR.RB, OR.RBK

```
0000??? ----- ----- 001 ----- 0101011
  f7     rs2   rs1  f3   rd   opcode
```

**I-type** Instructions:

LB.B, LB.BK

```
------------  ----- 01? ----- 0101011
  imm[11:0]    rs1  f3   rd   opcode
```

**S-type** Instructions:

SB.B

```
 -------  ----- ----- 000  -----   0101011
imm[11:5]  rs2   rs1  f3  imm[4:0] opcode
```

### XOR.RB

Perform a logical XOR between two bytes, padding the input bytes upto 32-bits
with random data. The result now has the correct XOR'd value in the low 8
bits, plus 24-bits of random data.

If the `kr` (keep random) bit of the instruction is set, the whole 32-bit
result is written to `GPRS[rd]`. If it is not set, then the low 8-bits are
written to the specified byte of the target GPR `GPRS[rd][rdb]`.

**Mnemonics:**

```
XOR.RB  rd, rdb, rs1, rs1b, rs2, rs2b   # KR = 0
XOR.RBK rd, rdb, rs1, rs1b, rs2, rs2b   # KR = 1
```

**Encoding:**

```
XOR.RB  0000000 ----- ----- 001 ----- 0101011
XOR.RBK 0000001 ----- ----- 001 ----- 0101011
          f7     rs2   rs1  f3   rd   opcode
```

**Functionality:**

```
def XOR.RB(rd,rdb, rs1,rs1b, rs2,rs2b, kr):
    lhs = GPRS[rs1][rs1b]
    rhs = GPRS[rs1][rs2b]

    operand1 = {24_random_bits, lhs}
    operand2 = {24_random_bits, rhs}

    result = operand1 ^ operand2

    if(kr):
        GPRS[rd] = result
    else:
        GPRS[rd][rdb] = result[7:0]
```

### AND.RB

Perform a logical AND between two bytes, padding the input bytes upto 32-bits
with random data. The result now has the correct AND'd value in the low 8
bits, plus 24-bits of random data.

If the `kr` (keep random) bit of the instruction is set, the whole 32-bit
result is written to `GPRS[rd]`. If it is not set, then the low 8-bits are
written to the specified byte of the target GPR `GPRS[rd][rdb]`.

**Mnemonics:**

```
AND.RB  rd, rdb, rs1, rs1b, rs2, rs2b   # KR = 0
AND.RBK rd, rdb, rs1, rs1b, rs2, rs2b   # KR = 1
```

**Encoding:** 

```
AND.RB  0000010 ----- ----- 001 ----- 0101011
AND.RBK 0000011 ----- ----- 001 ----- 0101011
          f7     rs2   rs1  f3   rd   opcode
```

**Functionality:**

```
def AND.RB(rd,rdb, rs1,rs1b, rs2,rs2b, kr):
    lhs = GPRS[rs1][rs1b]
    rhs = GPRS[rs1][rs2b]

    operand1 = {24_random_bits, lhs}
    operand2 = {24_random_bits, rhs}

    result = operand1 & operand2

    if(kr):
        GPRS[rd] = result
    else:
        GPRS[rd][rdb] = result[7:0]
```

### OR.RB

Perform a logical OR between two bytes, padding the input bytes upto 32-bits
with random data. The result now has the correct OR'd value in the low 8
bits, plus 24-bits of random data.

If the `kr` (keep random) bit of the instruction is set, the whole 32-bit
result is written to `GPRS[rd]`. If it is not set, then the low 8-bits are
written to the specified byte of the target GPR `GPRS[rd][rdb]`.

**Mnemonics:**

```
OR.RB  rd, rdb, rs1, rs1b, rs2, rs2b   # KR = 0
OR.RBK rd, rdb, rs1, rs1b, rs2, rs2b   # KR = 1
```

**Encoding:** 

```
OR.RB  0000100 ----- ----- 001 ----- 0101011
OR.RBK 0000101 ----- ----- 001 ----- 0101011
         f7     rs2   rs1  f3   rd   opcode
```

**Functionality:**

```
def OR.RB(rd,rdb, rs1,rs1b, rs2,rs2b, kr):
    lhs = GPRS[rs1][rs1b]
    rhs = GPRS[rs1][rs2b]

    operand1 = {24_random_bits, lhs}
    operand2 = {24_random_bits, rhs}

    result = operand1 | operand2

    if(kr):
        GPRS[rd] = result
    else:
        GPRS[rd][rdb] = result[7:0]
```

### LB.B

Identical to the existing RISC-V load byte instruction, but the loaded byte
is written to a specific byte of the destination register, and *all other
destination register bytes are un-modified*.

**Mnemonics:**

```
LB.B  rd, rdb, imm(rs1)
```

**Encoding:**

```
LB.B    ------------  ----- 010 ----- 0101011
          imm[11:0]    rs1  f3   rd   opcode
```

**Functionality:**

```
def LB.B(rd,rdb, rs1, imm):
    
    base   = GPRS[rs1]
    offset = signextend(imm)

    ldata  = MEM[base+offset]

    GPRS[rd][rdb] = ldata
```

It is implementation dependent if the memory bus lines which are *not*
carrying the requested data are also randomised. This may only be possible
when the bus architecture can identify which byte lanes will be ignored by
the CPU.

### LB.BK

Identical to the existing RISC-V load byte instruction, but the loaded byte
is padded with 24 random bits. The whole word is then written back to the
destination register.

**Mnemonics:**

```
LB.BK  rd, rdb, imm(rs1)
```

**Encoding:**

```
LB.BK   ------------  ----- 011 ----- 0101011
          imm[11:0]    rs1  f3   rd   opcode
```

**Functionality:**

```
def LB.BK(rd, rs1, imm):
    
    base   = GPRS[rs1]
    offset = signextend(imm)

    ldata  = MEM[base+offset]

    GPRS[rd] = {24_random_bits,ldata}
```

Note that `LB.BK` operates on any GPR, and always writes an entire word.

It is implementation dependent if the memory bus lines which are *not*
carrying the requested data are also randomised. This may only be possible
when the bus architecture can identify which byte lanes will be ignored by
the CPU.


### SB.RB

Identical to the RISC-V store byte instruction, but can source the byte to be
written from any byte in the source register, rather than just the lowest
byte.

**Mnemonics:**

```
LB.SB  rs2, rs2b, imm(rs1)
```

**Encoding:**

```
SB.B    -------  ----- ----- 000  -----   0101011
       imm[11:5]  rs2   rs1  f3  imm[4:0] opcode
```

**Functionality:**

```
def SB.RB(rs1, rs2,rs2b, imm):
    base   = GPRS[rs1]
    offset = signextend(imm)

    MEM[base+offset] = GPRS[rs2][rs2b]
```

It is implementation dependent if the memory bus lines which are *not*
carrying the requested data are also randomised. This may only be possible
when the bus architecture can identify which byte lanes will be ignored by
the CPU.

