NAME=fsmc

include .config
ESCAPED_BUILDDIR = $(shell echo '${BUILDDIR}' | sed 's%/%\\/%g')
TARGET=fsmc.py model.py jsonio.py python.py utility.py excel.py semantic.py analyzer.py lexer.py table.py pony.py
SYMFSM=parameter_fsm.py action_fsm.py guard_fsm.py
LEXFSM=lexer_fsm.py
TABLEFSM=table_fsm.py

vpath %.org .
vpath %.py $(BUILDDIR)
vpath %.txt $(BUILDDIR)

all: $(TARGET) $(SYMFSM) $(LEXFSM) $(TABLEFSM)
	chmod 755 $(BUILDDIR)/fsmc.py

$(TARGET): %.py: %.org
	sed 's/$$$\{BUILDDIR}/$(ESCAPED_BUILDDIR)/g' $< | org-tangle -

$(TABLEFSM): %.py: %.txt
	fsmc.py $(addprefix $(BUILDDIR)/, $(notdir $<)) -t python

$(subst .py,.txt,$(TABLEFSM)): table.org
	sed 's/$$$\{BUILDDIR}/$(ESCAPED_BUILDDIR)/g' $< | org-tangle -

$(SYMFSM): %.py: %.txt
	fsmc.py $(addprefix $(BUILDDIR)/, $(notdir $<)) -t python

$(subst .py,.txt,$(SYMFSM)): analyzer.org
	sed 's/$$$\{BUILDDIR}/$(ESCAPED_BUILDDIR)/g' $< | org-tangle -

$(LEXFSM): %.py: %.txt
	fsmc.py $(addprefix $(BUILDDIR)/, $(notdir $<)) -t python

$(subst .py,.txt,$(LEXFSM)): lexer.org
	sed 's/$$$\{BUILDDIR}/$(ESCAPED_BUILDDIR)/g' $< | org-tangle -

clean:
	rm -rf $(BUILDDIR)

.PHONY: all clean
