
# Byte Addressable Registers

- RISC-V currently only allows its general purpose register file to be written
  one word at a time.
- This is inefficient in terms of power consumption (you have to clock an
  entire register rather than just a bytes worth) and forces more register
  spills than needed when operating mostly on byte or halfword data.
- By making the GPRs byte addressable, operations involving chars / bytes can
  become much more efficient. 
- Needing two extra address bits for each register address requires a lot of
  instruction encoding space. It might be sensible to limit the byte-addressable
  registers to a subset of the GPRs, or only allow two register operand instructions
  where one source register is also the destination register.
- RISC-V has 7 temp registers and 8 argument registers. Making only these byte
  addressable would need 6 bits of register address in an instruction coding, and
  a mapping of 6-bit encodings onto 5-bit register addresses and 2-bit byte
  indexes. Or, just using the 8 argument registers, everything stays in 5-bits.
- Having 16 byte addressable registers means an entire AES-128 round state can be
  kept inside the CPU without needing register spills.
