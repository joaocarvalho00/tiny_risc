`ifndef VERILATOR
class tb_cpu_sequencer extends uvm_sequencer #(tb_cpu_seq_item);
`else
class tb_cpu_sequencer extends uvm_sequencer #(tb_cpu_seq_item, tb_cpu_seq_item);
`endif

    `uvm_component_utils(tb_cpu_sequencer)

   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction: new

endclass : tb_cpu_sequencer
