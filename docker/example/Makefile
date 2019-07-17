# Copyright (C) 2018 SCARV project <info@scarv.org>
#
# Use of this source code is restricted per the MIT license, a copy of which 
# can be found at https://opensource.org/licenses/MIT (or should be included 
# as LICENSE.txt within the associated archive or repository).

example.elf : example.c example.h
	@riscv32-unknown-elf-gcc -o ${@} $(filter %.c, ${?})

example.sim : example.elf
	@spike --isa=rv32imac ${RISCV}/riscv32-unknown-elf/bin/pk ${<} > ${@}


all      :          example.elf example.sim

clean    :
	@rm --force example.elf example.sim

%-docker :
	@docker run --rm --volume ${PWD}:/mnt/scarv/xcrypto --env DOCKER_GID="$(shell id --group)" --env DOCKER_UID="$(shell id --user)" scarv/xcrypto ${*}
