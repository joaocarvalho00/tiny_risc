# Makefile

# defaults
SIM ?= verilator
TOPLEVEL_LANG ?= verilog

SRC_DIR = /home/joaocarvalho00/Projects/tiny_risc/src

VERILOG_SOURCES += $(SRC_DIR)/cpu.sv

# TOPLEVEL is the name of the toplevel module in your Verilog or VHDL file
TOPLEVEL = cpu

# MODULE is the basename of the Python test file
MODULE = tb_cpu_first_test

EXTRA_ARGS += --trace

# include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim