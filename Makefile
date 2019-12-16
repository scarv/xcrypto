ifndef REPO_HOME
  $(error "execute 'source ./bin/conf.sh' to configure environment")
endif

.PHONY: doc

doc       :
	@${MAKE} -C ${REPO_HOME}/doc all

doc-clean : 
	@${MAKE} -C ${REPO_HOME}/doc clean

all      : doc

clean    : doc-clean

spotless :
	@rm -rf ${REPO_HOME}/build/*
