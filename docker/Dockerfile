# Copyright (C) 2018 SCARV project <info@scarv.org>
#
# Use of this source code is restricted per the MIT license, a copy of which 
# can be found at https://opensource.org/licenses/MIT (or should be included 
# as LICENSE.txt within the associated archive or repository).

FROM ubuntu

ARG DATE

LABEL maintainer="SCARV project <info@scarv.org>" date="${DATE}" url="https://github.com/scarv/xcrypto"

RUN apt-get --assume-yes --quiet update \
 && apt-get --assume-yes --quiet install gosu make git gcc autoconf automake autotools-dev curl libmpc-dev libmpfr-dev libgmp-dev libusb-1.0-0-dev gawk build-essential bison flex texinfo gperf libtool patchutils bc zlib1g-dev device-tree-compiler pkg-config libexpat-dev

# https://bugzilla.yoctoproject.org/show_bug.cgi?id=7338

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
