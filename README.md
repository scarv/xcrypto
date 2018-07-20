
# Random Operand Padding and Byte Addressable Registers

This project looks at combining byte-addressable general purpose registers with
random operand padding as a way of reducing side channel leakage.

- Random bus precharging: done before
- Byte addressable registers: not novel either

Novel bit:
- ISA support for data operand hiding by utilising the existing, unused
  parts of the datapath.
- Actually putting this all together and making the implementation / evaluation
  available to people.

- I think this scheme should give a *net energy efficency increase* for things
  like AES, since it dramatically reduces the need for register spills to
  memory.
- Fewer register spills imply less chance of memory address/data bus leakage as
  well as a performance improvment.
- The concept is generally applicable to block ciphers using bytes as their base
  unit of encryption, and all other codes which work on byte-size data.

---

- [Random Operand Padding](docs/operand-padding.md)
- [Byte Addressing Registers](docs/byte-registers.md)
- [Instruction Proposals](docs/instructions.md)
- [Implementation Notes](docs/implementation.md)

