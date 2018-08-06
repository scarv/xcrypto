
ifndef COP_HOME
    $(error "Please run 'source ./bin/source.me.sh' to setup the project workspace")
endif


.PHONY: docs
docs:
	$(MAKE) -C $(COP_HOME)/docs all
