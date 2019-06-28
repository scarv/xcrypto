# XCrypto: a cryptographic ISE for RISC-V

<!--- -------------------------------------------------------------------- --->

*Acting as a component part of the 
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

### Presentations:

- XCrypto was presented at the April 2019 
  [Bristol RISC-V meetup](https://www.meetup.com/Bristol-RISC-V-Meetup-Group/).
  You can see the slides [here](./doc/riscv-meetup-bristol-slides.pdf).
- Our 
  [poster presentation](doc/zurich-workshop-poster.pdf)
  featured in the June 2019 
  [RISC-V Workshop](https://tmt.knect365.com/risc-v-workshop-zurich/)
  in Zurich.

<!--- -------------------------------------------------------------------- --->

## Organisation

Originally this repository housed *all* resources in one place,
but to make them easier to manage, it *now* acts as a container: 
the resources are housed in dedicated submodules.  Specifically, 
these include

- [`scarv/xcrypto-spec`](https://github.com/scarv/xcrypto-spec)
  houses the
  XCrypto specification:
  this document captures the ISE itself, acting as both
  a) a design document,
     and
  b) a definition of additional architectural 
     state
     (e.g., register file and CSRs)
     and
     instructions
     (i.e., their semantics and encoding).
- [`scarv/xcrypto-ref`](https://github.com/scarv/xcrypto-ref)
  houses the
  a formally verified, area-optimised reference implementation:
  as well as supporting validation of the ISE, it can be coupled
  to a RISC-V core such as
  [`cliffordwolf/picorv32`](https://github.com/cliffordwolf/picorv32)
  to form a functioning, useful instantiation.
- [`scarv/xcrypto-rtl`](https://github.com/scarv/xcrypto-rtl)
  contains re-usable hardware implementations of XCrypto instructions.
- [`scarv/libscarv`](https://github.com/scarv/libscarv)
  is a library of cryptographic reference implementations, which
  includes support for XCrypto.

Various other resources support or relate to XCrypto, but are not
submodules per se.
Specifically, these include

- [`scarv/riscv-tools`](https://github.com/scarv/riscv-tools)
  is a fork of
  [`riscv/riscv-tools`](https://github.com/riscv/riscv-tools),
  including a GCC-based toolchain and ISA simulator; support for
  XCrypto is added to various components, including

  - [`scarv/riscv-opcodes`](https://github.com/scarv/riscv-opcodes)
    (e.g., to capture the XCrypto instruction encodings),
  - [`scarv/riscv-gnu-toolchain`](https://github.com/scarv/riscv-gnu-toolchain)
    (e.g., to support    assembly of XCrypto instructions),
  - [`scarv/riscv-binutils-gdb`](https://github.com/scarv/riscv-binutils-gdb)
    (e.g., to support disassembly of XCrypto instructions),
  - [`scarv/riscv-isa-sim`](https://github.com/scarv/riscv-isa-sim)
    (e.g., to support  simulation of XCrypto instructions).

  Note that our fork updates submodules so they refer to
  `scarv/riscv-X`
  where XCrypto-specific changes are made to `X`, or to
  `riscv/riscv-X`
  otherwise.

<!--- -------------------------------------------------------------------- --->

## Quickstart

- The releases page of each submodule, i.e.,

  - [`scarv/xcrypto-spec`](https://github.com/scarv/xcrypto-spec/releases)
  - [`scarv/xcrypto-ref`](https://github.com/scarv/xcrypto-ref/releases)

  houses pre-built content: acting as a detailed explanation and
  specification of XCrypto, the former is an ideal starting point.

- [`${REPO_HOME}/docker`](./docker)
  contains material related to a
  [Docker](https://www.docker.com/)-based,
  XCrypto
  [container](https://cloud.docker.com/u/scarv/repository/docker/scarv/xcrypto).
  It supports containerised use of `make`, within an environment 
  where the XCrypto toolchain 
  (e.g., XCrypto-enabled `riscv32-unknown-elf-gcc` and `spike`)
  are pre-installed; doing so offers a way to quickly experiment 
  with XCrypto in simulation *without* installing the toolchain,
  but clearly may not be suitable for use-cases beyond that.

  - An example of this approach is supplied in 
    [`${REPO_HOME}/docker/example`](./docker/example),
    which relates to a simple
    ["hello world"](https://en.wikipedia.org/wiki/"Hello,_World!"_program)
    program; the associated build system is in
    [`${REPO_HOME}/docker/example/Makefile`](./docker/example/Makefile).

  - The idea is that for any target `X` in the `Makefile`, one
    can also use `docker-X`.  For example, executing

    ```
    make all-docker
    ```

    will

    - mount the current working directory, i.e.,
      `${REPO_HOME}/docker/example`
      as 
      `/mnt/scarv/xcrypto` 
      within the container,
      then
    - execute `make all` in 
      `/mnt/scarv/xcrypto` 
      within the container,
      as a user whose UID and GID match `${USER}`,

    and, as such, do the same as executing

    ```
    make all
    ```

    except using the containerised toolchain.

<!--- -------------------------------------------------------------------- --->

## Acknowledgements

This work has been supported in part by EPSRC via grant 
[EP/R012288/1](https://gow.epsrc.ukri.org/NGBOViewGrant.aspx?GrantRef=EP/R012288/1),
under the [RISE](http://www.ukrise.org) programme.

<!--- -------------------------------------------------------------------- --->
