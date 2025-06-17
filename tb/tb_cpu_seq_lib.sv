class tb_cpu_reset_seq extends uvm_sequence #(tb_cpu_seq_item);

    `uvm_object_utils(tb_cpu_reset_seq)

    virtual cpu_if vif;

    function new(string name = "tb_cpu_reset_seq");
        super.new(name);
    endfunction

    virtual task body();
        if (vif == null)
            `uvm_fatal(get_type_name(), "vif is null in reset sequence!")

        `uvm_info(get_type_name(), "Asserting reset...", UVM_MEDIUM)
        vif.rst <= 0;
        repeat (3) @(posedge vif.clk); // Hold reset for 3 clock cycles
        vif.rst <= 1;
        `uvm_info(get_type_name(), "Deasserting reset", UVM_MEDIUM)
        @(posedge vif.clk); // Let system stabilize
    endtask

endclass : tb_cpu_reset_seq
