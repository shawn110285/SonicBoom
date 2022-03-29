## ===============================================================================
## Purpose:	Builds the rtl project
## Targets:
##	all:    build a verilator simulation,include the core and the tb.
##	clean:	Removes all build products
##  E-mail:  shawn110285@gmail.com
## ================================================================================

.PHONY: all
.DELETE_ON_ERROR:


#ROOT_DIR := /var/cpu_testbench/koala
RTL_ROOT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

# the rtl files of the cpu core
RTL_DIR :=$(RTL_ROOT_DIR)
INC_DIR :=$(RTL_ROOT_DIR)

CORE_RTL_FILES := $(RTL_DIR)/chipyard.TestHarness.SmallBoomConfig.harness.v      \
				$(RTL_DIR)/chipyard.TestHarness.SmallBoomConfig.top.v          \
				$(RTL_DIR)/chipyard.TestHarness.SmallBoomConfig.top.mems.v     \
				$(RTL_DIR)/chipyard.TestHarness.SmallBoomConfig.harness.mems.v \
				$(RTL_DIR)/plusarg_reader.v                                    \
				$(RTL_DIR)/ClockDividerN.sv                                    \
				$(RTL_DIR)/EICG_wrapper.v                                      \
				$(RTL_DIR)/IOCell.v                                            \
				$(RTL_DIR)/SimDRAM.v                                           \
				$(RTL_DIR)/SimJTAG.v                                           \
				$(RTL_DIR)/SimSerial.v                                         \
				$(RTL_DIR)/SimUART.v

VERILOG_FILES :=  $(CORE_RTL_FILES)

TOP_MOD = TestHarness
VERILOG_OBJ_DIR = obj_dir

VERILATOR = verilator

#-Wall                      Enable all style warnings
#-Wno-style                 Disable all style warnings
#-Werror-<message>          Convert warnings to errors
#-Wno-lint                  Disable all lint warnings
#-Wno-<message>             Disable warning
#-I<dir>                    Directory to search for includes

# INCLUDE_DIR := ../ibex/vendor/lowrisc_ip/ip/prim/rtl/prim_assert.sv
# VFLAGS := --cc -trace -Wall
VFLAGS = --cc -trace   # -Wno-style -DRVFI -Wno-IMPLICIT -Wno-WIDTH -Wno-CASEINCOMPLETE

## Find the directory containing the Verilog sources.  This is given from
## calling: "verilator -V" and finding the VERILATOR_ROOT output line from
## within it.  From this VERILATOR_ROOT value, we can find all the components
## we need here--in particular, the verilator include directory
VERILATOR_ROOT ?= $(shell bash -c '$(VERILATOR) -V|grep VERILATOR_ROOT | head -1 | sed -e "s/^.*=\s*//"')

$(VERILOG_OBJ_DIR):
	mkdir $@

# covert the verilog file into the cpp file
$(VERILOG_OBJ_DIR)/V$(TOP_MOD).cpp: $(VERILOG_FILES)
	@echo "===================compile RTL into cpp files, start=========================="
	$(VERILATOR) $(VFLAGS) -I$(INC_DIR) --top-module $(TOP_MOD) $(VERILOG_FILES) V$(TOP_MOD).cpp
	@echo "===================compile RTL into cpp files, end ==========================="

# create the c++ lib from the above cpp file
$(VERILOG_OBJ_DIR)/V$(TOP_MOD)__ALL.a: $(VERILOG_OBJ_DIR)/V$(TOP_MOD).cpp
	@echo "===============add rtl object files into cpp files, start======================"
#	make --no-print-directory -C $(VERILOG_OBJ_DIR) -f V$(TOP_MOD).mk
	make -C $(VERILOG_OBJ_DIR) -f V$(TOP_MOD).mk
	@echo "===============add rtl object files into cpp files, end======================"

all: $(VERILOG_OBJ_DIR)/V$(TOP_MOD)__ALL.a $(VERILOG_OBJ_DIR)

.PHONY: clean
clean:
	@echo "=========================cleaning RTL objects, start============================"
	rm -rf ./$(VERILOG_OBJ_DIR)/
	@echo "=========================cleaning RTL objects, end============================"

