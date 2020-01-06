# XCrypto: a cryptographic ISE for RISC-V

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

### Roadmap

XCrypto is a *non-standard* RISC-V extension.  Over time, it has
evolved along various branches
(each identified by an associated major version):

- The (now abandoned)
  `0.x.y` branch
  represents an initial prototype.
  It can be characterised as deliberately disjoint from the RISC-V 
  base ISA(s), and so, in concept, aligned with implementation as a 
  separate co-processor.

- The (current)
  `1.x.y` branch
  represents a refinement of `0.x.y`.
  It can be characterised as taking the functionality from `0.x.y`, 
  but integrating inline with vs. alongside the RISC-V base ISA(s), 
  i.e., in the form of a conventional ISA vs. a co-processor.

The long-term goal is to develop the `1.x.y` branch, ultimately
using it as a basis for a *standard* (i.e., "official") RISC-V 
extension proposal.

### Publications and presentations

- Some
  [slides](./media/riscv-meetup-bristol-slides.pdf)
  presented at the
  [RISC-V meetup](https://www.meetup.com/Bristol-RISC-V-Meetup-Group)
  in Bristol, April 2019.
- A
  [poster](./media/zurich-workshop-poster.pdf)
  presented at the
  [RISC-V Workshop](https://riscv.org/2019/06/risc-v-workshop-zurich-proceedings)
  in  Zurich,  June 2019.

<!--- -------------------------------------------------------------------- --->

## Organisation

**Note:** Some history of the XCrypto project and it's organisation
can be found in [doc/history.md](doc/history.md).

The main components of the XCrypto project are:

- The XCrypto specification:
  this document captures the ISE itself, acting as both
  a) a design document,
     and
  b) a definition of additional architectural 
     state
     (e.g., register file and CSRs)
     and
     instructions
     (i.e., their semantics and encoding).

  - The sources for the document are contained in the `doc/` directory
    as LaTeX.
    Running `make docs` from the root of the repository will place
    the compiled PDF file in `build/spec/spec.pdf`.

  - Alternatively, pre-built versions accompany each release of
    XCrypto, found on the
    [releases page](https://github.com/scarv/xcrypto/releases).

- The [`rtl`](./rtl) directory
  contains re-usable hardware implementations of XCrypto instructions.
  The [README](./rtl/README.md) describes this in more detail.

- [`scarv/scarv-cpu`](https://github.com/scarv/scarv-cpu)
  is a micro-controller style implementation of the RISC-V instruction
  set with the XCrypto extensions.

- [`scarv/scarv-soc`](https://github.com/scarv/scarv-soc)
  is an example SoC integration of the `scarv-cpu`, optimised for
  evaluation on an FPGA.

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

- See
  [`tools/README.md`](tools/README.md)
  for how to build your own version of the XCrypto modified toolchain and ISA
  simulator.

- The specification document for XCrypto is writen in LaTeX, and stored
  under the [doc](./doc) folder.

  - The PDF document can be built by running
    ```
    $> make doc
    ```
    from the root of the repository.
    This will place the built document in `build/spec/spec.pdf`

- [`${REPO_HOME}/src/docker`](./src/docker)
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
    [`${REPO_HOME}/src/helloworld`](./src/helloworld),
    which relates to a simple
    ["hello world"](https://en.wikipedia.org/wiki/"Hello,_World!"_program)
    program; the associated build system is in
    [`${REPO_HOME}/src/helloworld/Makefile`](./src/helloworld/Makefile).

  - The idea is that for any target `X` in the `Makefile`, one
    can also use `X-docker`.  For example, executing

    ```
    make all-docker
    ```

    will

    - mount the current working directory, i.e.,
      `${REPO_HOME}/src/helloworld`
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
