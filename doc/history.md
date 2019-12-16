
# XCrypto Project History

*The XCrypto project has lived an eventful life and undergone several
large re-organisations. This document captures those changes.*

---


- *Originally* this was a 
  [monorepo](https://en.wikipedia.org/wiki/Monorepo)
  that housed *all* resources in one place.

- For the `v0.15.0` release, it was re-rorganised as a container where each
  resource was housed in dedicated submodule.

- For the `v1.0.0` release, it was re-organised again.

  - Some submodules (`xcrypto-rtl`, `xcrypto-spec`) were merged back into
    the top level repository.

  - The `xcrypto-ref` submodule was dropped, as it was an implementation
    of the old `v0.15.0` version.
    This was replaced with references to the new `scarv-cpu` and
    `scarv-soc` repositories, which implement the new `v1.0.0` branch.
