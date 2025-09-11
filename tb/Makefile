# Makefile

# defaults
SIM ?= verilator
TOPLEVEL_LANG ?= verilog

SRC_DIR = /home/joaocarvalho00/Projects/tiny_risc/src

VERILOG_SOURCES += $(SRC_DIR)/tiny_risc_pkg.sv
VERILOG_SOURCES += $(SRC_DIR)/tiny_risc_regfile.sv
VERILOG_SOURCES += $(SRC_DIR)/tiny_risc_pc.sv
VERILOG_SOURCES += $(SRC_DIR)/tiny_risc_alu.sv
VERILOG_SOURCES += $(SRC_DIR)/tiny_risc.sv

# TOPLEVEL is the name of the toplevel module in your Verilog or VHDL file
TOPLEVEL ?= tiny_risc

# MODULE is the basename of the Python test file
MODULE ?= tb_$(TOPLEVEL)_test

EXTRA_ARGS += --trace

# include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim

# Location of waveform dump (adjust if your sim uses another name or dir)
WAVEFORM ?= dump.vcd

# Recipe to open GTKWave
.PHONY: wave
waves:
	@if [ -f $(WAVEFORM) ]; then \
		echo "Opening $(WAVEFORM) with GTKWave..."; \
		gtkwave $(WAVEFORM) & \
	else \
		echo "Waveform file $(WAVEFORM) not found. Run 'make' first."; \
	fi