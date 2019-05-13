# Copyright (C) 2018 SCARV project <info@scarv.org>
#
# Use of this source code is restricted per the MIT license, a copy of which 
# can be found at https://opensource.org/licenses/MIT (or should be included 
# as LICENSE.txt within the associated archive or repository).

DOCKER_IMAGE = scarv/xcrypto
DOCKER_TAGS  = latest 0.13.0

build :
	@docker build $(foreach TAG,${DOCKER_TAGS},--tag ${DOCKER_IMAGE}:${TAG}) --build-arg DATE=$(shell date -u +'%d/%m/%Y-%H:%M:%SZ') --file ./Dockerfile .
clean :
	@docker images | grep ${DOCKER_IMAGE} | tr -s ' ' | cut -d' ' -f3 | uniq | xargs --no-run-if-empty docker rmi --force
push  :
	@docker push ${DOCKER_IMAGE}
pull  :
	@docker pull ${DOCKER_IMAGE}
