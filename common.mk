# Common Makefile rules
#----------------------
CC = gcc
AR = ar

SRCDIR = src
INCDIR = include
OBJDIR = .obj

# Used to copy the source tree in the object tree
SRCDIRS := $(shell find src/ -type d)
OBJDIRS := $(addprefix $(OBJDIR)/,$(SRCDIRS))

# Common flags
CFLAGS  := -O2 -Wall -I$(INCDIR)
LDFLAGS := -L$(OBJDIR)

# Default rule
.PHONY: all
all: $(TARGETS)
	@echo All targets have been compiled successfully.

# Directories and clean
$(OBJDIRS):
	mkdir -p $(OBJDIRS)

.PHONY: clean

clean: $(addsuffix _clean, $(TARGETS))
	rm -rf $(OBJDIR)


# Rule generation functions
# -------------------------

define make-target
# Set up the source files and object files
$1_SRCS = $$(addprefix $(SRCDIR)/,$$($1_SOURCES))
$1_OBJS = $$(addprefix $(OBJDIR)/,$$($1_SRCS:.c=.o))

$1_LIBS_DEPS = $$(addprefix $(OBJDIR)/lib,$(addsuffix .a,$($1_LIBS)))
$1_LDFLAGS   = $$(foreach lib,$$($1_LIBS),-l$$(lib))

# Add .h dependecies
-include $$($1_OBJS:.o=.d)

# Rules
$1: $$($1_OBJS) $$($1_LIBS_DEPS)
	$(CC) $(LDFLAGS) -o $$@ $$(filter %.o,$$^) $$($1_LDFLAGS)
	@echo Target $1 compiled successfully.

ALL_OBJS   += $$($1_OBJS)

.PHONY: $1_clean

$1_clean:
	rm -f $1
endef

define make-lib
# Set up the source files and object files
$1_SRCS = $(addprefix $(SRCDIR)/,$($1_SOURCES))
$1_OBJS = $$(addprefix $$(OBJDIR)/,$$($1_SRCS:.c=.o))

-include $$($1_OBJS:.o=.d)

# Rules
$(OBJDIR)/lib$1.a: $$($1_OBJS)
	$(AR) cr $$@ $$^
	@echo Library $1 archived successfully.

ALL_OBJS   += $$($1_OBJS)

endef

# Target and libraries rules generation
$(foreach target, $(TARGETS), $(eval $(call make-target,$(target))))
$(foreach lib, $(LIBS), $(eval $(call make-lib,$(lib))))

# Remove possible duplicates
ALL_OBJS   := $(sort $(ALL_OBJS))

$(ALL_OBJS): $(OBJDIR)/%.o : %.c | $(OBJDIRS)
	$(CC) -I$(INCDIR) -MM -MP -MQ '$@' -MF $(patsubst %.o,%.d,$@) $<
	$(CC) $(CFLAGS) -c -o $@ $<
