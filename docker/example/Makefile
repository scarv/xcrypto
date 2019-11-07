# Copyright (C) 2018 SCARV project <info@scarv.org>
#
# Use of this source code is restricted per the MIT license, a copy of which 
# can be found at https://opensource.org/licenses/MIT (or should be included 
# as LICENSE.txt within the associated archive or repository).

IMAGE_REPO = $(shell git branch | grep '*' | cut --characters=3- | cut --delimiter='/' --fields=1,2)
IMAGE_TAG  = $(shell git branch | grep '*' | cut --characters=3- | cut --delimiter='/' --fields=3  )

example.elf : example.c example.h
	@${RISCV_XCRYPTO}/bin/riscv32-unknown-elf-gcc -o ${@} $(filter %.c, ${?})

example.sim : example.elf
	@${RISCV_XCRYPTO}/bin/spike --isa=rv32imac ${RISCV_XCRYPTO}/riscv32-unknown-elf/bin/pk ${<} > ${@}

all      :          example.elf example.sim

clean    :
	@rm --force example.elf example.sim

%-docker :
	@docker run --rm --volume ${PWD}:/mnt/scarv/xcrypto --env DOCKER_GID="$(shell id --group)" --env DOCKER_UID="$(shell id --user)" --env RISCV_XCRYPTO="/opt/riscv-xcrypto" ${IMAGE_REPO}:${IMAGE_TAG} ${*}
