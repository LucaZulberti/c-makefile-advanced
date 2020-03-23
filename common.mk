SRCDIR := src
INCDIR := include
OBJDIR := .obj

CFLAGS := -Wall -O2 -I$(INCDIR)

# Used to copy the source tree in the object tree
SRCDIRS := $(shell find src -type d)
OBJDIRS := $(addprefix $(OBJDIR)/,$(SRCDIRS))

all: $(TARGETS)
	@echo All targets have been compiled successfully.
	@echo -\> $^

$(OBJDIRS):
	mkdir -p $(OBJDIRS)

.PHONY: clean

clean: $(addsuffix _clean, $(TARGETS) $(LIBS))
	rm -rf $(OBJDIR)


