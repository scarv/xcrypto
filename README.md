# XCrypto: a cryptographic ISE for RISC-V

<!--- -------------------------------------------------------------------- --->

[![Build Status](https://travis-ci.com/scarv/xcrypto.svg)](https://travis-ci.com/scarv/xcrypto)
[![Documentation](https://codedocs.xyz/scarv/xcrypto.svg)](https://codedocs.xyz/scarv/xcrypto)

<!--- -------------------------------------------------------------------- --->

*Acting as a component part of the wider
[SCARV](https://www.scarv.org)
project,
XCrypto is a general-purpose Instruction Set Extension (ISE) for
[RISC-V](https://riscv.org)
that supports software-based cryptographic workloads.*

<!--- -------------------------------------------------------------------- --->

## Overview

A given cryptographic workload is commonly expected to satisfy a 
challenging and diverse range of traditional design metrics, 
including some combination of high-throughput, low-latency, low-footprint, power-efficiency, and high-assurance,
while executing in what is potentially an adversarial environment.
A large design space of options can be drawn from when developing
a concrete implementation: these options span a spectrum, between 
those entirely based on hardware (e.g., a dedicated IP core)
and
those entirely based on software.
ISEs can be viewed as representing a hybrid option, in the sense 
they alter a general-purpose processor core with special-purpose 
hardware and associated instructions; such targeted alterations 
then help to improve a software-based implementation wrt. some
design metric (e.g., latency).

As an ISE, we pitch XCrypto as *a* solution (vs. *the* solution) 
within the wider design space of options.  For example, it offers
as an *alternative* to the solution being proposed by the RISC-V 
cryptography extensions group (see, e.g., their
[presentation](https://www.youtube.com/watch?v=dcW6a7SO2zE):
the design extends the RISC-V vector ISE).
The idea is to leverage extensive existing literature and hence
experience wrt. cryptographic ISEs (see, e.g., published work at
the
[CHES](https://dblp.uni-trier.de/db/conf/ches)
conference), translating and applying it to RISC-V.
Although potentially less performant than alternatives, we expect
implementations using XCrypto to be more lightweight and flexible; 
as a result, we view it as representing an attractive solution in
the context of micro-controller class cores.

<!--- -------------------------------------------------------------------- --->

## Organisation

```
├── bin                    - scripts (e.g., environment configuration)
├── build                  - working directory for build
├── doc                    - documentation
├── extern                 - external resources (e.g., submodules)
│   ├── libscarv             - submodule: scarv/libscarv
│   ├── riscv-opcodes        - submodule: scarv/riscv-opcodes
│   ├── texmf                - submodule: scarv/texmf
│   └── wiki                 - submodule: scarv/xcrypto.wiki
├── pdf                    - PDFs, e.g., presentation slides
├── rtl                    - source code for re-usable hardware modules
└── src
    ├── docker             - source code for containers
    ├── helloworld         - source code for example program
    ├── test               - source code for test    program(s)
    └── toolchain          - source code for tool-chain
```

Note that:

- [`${REPO_HOME}/doc`](./doc) 
  houses
  the XCrypto specification:
  this document captures the ISE itself, acting as both
  a) a definition of additional architectural 
     state
     (e.g., register file and CSRs)
     and
     instructions
     (i.e., their semantics and encoding),
     and
  b) a design document.
  Pre-built versions accompany each 
  [releases](https://github.com/scarv/xcrypto/releases)
  of XCrypto.

- [`${REPO_HOME}/rtl`](./rtl) 
  houses
  a library of re-usable hardware components (e.g., for arithmetic
  operations), which could be used in an implementation of XCrypto.

<!--- -------------------------------------------------------------------- --->

## Quickstart (with more detail in the [wiki](https://github.com/scarv/xcrypto/wiki))

1. Execute

   ```sh
   git clone https://github.com/scarv/xcrypto.git ./xcrypto
   cd ./xcrypto
   git submodule update --init --recursive
   source ./bin/conf.sh
   ```

   to clone and initialise the repository,
   then configure the environment;
   for example, you should find that the
   `REPO_HOME`
   environment variable is set appropriately.

2. Use targets in the top-level `Makefile` to drive a set of
   common tasks, e.g.,

   | Command                   | Description                                                                          |
   | :------------------------ | :----------------------------------------------------------------------------------- |
   | `make    build-doc`       | build the [LaTeX](https://www.latex-project.org)-based documentation                 |
   | `make    clone-toolchain` | clone the [tool-chain](https://github.com/scarv/xcrypto/wiki/Toolchain)              |
   | `make    build-toolchain` | build the [tool-chain](https://github.com/scarv/xcrypto/wiki/Toolchain)              |
   | `make doxygen`            | build the       [Doxygen](http://www.doxygen.nl)-based documentation                 |
   | `make spotless`           | remove *everything* built in `${REPO_HOME}/build`                                    |

<!--- -------------------------------------------------------------------- --->

## Questions?

- use the
  [groups.io](https://groups.io)-based [discussion group](https://scarv.groups.io/g/xcrypto),
- raise an
  [issue](https://github.com/scarv/xcrypto/issues),
- raise a
  [pull request](https://github.com/scarv/xcrypto/pulls),
- drop us an 
  [email](mailto:info@scarv.org?subject=xcrypto).

<!--- -------------------------------------------------------------------- --->

## Publications and presentations

- Some
  [slides](./pdf/riscv-meetup-bristol-slides.pdf)
  presented at the
  [RISC-V meetup](https://www.meetup.com/Bristol-RISC-V-Meetup-Group)
  in Bristol, April 2019.
- A
  [poster](./pdf/zurich-workshop-poster.pdf)
  presented at the
  [RISC-V Workshop](https://riscv.org/2019/06/risc-v-workshop-zurich-proceedings)
  in  Zurich,  June 2019.

<!--- -------------------------------------------------------------------- --->

## Acknowledgements

This work has been supported in part
by EPSRC via grant
[EP/R012288/1](https://gow.epsrc.ukri.org/NGBOViewGrant.aspx?GrantRef=EP/R012288/1) (under the [RISE](http://www.ukrise.org) programme).

<!--- -------------------------------------------------------------------- --->
