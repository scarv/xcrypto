
ifndef COP_HOME
    $(error "Please run 'source ./bin/source.me.sh' to setup the project workspace")
endif


.PHONY: docs
docs:
	$(MAKE) -C $(COP_HOME)/docs all

.PHONY: examples
examples:
	$(MAKE) -C $(COP_HOME)/examples all

.PHONY: clean
clean:
	$(MAKE) -C $(COP_HOME)/docs     clean
	$(MAKE) -C $(COP_HOME)/examples clean

binutils-gen: $(COP_WORK)/binutils-gen.h
$(COP_WORK)/binutils-gen.h: ./bin/ise-parse-opcodes.py ./docs/ise-opcodes.txt
	cat ./docs/ise-opcodes.txt | ./bin/ise-parse-opcodes.py -c > $@
