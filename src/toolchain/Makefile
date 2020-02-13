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

COMPONENTS = binutils gcc newlib pk spike

define rule_build
$(strip ${1})-build  :
	@$${REPO_HOME}/src/toolchain/$(strip ${1})-apply.sh
	@$${REPO_HOME}/src/toolchain/$(strip ${1})-conf.sh
	@$${REPO_HOME}/src/toolchain/$(strip ${1})-build.sh
endef
define rule_update
$(strip ${1})-update :
	@$${REPO_HOME}/src/toolchain/$(strip ${1})-update.sh
endef
define rule_revert
$(strip ${1})-revert :
	@$${REPO_HOME}/src/toolchain/$(strip ${1})-revert.sh
endef

$(foreach COMPONENT,${COMPONENTS},$(eval $(call rule_build, ${COMPONENT})))
$(foreach COMPONENT,${COMPONENTS},$(eval $(call rule_update,${COMPONENT})))
$(foreach COMPONENT,${COMPONENTS},$(eval $(call rule_revert,${COMPONENT})))

clone  : 
	@${REPO_HOME}/src/toolchain/clone.sh

build  : $(foreach COMPONENT, ${COMPONENTS}, ${COMPONENT}-build )

update : $(foreach COMPONENT, ${COMPONENTS}, ${COMPONENT}-update)

revert : $(foreach COMPONENT, ${COMPONENTS}, ${COMPONENT}-revert)

clean  :
	@rm --force --recursive ${REPO_HOME}/build/toolchain

# =============================================================================
