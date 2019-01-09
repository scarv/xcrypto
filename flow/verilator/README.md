
# Verilator Flow

This file describes how to build and use the verilator flow in order
to run simulations of RISC-V/XCrypro programs on models of the actual
reference implementation, coupled with a PicoRV32 CPU.

## Installing Verilator

Verilator must be installed *from source* in order to be used properly.
This is due to known issues with how the verilator apt packages handle
the C++ headers needed to build verilated models.

```sh
$> git clone http://git.veripool.org/git/verilator
$> cd verilator
$> export VERILATOR_ROOT=`pwd`   # if your shell is bash
$> autoconf
$> ./configure
$> make
```

One need not install verilator across the system, it can be used wherever
it was built, so long as the `$VERILATOR_ROOT` environment variable is
set appropriately.

## Building the model

From the top of the repository (`$XC_HOME`), run the following commands:

```sh
$> make verilator_build
```

This will create a simulation binary called `scarv_prv_xcrypt_top`
in `$XC_HOME/work/verilator/`.

## Running the model

Get help about using the simulation binary thusly:

```sh
$> $XC_HOME/work/verilator/scarv_prv_xcrypt_top --help
../../work/verilator/scarv_prv_xcrypt_top [arguments]
    +q                            - Be quiet
	+IMEM=<srec input file path>  -
	+STDOUT=<uart dump file path> -
	+WAVES=<VCD dump file path>   -
	+TIMEOUT=<timeout after N>    -
	+PASS_ADDR=<hex number>       -
	+FAIL_ADDR=<hex number>       -
```

Where:

- `+q` causes the simulator to print nothing except for what the host
    program itself prints. Must be specified *first*.
- `+IMEM=` is the path to the srec file which describes the initial
    memory content of the simulation.
- `+STDOUT=` is the path to a file where all data written to the emulated
    UART output port is dumped.
- `+WAVES=` Is a file path where a complete waveform trace of the
    simulation will be dumped. If this argument is omitted, no waves will
    be dumped and the simulation will be noticably faster!
- `+TIMEOUT=` Is how many CPU cycles to run the simulation for before
    exiting automatically.
- `+PASS_ADDR=` and `+FAIL_ADDR=` are tripwire addresses used to indicate
    successful or erroneous completion of the program being simulated.

All arguments *must* start with a `+` and have no spaces between the argument
name, the `=` and the argument value. Hence, `+ARG = VALUE` is invalid, but
`+ARG=VALUE` is valid.

## Building SREC files.

The simulation binary uses SREC files as input. These are simple files
which describe memory contents. If you already have a `.elf` file, then
an SREC file ingestible by the simulator can be created using the following
command:

```sh
objcopy -O srec --srec-forceS3 <input file> <output file>
```

Note that you should use the objcopy associated with the modified binutils
toolset in the Xcrypto repository. Assuming you have already built the
patched binutils tools, this should be found in
`$XC_HOME/work/riscv-binutils-gdb/build/binutils/objcopy`.

## Simulator output

From inside the simulation, one can access a basic emulated UART TX port
which will print to STDOUT.

Any *byte* writen to the memory address `0xFFFFFFFF` will be interpreted as
an ASCII character and written to STDOUT.

See `$XC_HOME/examples/common/boot.S` and `$XC_HOME/examples/common/common.h`
for how this is implemented.
