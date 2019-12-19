
# XCrypto Tools

*Instructions and notes on building an XCrypto enabled toolchain and
ISA simulator.*

---

1. Checkout the relevant repositories:
    ```sh
    $> $REPO_HOME/tools/clone-repos.sh
    ```
    This will clone GCC, Binutils, Newlib, the RISC-V Proxy kernel (PK)
    and the RISC-V ISA Simulator (Spike).

    It will then checkout known good commits on a new branch
    called `scarv/xcrypto/v$REPO_VERSION`, where `$REPO_VERSION` is set
    by the XCrypto environment setup script in `bin/conf.sh`.

2. Build the repositories:
    ```sh
    $> $REPO_HOME/tools/build-all.sh
    ```
    This will build `binutils`, `gcc`, `newlib`, `pk` and `spike`,
    and place the compiled results in `$REPO_HOME/build/toolchain/install`.

   - Individual repositories can be re-built using the following
     commands:
     ```sh
     $> $REPO_HOME/tools/build-binutils.sh
     $> $REPO_HOME/tools/build-gcc.sh
     $> $REPO_HOME/tools/build-newlib.sh
     $> $REPO_HOME/tools/build-pk.sh
     $> $REPO_HOME/tools/build-spike.sh
     ```

