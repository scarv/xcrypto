# Copyright (C) 2018 SCARV project <info@scarv.org>
#
# Use of this source code is restricted per the MIT license, a copy of which 
# can be found at https://opensource.org/licenses/MIT (or should be included 
# as LICENSE.txt within the associated archive or repository).

BRANCH      = $(shell git branch | grep '*' | cut --characters=3-)

DOCKER_REPO = scarv/xcrypto
DOCKER_TAG  = $(shell echo ${BRANCH} | cut --delimiter='/' --fields=3)

DATE        = $(shell date -u +'%d/%m/%Y-%H:%M:%SZ')

build :
	@docker build --tag ${DOCKER_REPO}:${DOCKER_TAG} --build-arg BRANCH="${BRANCH}" --build-arg DATE="${DATE}" .

clean :
	@docker images | grep ${DOCKER_REPO} | grep ${DOCKER_TAG} | tr --squeeze-repeats ' ' | cut --delimiter=' ' --fields=3 | uniq | xargs --no-run-if-empty docker rmi --force

push  :
	@docker push ${DOCKER_REPO}:${DOCKER_TAG}

pull  :
	@docker pull ${DOCKER_REPO}:${DOCKER_TAG}
