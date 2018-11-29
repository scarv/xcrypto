
# Benchmarking flow

This document describes the stages of the benchmarking flow.

## Overview

There are several stages to properly running the benchmarking flow.

1. Building `libscarv` and the example programs for the appropriate target
   architecture.
2. Building the verilated model of the PicoRV32+XCrypto subsystem
3. Running the example programs on the verilated model.

The aim of the benchmark flow is to quantify the speedup / efficiency
gains from accelerating functions with the XCrypto ISE.

The basic method is to run the same set of programs compiled against two
versions of `libscarv`. One with XCrypto acceleration enabled, and one
without.

## 1) Building libscarv and the examples

We can `libscarv`  and the example programs against the basic RISC-V
architecture using:

```sh
$> make -B libscarv examples LIBSCARV_ARCH=riscv
```

Or against the RISC-V+XCrypto architecture using:

```sh
$> make -B libscarv examples LIBSCARV_ARCH=riscv-xcrypto.
```

One can clean the libscarv target with:

```sh
$> make -B libscarv-clean
```


## 2) Building the verilated model

This is done using the `verilator_build` target:

```sh
$> make verilator_build
```

## 3) Running example programs

The next step is heavily automated by the `benchmarks` makefile target:

```sh
$> make -B benchmarks LIBSCARV_ARCH=<riscv/riscv-xcrypto>
```

This will run all of the benchmarks, collect their output, and post process
it into CSV files under `$XC_HOME/work/benchmarks/`. These CSV files can
later be used for whatever custom analysis one cares to do.

The set of underlying steps are performed by the `Makefile` in
`$XC_HOME/flow/benchmarks`

Each benchmark program *prints* to the virtual `stdout` the set of
performance data it wishes to record into a python list called `performance`.

**Note:** what is printed to the virtual `stdout` of the simulator
is valid Python2 code.

The simulator output is piped to a file called
`$XC_HOME/work/benchmarks/<name>-<LIBSCARV_ARCH>.py` and can then be
imported by other scripts for further analysis.

In this case, we concatenate the output of the simulator and a simple
analysis script (`$XC_HOME/flow/benchmarks/mpn_plot_perf.py` in this
example) which creates CSV files of the performance data.

## Gottchas

- Make sure you consistently pass `LIBSCARV_ARCH` to the makefile targets.
  By default it is set to `riscv-xcrypto`, so failure to be consistent
  here will corrupt your results.
- Output artifacts written by the analysis python scripts are named for the
  value of `LIBSCARV_ARCH`. If you aren't consistent, the data will be
  misslabeled.

## Examples:

Run the entire benchmark flow for the `riscv-xcrypto` architecture:

```sh
$> make verilator_build
$> make -B libscarv examples benchmarks LIBSCARV_ARCH=riscv-xcrypto
```

