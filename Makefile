NAME=fsmc

include .config
ESCAPED_BUILDDIR = $(shell echo '${BUILDDIR}' | sed 's%/%\\/%g')
TARGET=fsmc.py model.py jsonio.py python.py utility.py excel.py semantic.py analyzer.py lexer.py
FSM=parameter_fsm.py action_fsm.py guard_fsm.py lexer_fsm.py

vpath %.org .
vpath %.py $(BUILDDIR)
vpath %.json $(BUILDDIR)
vpath %.xlsx $(BUILDDIR)

all: $(TARGET) $(FSM)
	chmod 755 $(BUILDDIR)/fsmc.py

$(TARGET): %.py: %.org
	sed 's/$$$\{BUILDDIR}/$(ESCAPED_BUILDDIR)/g' $< | org-tangle -

$(BUILDDIR)/parameter_fsm.py: $(BUILDDIR)/parameter-fsm.xlsx
	fsmc.py $< -t python

$(BUILDDIR)/parameter-fsm.xlsx: $(BUILDDIR)/parameter-fsm.json
	fsmc.py $< -t excel

$(BUILDDIR)/parameter-fsm.json: analyzer.org
	sed 's/$$$\{BUILDDIR}/$(ESCAPED_BUILDDIR)/g' $< | org-tangle -

$(BUILDDIR)/action_fsm.py: $(BUILDDIR)/action-fsm.xlsx
	fsmc.py $< -t python

$(BUILDDIR)/action-fsm.xlsx: $(BUILDDIR)/action-fsm.json
	fsmc.py $< -t excel

$(BUILDDIR)/action-fsm.json: analyzer.org
	sed 's/$$$\{BUILDDIR}/$(ESCAPED_BUILDDIR)/g' $< | org-tangle -

$(BUILDDIR)/guard_fsm.py: $(BUILDDIR)/guard-fsm.xlsx
	fsmc.py $< -t python

$(BUILDDIR)/guard-fsm.xlsx: $(BUILDDIR)/guard-fsm.json
	fsmc.py $< -t excel

$(BUILDDIR)/guard-fsm.json: analyzer.org
	sed 's/$$$\{BUILDDIR}/$(ESCAPED_BUILDDIR)/g' $< | org-tangle -

$(BUILDDIR)/lexer_fsm.py: $(BUILDDIR)/lexer-fsm.xlsx
	fsmc.py $< -t python

$(BUILDDIR)/lexer-fsm.xlsx: $(BUILDDIR)/lexer-fsm.json
	fsmc.py $< -t excel

$(BUILDDIR)/lexer-fsm.json: analyzer.org
	sed 's/$$$\{BUILDDIR}/$(ESCAPED_BUILDDIR)/g' $< | org-tangle -

clean:
	rm -rf $(BUILDDIR)

.PHONY: all clean
