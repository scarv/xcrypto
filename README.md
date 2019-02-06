# XCrypto: a cryptographic ISE for RISC-V

*This project describes a complete Instruction Set Extension (ISE) for the
[RISC-V](https://riscv.org) 
architecture, aimed at accelerating cryptographic workloads.*

**Contents**

- [What is XCrypto?](#Getting-Started)
  - [Complementary Work](#Complementary-Work)
- [Project Organisation](#Project-Organisation)
- [Funding Sources](#Funding-Sources)

## What is XCrypto?

**The best place to start** getting a feel for what XCrypto does is to look
at the specification documents on the specification releases page
[here](https://github.com/scarv/xcrypto-spec/releases).
These explain both the ISE itself, the instructions and how to program it.

Briefly, XCrypto is an experimental instruction set extension to RISC-V
which tries to accelerate a very broad range of cryptographic workloads.
Historically, ISEs aimed at cryptography have been very specifically
targeted at single algorithms or primitives (think x86 AES instructions).
This work aims to experiment with types of instructions which apply to
as many different algorithm and primitive implementations as possible.

The rationale for this being that a general purpose ISE, while not
always as efficient as a special purpose one, will be much more flexible
as new cryptographic tools are developed.
Further, if one needs to accelerate a family of algorithms (Say, those
making up the TLS stack) then a single fixed function accelerator is
not as valuable.

### Complementary Work

There is an ongoing effort within the RISC-V foundation to develop
a cryptographic extension.
Specifically the aim of the "Cryptographic Extensions Task Group"
is to "propose ISA extensions to the vector extensions for the 
standardized and secure execution of popular cryptographic algorithms."

Please note that this is a research project.
We intend to contribute our ideas back to the RISC-V community, and
are not expecting this to become a standard RISC-V extension it its
own right. 
There is nothing to stop people using it as a non-standard extension
however, and we consider XCrypto featureful enough to be used as such.
Hopefully, some of the ideas we have developed with XCrypto can be fed back
into the standard cryptographic extension effort.

## Project Organisation

Large RISC-V projects can sometimes be difficult to navigate, especially
where they are broken over multiple source code repositories.
Here, we will try and explain how we have organised the XCrypto project.

**Note:** *Historically, all XCrypto development was done in a single
repository (this one) which is why if you look back in time, you'll
see this repo used to have many more files in it.
When the project became too big to manage this way, we split it up to
mirror how the RISC-V Github organisation partitions things.
If you are familiar with their method of project organisation,
hopefully ours will look similar.*

- [scarv/xcrypto](https://github.com/scarv/xcrypto):
  This repository, the top level of the XCrypto project.
- [scarv/xcrypto-spec](https://github.com/scarv/xcrypto-spec):
  Contains the specification document for the ISE, explaining the
  new instructions, how they work, and how XCrypto integrates
  with RISC-V.
- [scarv/xcrypto-ref](https://github.com/scarv/xcrypto-ref):
  Our area-optimised hardware reference implementation of XCrypto.
- [scarv/riscv-tools](https://github.com/scarv/riscv-tools):
  Our fork of the riscv-tools repository, which we build on to
  develop XCrypto.
  - [scarv/riscv-opcodes](https://github.com/scarv/riscv-opcodes):
    Our fork of the riscv-opcodes repository, containing the
    instruction encodings for the XCrypto ISE.
  - [scarv/riscv-gnu-toolchain](https://github.com/scarv/riscv-gnu-toolchain):
    Our fork of the riscv-gnu-toolchain repository, used to support
    a toolchain with integrated XCrypto assembly support.
    So far, we have only implemented assembly code compilation, not
    generation from C code.
    - [scarv/riscv-binutils-gdb](https://github.com/scarv/riscv-binutils-gdb):
      Our fork of riscv-binutils-gdb, which adds (dis)assembly support to the
      standard RISC-V toolchain for XCrypto.
  - [scarv/riscv-isa-sim](https://github.com/scarv/riscv-isa-sim):
    Our fork of the Spike ISA simulator for RISC-V, for which we are adding
    XCrypto support.

Our forked version of the `riscv-tools` repository has updated submodule
pointers to only those submodules we have forked and modified.
Submodules we have not changed still point to their original `riscv-*`
repositories.

## Funding Sources

This work has been supported in part by EPSRC via grant 
[EP/R012288/1](https://gow.epsrc.ukri.org/NGBOViewGrant.aspx?GrantRef=EP/R012288/1),
under the [RISE](http://www.ukrise.org) programme.


