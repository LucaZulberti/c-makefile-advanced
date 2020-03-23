
# Set up the source files and object files
$(TARGET)_SRCS := $(addprefix $(SRCDIR)/,$(SOURCES))
$(TARGET)_OBJS := $(addprefix $(OBJDIR)/,$(SOURCES:.c=.o))
$(TARGET)_DEPS := $($(TARGET)_OBJS:.o=.d)
$(TARGET)_LIBS := $(addprefix $(OBJDIR)/,$(addsuffix .a,$(LIBS)))

# Rules
$(TARGET): $($(TARGET)_OBJS) $($(TARGET)_LIBS)
	$(CC) $(CFLAGS) $^ -o $@
	@echo Target $@ compiled successfully.

-include $($(TARGET)_DEPS)

$($(TARGET)_OBJS): $(OBJDIR)/%.o : $(SRCDIR)/%.c | $(OBJDIRS)
	$(CC) $(CFLAGS) -c -MM -MP -MQ '$@' -MF $(patsubst %.o,%.d,$@) $<
	$(CC) $(CFLAGS) -c -o $@ $<

.PHONY: $(TARGET)_clean

$(TARGET)_clean:
	rm -f $(@:_clean=)
