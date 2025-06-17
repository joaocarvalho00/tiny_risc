package tb_cpu_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    `include "tb_cpu_seq_item.sv"
    `include "tb_cpu_driver.sv"
    `include "tb_cpu_monitor.sv"
    `include "tb_cpu_sequencer.sv"
    `include "tb_cpu_agent.sv"
    `include "tb_cpu_scoreboard.sv"
    `include "tb_cpu_env.sv"
    `include "tb_cpu_seq_lib.sv"
    `include "tb_cpu_sequence.sv"
    `include "tb_cpu_test.sv"

    // `include "dut_env.sv"
    // `include "pipe_sequence_lib.sv"
    // `include "test_lib.sv"
endpackage : tb_cpu_pkg