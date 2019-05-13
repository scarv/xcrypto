# Copyright (C) 2018 SCARV project <info@scarv.org>
#
# Use of this source code is restricted per the MIT license, a copy of which 
# can be found at https://opensource.org/licenses/MIT (or should be included 
# as LICENSE.txt within the associated archive or repository).

FROM ubuntu

ARG DATE

LABEL maintainer="SCARV project <info@scarv.org>" date="${DATE}" url="https://github.com/scarv/xcrypto"

RUN apt-get --assume-yes --quiet update \
 && apt-get --assume-yes --quiet install apt-utils gosu sudo \
 && apt-get --assume-yes --quiet install make autoconf automake autotools-dev bc bison build-essential curl device-tree-compiler flex gawk gcc git gperf libexpat-dev libgmp-dev libmpc-dev libmpfr-dev libtool libusb-1.0-0-dev patchutils pkg-config texinfo zlib1g-dev

# The build seems to trigger an existing bug, see, e.g., [1], related
# to the maximum path length supported by the underlying file system: 
# we end up creating a path that cannot then be removed.  The fix is
# simple: we just relocate a sub-directory, shortening the path so it 
# *can* then be removed.
# 
# [1] https://github.com/moby/moby/issues/13451

ENV RISCV "/opt/riscv-xcrypto-0.13.0"

RUN git clone https://github.com/scarv/riscv-tools.git \
 && cd ./riscv-tools \
 && git submodule update --init --recursive \
 && ./build-rv32imaxc.sh \
 && mv ./riscv-gnu-toolchain/build/build-gdb-newlib/gdb/build-gnulib/confdir3/confdir3 ./bugfix && rm --force --recursive ./bugfix \
 && cd .. \
 && rm --force --recursive ./riscv-tools
ENV PATH "${RISCV}/bin:${PATH}"

COPY ./entrypoint.sh /usr/sbin/entrypoint.sh
RUN chmod 755 /usr/sbin/entrypoint.sh

ENTRYPOINT [ "/usr/sbin/entrypoint.sh" ]
