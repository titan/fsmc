NAME=fsmc

include .config
ESCAPED_BUILDDIR = $(shell echo '${BUILDDIR}' | sed 's%/%\\/%g')
TARGET=fsmc.py model.py jsonio.py python.py utility.py excel.py semantic.py analyzer.py lexer.py table.py pony.py nim.py
SYMFSM=action_fsm.py guard_fsm.py
SYMBNFFSM=header_fsm.py
LEXFSM=lexer_fsm.py
TABLEFSM=table_fsm.py

vpath %.org .
vpath %.py $(BUILDDIR)
vpath %.txt $(BUILDDIR)
vpath %.bnf $(BUILDDIR)

all: $(TARGET) $(SYMFSM) $(SYMBNFFSM) $(LEXFSM) $(TABLEFSM)
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

$(SYMBNFFSM): %.py: %.txt
	fsmc.py $(addprefix $(BUILDDIR)/, $(notdir $<)) -t python

$(subst .py,.txt,$(SYMBNFFSM)): %.txt: %.bnf
	bnf2fsm.py $(addprefix $(BUILDDIR)/, $(notdir $<)) $(addprefix $(BUILDDIR)/, $(notdir $@)) --fsmc

$(subst .py,.bnf,$(SYMBNFFSM)): analyzer.org
	sed 's/$$$\{BUILDDIR}/$(ESCAPED_BUILDDIR)/g' $< | org-tangle -

$(LEXFSM): %.py: %.txt
	fsmc.py $(addprefix $(BUILDDIR)/, $(notdir $<)) -t python

$(subst .py,.txt,$(LEXFSM)): lexer.org
	sed 's/$$$\{BUILDDIR}/$(ESCAPED_BUILDDIR)/g' $< | org-tangle -

clean:
	rm -rf $(BUILDDIR)

.PHONY: all clean
