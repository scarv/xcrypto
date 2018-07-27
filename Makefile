
ifndef ROP_HOME
    $(error "Please run 'source ./bin/source.me.sh' to setup the project workspace")
endif

all: sim run


sim:
	$(MAKE) -C $(ROP_HOME)/flow/icarus

run:
	$(MAKE) -C $(ROP_HOME)/flow/icarus run
