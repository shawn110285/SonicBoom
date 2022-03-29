## ===============================================================================
## Purpose:	Builds the hello world tutorial project
## Targets:
##	The (default) or all target will build a verilator simulation for hello world.
##	clean	Removes all build products
## ================================================================================

.PHONY: all
.DELETE_ON_ERROR:

CC      = g++
AR      = ar
ARFLAGS = -r
LD      = ld
LDFLAGS =


## Find the directory containing the Verilog sources.  This is given from
## calling: "verilator -V" and finding the VERILATOR_ROOT output line from
## within it.  From this VERILATOR_ROOT value, we can find all the components
## we need here--in particular, the verilator include directory
VERILATOR = verilator
VERILATOR_ROOT ?= $(shell bash -c '$(VERILATOR) -V|grep VERILATOR_ROOT | head -1 | sed -e "s/^.*=\s*//"')

VINC = $(VERILATOR_ROOT)/include
VINC1 = $(VERILATOR_ROOT)/include/vltstd
VERILOG_OBJ_DIR = ../rtl/obj_dir
DRAMSIM_DIR = ../DRAMSim2


# Modern versions of Verilator and C++ may require an -faligned-new flag
CFLAGS = -g -Wall -faligned-new -c -I$(VINC) -I$(VINC1) -I$(VERILOG_OBJ_DIR) -I$(DRAMSIM_DIR)


# the linked lib
STANDARD_LIBS     =
STANDARD_LIBS_DIR =

TARGET_DIR = ./obj_dir

verilator_obj = $(TARGET_DIR)/verilated_vcd_c.o $(TARGET_DIR)/verilated.o \
				$(TARGET_DIR)/verilated_dpi.o $(TARGET_DIR)/verilated_vpi.o

sim_obj = $(TARGET_DIR)/sim_main.o $(TARGET_DIR)/remote_bitbang.o $(TARGET_DIR)/SimJTAG.o   \
		  $(TARGET_DIR)/SimDRAM.o  $(TARGET_DIR)/mm_dramsim2.o $(TARGET_DIR)/mm.o           \
		  $(TARGET_DIR)/SimUART.o $(TARGET_DIR)/uart.o $(TARGET_DIR)/SimSerial.o

objects = $(verilator_obj)  \
		  $(sim_obj)

target  = $(TARGET_DIR)/libtb.a

$(TARGET_DIR):
	mkdir $@
# ======================= verilator dpi objects =========================
$(TARGET_DIR)/verilated_vcd_c.o: $(VINC)/verilated_vcd_c.cpp $(TARGET_DIR)
	@echo 'Building file: $<'
	@echo 'Invoking: $(CC) C Compiler'
	$(CC) $(CFLAGS)  $< -o $@
	@echo 'Finished building: $<'
	@echo ' '

$(TARGET_DIR)/verilated.o: $(VINC)/verilated.cpp $(TARGET_DIR)
	@echo 'Building file: $<'
	@echo 'Invoking: $(CC) C Compiler'
	$(CC) $(CFLAGS)  $< -o $@
	@echo 'Finished building: $<'
	@echo ' '

$(TARGET_DIR)/verilated_dpi.o: $(VINC)/verilated_dpi.cpp $(TARGET_DIR)
	@echo 'Building file: $<'
	@echo 'Invoking: $(CC) C Compiler'
	$(CC) $(CFLAGS)  $< -o $@
	@echo 'Finished building: $<'
	@echo ' '


$(TARGET_DIR)/verilated_vpi.o: $(VINC)/verilated_vpi.cpp $(TARGET_DIR)
	@echo 'Building file: $<'
	@echo 'Invoking: $(CC) C Compiler'
	$(CC) $(CFLAGS)  $< -o $@
	@echo 'Finished building: $<'
	@echo ' '


# =================================== simulation objects ===================
$(TARGET_DIR)/sim_main.o: sim_main.cc $(TARGET_DIR)
	@echo 'Building file: $<'
	@echo 'Invoking: $(CC) C Compiler'
	$(CC) $(CFLAGS)  $< -o $@
	@echo 'Finished building: $<'
	@echo ' '

$(TARGET_DIR)/remote_bitbang.o: remote_bitbang.cc $(TARGET_DIR)
	@echo 'Building file: $<'
	@echo 'Invoking: $(CC) C Compiler'
	$(CC) $(CFLAGS)  $< -o $@
	@echo 'Finished building: $<'
	@echo ' '

$(TARGET_DIR)/SimJTAG.o: SimJTAG.cc $(TARGET_DIR)
	@echo 'Building file: $<'
	@echo 'Invoking: $(CC) C Compiler'
	$(CC) $(CFLAGS)  $< -o $@
	@echo 'Finished building: $<'
	@echo ' '

$(TARGET_DIR)/SimDRAM.o: SimDRAM.cc $(TARGET_DIR)
	@echo 'Building file: $<'
	@echo 'Invoking: $(CC) C Compiler'
	$(CC) $(CFLAGS)  $< -o $@
	@echo 'Finished building: $<'
	@echo ' '

$(TARGET_DIR)/mm_dramsim2.o: mm_dramsim2.cc $(TARGET_DIR)
	@echo 'Building file: $<'
	@echo 'Invoking: $(CC) C Compiler'
	$(CC) $(CFLAGS)  $< -o $@
	@echo 'Finished building: $<'
	@echo ' '

$(TARGET_DIR)/mm.o: mm.cc $(TARGET_DIR)
	@echo 'Building file: $<'
	@echo 'Invoking: $(CC) C Compiler'
	$(CC) $(CFLAGS)  $< -o $@
	@echo 'Finished building: $<'
	@echo ' '


$(TARGET_DIR)/SimUART.o: SimUART.cc $(TARGET_DIR)
	@echo 'Building file: $<'
	@echo 'Invoking: $(CC) C Compiler'
	$(CC) $(CFLAGS)  $< -o $@
	@echo 'Finished building: $<'
	@echo ' '

$(TARGET_DIR)/uart.o: uart.cc $(TARGET_DIR)
	@echo 'Building file: $<'
	@echo 'Invoking: $(CC) C Compiler'
	$(CC) $(CFLAGS)  $< -o $@
	@echo 'Finished building: $<'
	@echo ' '

$(TARGET_DIR)/SimSerial.o: SimSerial.cc $(TARGET_DIR)
	@echo 'Building file: $<'
	@echo 'Invoking: $(CC) C Compiler'
	$(CC) $(CFLAGS)  $< -o $@
	@echo 'Finished building: $<'
	@echo ' '



# All Target
all: $(target)

$(target): $(objects)
	@echo "===================add simulation objects into library, start=========================="
	@echo "add objects [$(objects)] to lib:$(target)"
	@$(AR) $(ARFLAGS) $(target) $(objects)
	@echo "===================add simulation objects into library, end ==========================="
	@echo ' '

# Other Targets
clean:
	@echo "=========================cleaning simulation objects, start============================"
	$(RM) $(target)
	$(RM) $(objects)
	@echo "=========================cleaning simulation objects, end==============================="


.PHONY: all clean
