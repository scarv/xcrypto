# Copyright (C) 2018 SCARV project <info@scarv.org>
#
# Use of this source code is restricted per the MIT license, a copy of which 
# can be found at https://opensource.org/licenses/MIT (or should be included 
# as LICENSE.txt within the associated archive or repository).

ifndef REPO_HOME
  $(error "execute 'source ./bin/conf.sh' to configure environment")
endif
ifndef REPO_VERSION
  $(error "execute 'source ./bin/conf.sh' to configure environment")
endif

# =============================================================================

export DOCKER_REPO  = scarv/xcrypto
export DOCKER_TAG   = ${REPO_VERSION}
export DOCKER_FLAGS = --env RISCV_XCRYPTO="/opt/riscv-xcrypto"

# -----------------------------------------------------------------------------

build : ${BUILD_PATHS} ${BUILD_FILES}
	@docker build --tag ${DOCKER_REPO}:${DOCKER_TAG} --build-arg DATE="$(shell date -u +'%d/%m/%Y-%H:%M:%SZ')" .

clean : ${CLEAN_PATHS}
	@docker images | grep ${DOCKER_REPO} | grep ${DOCKER_TAG} | tr --squeeze-repeats ' ' | cut --delimiter=' ' --fields=3 | uniq | xargs --no-run-if-empty docker rmi --force

push  :
	@docker push ${DOCKER_REPO}:${DOCKER_TAG}

pull  :
	@docker pull ${DOCKER_REPO}:${DOCKER_TAG}

# =============================================================================
