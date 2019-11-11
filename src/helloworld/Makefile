# Copyright (C) 2018 SCARV project <info@scarv.org>
#
# Use of this source code is restricted per the MIT license, a copy of which 
# can be found at https://opensource.org/licenses/MIT (or should be included 
# as LICENSE.txt within the associated archive or repository).

# =============================================================================

export DOCKER_REPO  = scarv/xcrypto
export DOCKER_TAG   = 1.0.0
export DOCKER_FLAGS = --env RISCV_XCRYPTO="/opt/riscv-xcrypto"

# -----------------------------------------------------------------------------

helloworld.elf : helloworld.c helloworld.h
	@${RISCV_XCRYPTO}/bin/riscv32-unknown-elf-gcc -o ${@} $(filter %.c, ${?})

helloworld.sim :              helloworld.elf
	@${RISCV_XCRYPTO}/bin/spike --isa=rv32imac ${RISCV_XCRYPTO}/riscv32-unknown-elf/bin/pk ${<} > ${@}

%-docker :
	@docker run --rm --volume "${PWD}:/mnt/scarv/xcrypto" --env DOCKER_GID="$(shell id --group)" --env DOCKER_UID="$(shell id --user)" ${DOCKER_FLAGS} ${DOCKER_REPO}:${DOCKER_TAG} ${*}

all      :          helloworld.elf helloworld.sim

clean    :
	@rm --force helloworld.elf helloworld.sim

# =============================================================================
