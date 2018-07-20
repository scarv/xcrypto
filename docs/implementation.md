
# Implementation

- Implement most of the datapath functionality as a co-processor style
  block which can be easily integrated with the PicoRV32 core, or the
  Rocket Core.
- No modifications to the register file interface are needed so long as
  the convention of two-read one-write register ports is kept, in line with
  the rest of the RV32I base ISA.
- If RS1==RD implicitly for all new instructions, then the register file will
  not need modifying at all. However in this case, the benefits of being
  able to clock fewer registers are not obtained.


**Decisions**:

- Modify the register files and the core integrations so that only the
  nessesary bytes of registers are ever clocked.
  - This is essential to see the energy consumption benefits, and to
    show the leakage differences.
  - As a feature, it can be removed or turned off relatively easily.
  - Will require heavier modification of the core.

- Implement the new datapaths for the proposed instructions as a
  co-processor. This co-processor will have it's own memory interface.
  - This will make integration with all cores much easier.
  - Easier verification and design re-use.

- Use the "custom-0" instruction encoding space for the new instructions.
  - Instructions can be assembled easily using the `.insn` directive
    present in the RISC-V GNU ASM tool.
