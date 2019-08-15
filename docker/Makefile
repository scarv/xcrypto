# Copyright (C) 2018 SCARV project <info@scarv.org>
#
# Use of this source code is restricted per the MIT license, a copy of which 
# can be found at https://opensource.org/licenses/MIT (or should be included 
# as LICENSE.txt within the associated archive or repository).

IMAGE_REPO = $(shell git branch | grep '*' | cut --characters=3- | cut --delimiter='/' --fields=1,2)
IMAGE_TAG  = $(shell git branch | grep '*' | cut --characters=3- | cut --delimiter='/' --fields=3  )

define date
  $(shell date -u +'%d/%m/%Y-%H:%M:%SZ')
endef

build :
	@docker build --tag ${IMAGE_REPO}:${IMAGE_TAG} --build-arg DATE="$(call date)" --build-arg BRANCH="${IMAGE_REPO}/${IMAGE_TAG}" .

clean : 
	@docker images | grep ${IMAGE_REPO} | grep ${IMAGE_TAG} | tr --squeeze-repeats ' ' | cut --delimiter=' ' --fields=3 | uniq | xargs --no-run-if-empty docker rmi --force

push  :
	@docker push ${IMAGE_REPO}:${IMAGE_TAG}

pull  :
	@docker pull ${IMAGE_REPO}:${IMAGE_TAG}
