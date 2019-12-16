
# [XCrypto](https://github.com/scarv/xcrypto): Hardware Library

*A component part of the
[SCARV](https://github.com/scarv)
project.
This is a library of re-usable hardware components, useful for
implementing the XCrypto ISE.*

---

**Note:** Originally the contents of this directory was a separate
git repository under
[scarv/xcrypto-rtl](https://github.com/scarv/xcrypto-rtl).
That repository is now archived, and this directory should be considered
as the main source going forward.

This directory houses a collection of re-usable hardware modules, which
implement core functionality of the
[XCrypto](https://github.com/scarv/xcrypto) ISE.
These implementations are a work in progress.
Over time, this repository will become the starting point for future
implementations of XCrypto.

## Quickstart

- Clone the repository using:
    ```
    $> git clone https://github.com/scarv/xcrypto.git
    $> cd xcrypto
    ```
- Setup the project environment:
    ```
    $> source bin/conf.sh
    -------------------------[Setting Up Project]--------------------------
    REPO_HOME      = <...>/xcrypto/xcrypto
    REPO_BUILD     = <...>/xcrypto/xcrypto/build
    REPO_VERSION   = 1.0.0
    YOSYS_ROOT     = 
    ------------------------------[Finished]------------------------------- 
    ```

- Move to the `rtl/` folder:
    ```sh
    $> cd $REPO_HOME/rtl
    ```

- Synthesise all of the RTL modules:
    ```
    $> make synth-all
    ```
  The results will appear in `build/<module name>/`


- Run BMC proofs of correctness on the modules:
    ```
    $> make bmc-all
    ```

- Run all checks and synthesis jobs for a particular module:
    ```
    $> make <module name>
    ```

- Run all everything on everything:
    ```
    $> make all
    ```

## Modules implemented

This is a list of the modules in the repository and a rough
estimate of their gate count, as per an example Yosys CMOS flow.

Module Name | Yosys CMOS Gate Count | Instructions Implemented
------------|-----------------------|-------------------------------
`b_bop`     | 737                   | `xc.bop`
`b_lut`     | 1280                  | `xc.lut`
`p_addsub`  | 603                   | `xc.padd`,`xc.psub`
`p_shfrot`  | 1244                  | `xc.psrl[.i]`,`xc.psll[.i]`,`xc.prot[.i]`
`p_mul`     | 2614 (See note 1)     | `xc.pmul.[l,h]`,`xc.clmul.[l,h]`
`xc_sha3`   | 296                   | `xc.sha3.[xy,x1,x2,x4,yx]`
`xc_sha256` | 931                   | `xc.sha256.s[0,1,2,3]`
`xc_sha512` | 2018                  | `xc.sha512.s[0,1,2,3]`
`xc_aessub` | 4210 (single cycle)   | `xc.aessub.[enc,dec][rot]`
`xc_aesmix` | 2097 (single cycle)   | `xc.aesmix.[enc,dec]`
`xc_aessub` | 1354 (4-cycle     )   | `xc.aessub.[enc,dec][rot]`
`xc_aesmix` | 1591 (4-cycle     )   | `xc.aesmix.[enc,dec]`
`xc_malu`   | 7103 (see note 2)     | See note 3.


1. 554 gates contributed by subinstance of `p_addsub`. Multi-cycle
   implementation.
  `xc.macc`, `xc.mmul.3`

2. Multi-cycle implementation optimised for minimal area.

3. `xc.pmul.[l,h]`, `xc.pclmul.[l,h]`,
   `clmul[h]`,
   `mul`, `mulh`, `mulhu`, `mulhsu`,
   `div`, `divu`,
   `xc.madd.3`, `xc.msub.3`
 

---

## Acknowledgements

This work has been supported in part by EPSRC via grant 
[EP/R012288/1](https://gow.epsrc.ukri.org/NGBOViewGrant.aspx?GrantRef=EP/R012288/1),
under the [RISE](http://www.ukrise.org) programme.

