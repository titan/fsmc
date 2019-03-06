NAME=fsmc

include .config
ESCAPED_BUILDDIR = $(shell echo '${BUILDDIR}' | sed 's%/%\\/%g')
TARGET=fsmc.py model.py jsonio.py python.py utility.py excel.py semantic.py analyzer.py
FSM=parameter_fsm.py

vpath %.org .
vpath %.py $(BUILDDIR)
vpath %.json $(BUILDDIR)

all: $(TARGET) $(FSM)
	chmod 755 $(BUILDDIR)/fsmc.py

$(TARGET): %.py: %.org
	sed 's/$$$\{BUILDDIR}/$(ESCAPED_BUILDDIR)/g' $< | org-tangle -

$(BUILDDIR)/parameter_fsm.py: $(BUILDDIR)/parameter-fsm.json
	fsmc.py $< -t python

$(BUILDDIR)/parameter-fsm.json: semantic.org
	sed 's/$$$\{BUILDDIR}/$(ESCAPED_BUILDDIR)/g' $< | org-tangle -

clean:
	rm -rf $(BUILDDIR)

.PHONY: all clean
