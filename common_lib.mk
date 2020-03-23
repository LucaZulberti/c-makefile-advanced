
# Set up the source files and object files
$(LIB)_SRCS := $(addprefix $(SRCDIR)/,$(SOURCES))
$(LIB)_OBJS := $(addprefix $(OBJDIR)/,$(SOURCES:.c=.o))
$(LIB)_DEPS := $($(LIB)_OBJS:.o=.d)

# Rules
$(OBJDIR)/$(LIB).a: $($(LIB)_OBJS)
	ar r $@ $^
	@echo LIB $@ archived successfully.

-include $($(LIB)_DEPS)

$($(LIB)_OBJS): $(OBJDIR)/%.o : $(SRCDIR)/%.c | $(OBJDIRS)
	$(CC) $(CFLAGS) -c -MM -MP -MQ '$@' -MF $(patsubst %.o,%.d,$@) $<
	$(CC) $(CFLAGS) -c -o $@ $<

.PHONY: $(LIB)_clean

$(LIB)_clean:
	rm -f $(@:_clean=.a)
