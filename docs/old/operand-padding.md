
# Operand Padding

## The Idea

- Microcontrollers frequently use a 32-bit architecture and datapath.
- When operating on bytes (as block ciphers often do) the upper 24-bits of the
  datapath are unused.
- By randomly pre-charging datapaths [1] we can obscure the power signature of
  critical operations.
- Adding versions of instructions which explicitly do this might be a good way
  to add side-channel resistance at the ISA level, by allowing programmers to
  choose which operations to hide.
- For all ALU instructions commonly used in block-ciphers, we add varients
  which can operate only on single byte inputs, and use the rest of the
  datapath to generate noise duing the result computation, and possibly
  throwing away the computed garbage at the end of the computation, or keeping
  it in a register for later use.
- Adding hardware support for this need not be expensive in terms of area.
- One can imagine the effect improving in a 64-bit architecture.

---

[1] - Bucci M., Guglielmo M., Luzzi R., Trifiletti A. (2004) A Power
Consumption Randomization Countermeasure for DPA-Resistant Cryptographic
Processors. In: Macii E., Paliouras V., Koufopavlou O. (eds) Integrated Circuit
and System Design. Power and Timing Modeling, Optimization and Simulation.
PATMOS 2004. Lecture Notes in Computer Science, vol 3254. Springer, Berlin,
Heidelberg
