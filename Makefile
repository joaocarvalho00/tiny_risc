export UVM_HOME="/home/joaocarvalho00/Projects/verilator-verification-features-tests/uvm/uvm-2017/src"
UVM_PKG="${UVM_HOME}/uvm_pkg.sv"

DISABLED_WARNINGS=" -Wno-DECLFILENAME    \
                    -Wno-CONSTRAINTIGN   \
                    -Wno-MISINDENT       \
                    -Wno-VARHIDDEN       \
                    -Wno-WIDTHTRUNC      \
                    -Wno-CASTCONST       \
                    -Wno-WIDTHEXPAND     \
                    -Wno-UNDRIVEN        \
                    -Wno-UNUSEDSIGNAL    \
                    -Wno-UNUSEDPARAM     \
                    -Wno-ZERODLY         \
                    -Wno-SYMRSVDWORD     \
                    -Wno-CASEINCOMPLETE  \
                    -Wno-SIDEEFFECT      \
                    -Wno-REALCVT"

PHONY:  build run clean

build:
	verilator \
	    --binary \
        --build \
        --cc \
        --top-module tb_cpu \
        --timing \
        --exe \
	    --trace \
        --Mdir verilator_obj_dir \
        -j 1 \
        --CFLAGS "-std=c++20" \
	    +incdir+${UVM_HOME} \
        +incdir+src \
        +incdir+tb \
	    ${UVM_PKG} \
        +define+UVM_REPORT_DISABLE_FILE_LINE \
        +define+SVA_ON \
        +define+UVM_NO_DPI \
        tb/tb_cpu_pkg.sv \
        tb/tb_cpu_if.sv \
        src/cpu.sv \
        tb/tb_cpu.sv \
        -Wno-DECLFILENAME    \
        -Wno-CONSTRAINTIGN   \
        -Wno-MISINDENT       \
        -Wno-VARHIDDEN       \
        -Wno-WIDTHTRUNC      \
        -Wno-CASTCONST       \
        -Wno-WIDTHEXPAND     \
        -Wno-UNDRIVEN        \
        -Wno-UNUSEDSIGNAL    \
        -Wno-UNUSEDPARAM     \
        -Wno-ZERODLY         \
        -Wno-SYMRSVDWORD     \
        -Wno-CASEINCOMPLETE  \
        -Wno-SIDEEFFECT      \
        -Wno-REALCVT

clean:
	rm -rf verilator_obj_dir