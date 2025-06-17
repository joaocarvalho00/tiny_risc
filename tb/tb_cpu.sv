
import uvm_pkg::*;
`include "uvm_macros.svh"

module tb_cpu;

    logic clk;
    cpu_if vif(clk);  // Instantiate the virtual interface with clk binding

    // Instantiate DUT and connect to interface
    cpu dut (
        .clk(clk),
        .rst(vif.rst),
        .q(vif.in_q),
        .d(vif.out_d)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk; // 100 MHz clock

    // Simulation control
    initial begin
        // Set the virtual interface so components and sequences can access it
        uvm_config_db#(virtual cpu_if)::set(null, "*", "vif", vif);

        // Start UVM test
        run_test("tb_cpu_test");
    end

    initial begin
        $dumpfile("wave_dump.vcd");
        $dumpvars(0);
    end

endmodule