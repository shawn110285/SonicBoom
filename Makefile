CC      = g++
AR      = ar
ARFLAGS = -r
LD      = ld
LDFLAGS =

# the linked lib
STANDARD_LIBS     =
STANDARD_LIBS_DIR =

MAKE   = make
# the rm comand
RM = rm -rf

LOCAL_LIBS := ./sim/obj_dir/libtb.a ./rtl/obj_dir/VTestHarness__ALL.a ./DRAMSim2/libdramsim.a

# the bin file name
target = tb

# the dependant libs
rtl/obj_dir/VTestHarness__ALL.a:
	$(MAKE) -C ./rtl -f rtl.mk all

sim/obj_dir/libtb.a: ./rtl/obj_dir/VTestHarness__ALL.a
	$(MAKE) -C ./sim -f sim.mk all

DRAMSim2/libdramsim.a:
	$(MAKE) -C ./DRAMSim2 libdramsim.a

# All Target
all: $(target)

# link the libs into a executable bin file  # $(STANDARD_LIBS) $(LOCAL_LIBS)
$(target): $(LOCAL_LIBS)
	@echo 'Building target: $@'
	@echo 'Invoking: gcc C Linker'
	$(CC) $(STANDARD_LIBS_DIR) -o $(target) $(STANDARD_LIBS) $(LOCAL_LIBS) $(LOCAL_LIBS)
	@echo 'Finished building target: $@'
	@echo ' '

# Other Targets
clean:
# clean the sub dir's object and libs
	$(MAKE) -C ./sim -f sim.mk clean
	$(MAKE) -C ./rtl -f rtl.mk clean
	$(MAKE) -C ./DRAMSim2 clean

# clean the target
	$(RM) $(target)
	@echo ' '

.PHONY: all clean
